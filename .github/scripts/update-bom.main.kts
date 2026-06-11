#!/usr/bin/env kotlin

@file:DependsOn("org.json:json:20251224")

import java.io.File
import java.net.URL
import javax.xml.parsers.DocumentBuilderFactory
import org.w3c.dom.Element
import org.w3c.dom.NodeList
import org.xml.sax.InputSource
import java.io.StringReader
import org.json.JSONObject

// ── Configuration ──────────────────────────────────────────────────────────────

val MAVEN_BASE_URL = "https://repo1.maven.org/maven2/com/moengage"
val SONATYPE_SEARCH_URL = "https://central.sonatype.com/solrsearch/select"
val ANDROID_BOM_ARTIFACT = "android-bom"
val PLUGIN_BASE_BOM_ARTIFACT = "plugin-base-bom"
val MOENGAGE_GROUP = "com.moengage"

val ANDROID_BOM_VERSION_KEY = "moengageNativeBomVersion"
val PLUGIN_BASE_BOM_VERSION_KEY = "moengagePluginBaseBomVersion"

val CHANGELOG_DATE_PLACEHOLDER = "Release Date"
val CHANGELOG_VERSION_PLACEHOLDER = "Release Version"

val DATED_ENTRY_REGEX = Regex("""^# \d{2}-\d{2}-\d{4}$""")
val ANDROID_BOM_LINE_REGEX = Regex("""^\s*- (\[minor\] )?`android-bom` version updated to `[^`]+`\.?$""")

data class ModuleConfig(
    val gradleFilePath: String,
    val androidChangelogPath: String,
    val publicChangelogPath: String,
    val androidBomArtifacts: Set<String>,
    val pluginBaseBomArtifacts: Set<String>
)

val moduleConfigs = listOf(
    ModuleConfig(
        gradleFilePath = "packages/moengage_flutter/moengage_flutter_android/android/build.gradle",
        androidChangelogPath = "packages/moengage_flutter/moengage_flutter_android/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_flutter/moengage_flutter/CHANGELOG.md",
        androidBomArtifacts = setOf("moe-android-sdk", "inapp"),
        pluginBaseBomArtifacts = setOf("plugin-base")
    ),
    ModuleConfig(
        gradleFilePath = "packages/moengage_cards/moengage_cards_android/android/build.gradle",
        androidChangelogPath = "packages/moengage_cards/moengage_cards_android/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_cards/moengage_cards/CHANGELOG.md",
        androidBomArtifacts = setOf("moe-android-sdk", "cards-core"),
        pluginBaseBomArtifacts = setOf("plugin-base-cards")
    ),
    ModuleConfig(
        gradleFilePath = "packages/moengage_geofence/moengage_geofence_android/android/build.gradle",
        androidChangelogPath = "packages/moengage_geofence/moengage_geofence_android/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_geofence/moengage_geofence/CHANGELOG.md",
        androidBomArtifacts = setOf("moe-android-sdk", "geofence"),
        pluginBaseBomArtifacts = setOf("plugin-base-geofence")
    ),
    ModuleConfig(
        gradleFilePath = "packages/moengage_inbox/moengage_inbox_android/android/build.gradle",
        androidChangelogPath = "packages/moengage_inbox/moengage_inbox_android/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_inbox/moengage_inbox/CHANGELOG.md",
        androidBomArtifacts = setOf("moe-android-sdk", "inbox-core"),
        pluginBaseBomArtifacts = setOf("plugin-base-inbox")
    ),
    ModuleConfig(
        gradleFilePath = "packages/moengage_personalize/moengage_personalize_android/android/build.gradle",
        androidChangelogPath = "packages/moengage_personalize/moengage_personalize_android/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_personalize/moengage_personalize/CHANGELOG.md",
        androidBomArtifacts = setOf("moe-android-sdk", "personalization-core"),
        pluginBaseBomArtifacts = setOf("plugin-base-personalization")
    )
)

// ── Fetch Latest Version from Maven Central ────────────────────────────────────

fun fetchLatestVersion(artifactId: String): String {
    val url = "$SONATYPE_SEARCH_URL?q=g:$MOENGAGE_GROUP+AND+a:$artifactId&core=gav&rows=1&wt=json&sort=version+desc"
    println("  Fetching latest version for $artifactId...")
    val response = URL(url).readText()
    val json = JSONObject(response)
    val docs = json.getJSONObject("response").getJSONArray("docs")
    if (docs.length() == 0) {
        error("No versions found for $MOENGAGE_GROUP:$artifactId on Maven Central")
    }
    val latestVersion = docs.getJSONObject(0).getString("v")
    println("  Latest version: $latestVersion")
    return latestVersion
}

// ── BOM POM Parsing ────────────────────────────────────────────────────────────

fun fetchBomDependencies(bomArtifact: String, bomVersion: String): Map<String, String> {
    val url = "$MAVEN_BASE_URL/$bomArtifact/$bomVersion/$bomArtifact-$bomVersion.pom"
    println("  Fetching: $url")
    val pomXml = URL(url).readText()

    val factory = DocumentBuilderFactory.newInstance()
    val builder = factory.newDocumentBuilder()
    val document = builder.parse(InputSource(StringReader(pomXml)))

    val dependencies = mutableMapOf<String, String>()
    val depNodes: NodeList = document.getElementsByTagName("dependency")
    for (i in 0 until depNodes.length) {
        val dep = depNodes.item(i) as Element
        val groupId = dep.getElementsByTagName("groupId").item(0)?.textContent ?: continue
        val artifactId = dep.getElementsByTagName("artifactId").item(0)?.textContent ?: continue
        val version = dep.getElementsByTagName("version").item(0)?.textContent ?: continue
        if (groupId == "com.moengage") {
            dependencies[artifactId] = version
        }
    }
    return dependencies
}

fun findChangedArtifacts(bomArtifact: String, oldVersion: String, newVersion: String): Set<String> {
    if (oldVersion == newVersion) {
        println("  $bomArtifact version unchanged ($oldVersion), skipping.")
        return emptySet()
    }

    println("  Comparing $bomArtifact: $oldVersion -> $newVersion")
    val oldDeps = fetchBomDependencies(bomArtifact, oldVersion)
    val newDeps = fetchBomDependencies(bomArtifact, newVersion)

    val changed = mutableSetOf<String>()
    for ((artifact, newVer) in newDeps) {
        val oldVer = oldDeps[artifact]
        if (oldVer != newVer) {
            println("    Changed: $artifact ($oldVer -> $newVer)")
            changed.add(artifact)
        }
    }
    for (artifact in oldDeps.keys - newDeps.keys) {
        println("    Removed: $artifact")
        changed.add(artifact)
    }
    if (changed.isEmpty()) {
        println("    No artifact version changes detected.")
    }
    return changed
}

// ── Gradle File Update ─────────────────────────────────────────────────────────

fun readCurrentVersion(file: File, versionKey: String): String? {
    val regex = Regex("""$versionKey\s*=\s*"([^"]+)"""")
    for (line in file.readLines()) {
        val match = regex.find(line)
        if (match != null) return match.groupValues[1]
    }
    return null
}

fun updateVersionInFile(file: File, versionKey: String, oldVersion: String, newVersion: String) {
    val updated = file.readText().replace(
        """$versionKey = "$oldVersion"""",
        """$versionKey = "$newVersion""""
    )
    file.writeText(updated)
}

// ── Changelog Update — Android Package ────────────────────────────────────────
//
// Format written into an unreleased section:
//   - [minor] `android-bom` version updated to `X.Y.Z`.
//
// The [minor] tag is read by the pre-release script to determine the release type.
// It is stripped out automatically when the version is stamped at release time.

fun updateAndroidChangelog(file: File, newAndroidBomVersion: String) {
    val bomEntry = "- [minor] `android-bom` version updated to `$newAndroidBomVersion`."
    val lines = file.readLines().toMutableList()
    val hasUnreleased = lines.any { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }

    if (hasUnreleased) {
        val releaseVersionIdx = lines.indexOfFirst { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }
        val nextHeaderIdx = lines.subList(releaseVersionIdx + 1, lines.size)
            .indexOfFirst { it.startsWith("#") }
            .let { if (it < 0) lines.size else releaseVersionIdx + 1 + it }

        val existingBomIdx = lines.subList(releaseVersionIdx, nextHeaderIdx)
            .indexOfFirst { ANDROID_BOM_LINE_REGEX.matches(it.trim()) }
            .let { if (it < 0) -1 else releaseVersionIdx + it }

        if (existingBomIdx >= 0) {
            lines[existingBomIdx] = bomEntry
        } else {
            var insertAt = nextHeaderIdx
            while (insertAt > releaseVersionIdx + 1 && lines[insertAt - 1].isBlank()) insertAt--
            lines.add(insertAt, bomEntry)
        }
    } else {
        val firstDatedIdx = lines.indexOfFirst { it.matches(DATED_ENTRY_REGEX) }
        val insertAt = if (firstDatedIdx >= 0) firstDatedIdx else lines.size
        lines.addAll(insertAt, listOf(
            "# $CHANGELOG_DATE_PLACEHOLDER", "", "## $CHANGELOG_VERSION_PLACEHOLDER", "", bomEntry, ""
        ))
    }

    file.writeText(lines.joinToString("\n") + "\n")
}

// ── Changelog Update — Public Package ─────────────────────────────────────────
//
// Format written into an unreleased section:
//   - Android
//     - [minor] `android-bom` version updated to `X.Y.Z`.

fun updatePublicChangelog(file: File, newAndroidBomVersion: String) {
    val androidSectionHeader = "- Android"
    val bomEntry = "  - [minor] `android-bom` version updated to `$newAndroidBomVersion`."
    val lines = file.readLines().toMutableList()
    val hasUnreleased = lines.any { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }

    if (hasUnreleased) {
        val releaseVersionIdx = lines.indexOfFirst { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }
        val nextHeaderIdx = lines.subList(releaseVersionIdx + 1, lines.size)
            .indexOfFirst { it.startsWith("#") }
            .let { if (it < 0) lines.size else releaseVersionIdx + 1 + it }

        val unreleasedLines = lines.subList(releaseVersionIdx, nextHeaderIdx)

        val androidSectionIdx = unreleasedLines
            .indexOfFirst { it.trim() == androidSectionHeader }
            .let { if (it < 0) -1 else releaseVersionIdx + it }

        if (androidSectionIdx >= 0) {
            val androidContent = lines.subList(androidSectionIdx + 1, nextHeaderIdx)
            val existingBomIdx = androidContent
                .indexOfFirst { ANDROID_BOM_LINE_REGEX.matches(it.trim()) }
                .let { if (it < 0) -1 else androidSectionIdx + 1 + it }

            if (existingBomIdx >= 0) {
                lines[existingBomIdx] = bomEntry
            } else {
                lines.add(androidSectionIdx + 1, bomEntry)
            }
        } else {
            // No Android section yet — insert before any other sections (e.g. iOS) so Android appears first
            var insertAt = releaseVersionIdx + 1
            while (insertAt < nextHeaderIdx && lines[insertAt].isBlank()) insertAt++
            lines.add(insertAt, bomEntry)
            lines.add(insertAt, androidSectionHeader)
        }
    } else {
        val firstDatedIdx = lines.indexOfFirst { it.matches(DATED_ENTRY_REGEX) }
        val insertAt = if (firstDatedIdx >= 0) firstDatedIdx else lines.size
        lines.addAll(insertAt, listOf(
            "# $CHANGELOG_DATE_PLACEHOLDER", "", "## $CHANGELOG_VERSION_PLACEHOLDER", "",
            androidSectionHeader, bomEntry, ""
        ))
    }

    file.writeText(lines.joinToString("\n") + "\n")
}

// ── Main ───────────────────────────────────────────────────────────────────────

fun updateBom() {
    val projectRoot = File(".").canonicalFile
    println("Project root: $projectRoot")

    println()
    println("Fetching latest BOM versions from Maven Central...")
    val newAndroidBomVersion = fetchLatestVersion(ANDROID_BOM_ARTIFACT)
    val newPluginBaseBomVersion = fetchLatestVersion(PLUGIN_BASE_BOM_ARTIFACT)

    println()
    println("Latest versions:")
    println("  android-bom: $newAndroidBomVersion")
    println("  plugin-base-bom: $newPluginBaseBomVersion")

    // Read current versions from the core module (source of truth)
    val coreGradleFile = File(projectRoot, moduleConfigs[0].gradleFilePath)
    val currentAndroidBomVersion = readCurrentVersion(coreGradleFile, ANDROID_BOM_VERSION_KEY)
        ?: error("Could not read current $ANDROID_BOM_VERSION_KEY from ${coreGradleFile.path}")
    val currentPluginBaseBomVersion = readCurrentVersion(coreGradleFile, PLUGIN_BASE_BOM_VERSION_KEY)
        ?: error("Could not read current $PLUGIN_BASE_BOM_VERSION_KEY from ${coreGradleFile.path}")

    println()
    println("Current versions:")
    println("  android-bom: $currentAndroidBomVersion")
    println("  plugin-base-bom: $currentPluginBaseBomVersion")
    println()

    println("Analyzing android-bom changes...")
    val androidBomChanged = findChangedArtifacts(ANDROID_BOM_ARTIFACT, currentAndroidBomVersion, newAndroidBomVersion)

    println()
    println("Analyzing plugin-base-bom changes...")
    val pluginBaseBomChanged = findChangedArtifacts(PLUGIN_BASE_BOM_ARTIFACT, currentPluginBaseBomVersion, newPluginBaseBomVersion)

    println()
    println("Updating modules...")

    for (config in moduleConfigs) {
        val gradleFile = File(projectRoot, config.gradleFilePath)
        if (!gradleFile.exists()) {
            println("  WARN: ${config.gradleFilePath} not found, skipping.")
            continue
        }

        val shouldUpdateAndroidBom = currentAndroidBomVersion != newAndroidBomVersion
                && config.androidBomArtifacts.any { it in androidBomChanged }

        val shouldUpdatePluginBaseBom = currentPluginBaseBomVersion != newPluginBaseBomVersion
                && config.pluginBaseBomArtifacts.any { it in pluginBaseBomChanged }

        if (!shouldUpdateAndroidBom && !shouldUpdatePluginBaseBom) {
            println("  SKIP: ${config.gradleFilePath} -- no relevant artifact changes")
            continue
        }

        if (shouldUpdateAndroidBom) {
            updateVersionInFile(gradleFile, ANDROID_BOM_VERSION_KEY, currentAndroidBomVersion, newAndroidBomVersion)
            println("  UPDATED: ${config.gradleFilePath} -- $ANDROID_BOM_VERSION_KEY: $currentAndroidBomVersion -> $newAndroidBomVersion")
        }

        if (shouldUpdatePluginBaseBom) {
            updateVersionInFile(gradleFile, PLUGIN_BASE_BOM_VERSION_KEY, currentPluginBaseBomVersion, newPluginBaseBomVersion)
            println("  UPDATED: ${config.gradleFilePath} -- $PLUGIN_BASE_BOM_VERSION_KEY: $currentPluginBaseBomVersion -> $newPluginBaseBomVersion")
        }

        if (shouldUpdateAndroidBom) {
            val androidChangelogFile = File(projectRoot, config.androidChangelogPath)
            if (androidChangelogFile.exists()) {
                updateAndroidChangelog(androidChangelogFile, newAndroidBomVersion)
                println("  UPDATED: ${config.androidChangelogPath}")
            } else {
                println("  WARN: ${config.androidChangelogPath} not found, skipping.")
            }

            val publicChangelogFile = File(projectRoot, config.publicChangelogPath)
            if (publicChangelogFile.exists()) {
                updatePublicChangelog(publicChangelogFile, newAndroidBomVersion)
                println("  UPDATED: ${config.publicChangelogPath}")
            } else {
                println("  WARN: ${config.publicChangelogPath} not found, skipping.")
            }
        }
    }

    println()
    println("Done.")
}

// ── Entry Point ────────────────────────────────────────────────────────────────

updateBom()
