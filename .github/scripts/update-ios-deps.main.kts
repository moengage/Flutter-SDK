#!/usr/bin/env kotlin

@file:DependsOn("org.json:json:20251224")

import java.io.File
import java.util.Base64
import org.json.JSONObject

// ── Configuration ──────────────────────────────────────────────────────────────

val MOENGAGE_ORG = "moengage"
val NATIVE_SDK_POD = "MoEngage-iOS-SDK"

val CHANGELOG_DATE_PLACEHOLDER = "Release Date"
val CHANGELOG_VERSION_PLACEHOLDER = "Release Version"

val DATED_ENTRY_REGEX = Regex("""^# \d{2}-\d{2}-\d{4}$""")
val NATIVE_SDK_LINE_REGEX = Regex("""^\s*- (\[minor\] )?Updated `$NATIVE_SDK_POD` to `[^`]+`\.?$""")

data class PodConfig(
    val podName: String,              // e.g. MoEngagePluginBase
    val pluginRepo: String,           // upstream repo slug under moengage org
    val swiftPackageDirName: String,  // slug used in Package.swift `.package(url:)`
    val podspecPath: String,
    val packageSwiftPath: String,
    val iosChangelogPath: String,     // <module>_ios/CHANGELOG.md
    val publicChangelogPath: String,  // <module>/CHANGELOG.md
)

val podConfigs = listOf(
    PodConfig(
        podName = "MoEngagePluginBase",
        pluginRepo = "iOS-PluginBase",
        swiftPackageDirName = "iOS-PluginBase",
        podspecPath = "packages/moengage_flutter/moengage_flutter_ios/ios/moengage_flutter_ios.podspec",
        packageSwiftPath = "packages/moengage_flutter/moengage_flutter_ios/ios/moengage_flutter_ios/Package.swift",
        iosChangelogPath = "packages/moengage_flutter/moengage_flutter_ios/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_flutter/moengage_flutter/CHANGELOG.md",
    ),
    PodConfig(
        podName = "MoEngagePluginCards",
        pluginRepo = "apple-plugin-cards",
        swiftPackageDirName = "apple-plugin-cards",
        podspecPath = "packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios.podspec",
        packageSwiftPath = "packages/moengage_cards/moengage_cards_ios/ios/moengage_cards_ios/Package.swift",
        iosChangelogPath = "packages/moengage_cards/moengage_cards_ios/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_cards/moengage_cards/CHANGELOG.md",
    ),
    PodConfig(
        podName = "MoEngagePluginInbox",
        pluginRepo = "apple-plugin-inbox",
        swiftPackageDirName = "apple-plugin-inbox",
        podspecPath = "packages/moengage_inbox/moengage_inbox_ios/ios/moengage_inbox_ios.podspec",
        packageSwiftPath = "packages/moengage_inbox/moengage_inbox_ios/ios/moengage_inbox_ios/Package.swift",
        iosChangelogPath = "packages/moengage_inbox/moengage_inbox_ios/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_inbox/moengage_inbox/CHANGELOG.md",
    ),
    PodConfig(
        podName = "MoEngagePluginGeofence",
        pluginRepo = "apple-plugin-geofence",
        swiftPackageDirName = "apple-plugin-geofence",
        podspecPath = "packages/moengage_geofence/moengage_geofence_ios/ios/moengage_geofence_ios.podspec",
        packageSwiftPath = "packages/moengage_geofence/moengage_geofence_ios/ios/moengage_geofence_ios/Package.swift",
        iosChangelogPath = "packages/moengage_geofence/moengage_geofence_ios/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_geofence/moengage_geofence/CHANGELOG.md",
    ),
    PodConfig(
        podName = "MoEngagePluginPersonalize",
        pluginRepo = "apple-plugin-personalize",
        swiftPackageDirName = "apple-plugin-personalize",
        podspecPath = "packages/moengage_personalize/moengage_personalize_ios/ios/moengage_personalize_ios.podspec",
        packageSwiftPath = "packages/moengage_personalize/moengage_personalize_ios/ios/moengage_personalize_ios/Package.swift",
        iosChangelogPath = "packages/moengage_personalize/moengage_personalize_ios/CHANGELOG.md",
        publicChangelogPath = "packages/moengage_personalize/moengage_personalize/CHANGELOG.md",
    ),
)

data class UpstreamVersions(val podVersion: String, val nativeSdkVerMin: String)

// ── Fetch upstream package.json via gh CLI ─────────────────────────────────────

fun fetchUpstreamVersions(repo: String): UpstreamVersions {
    val process = ProcessBuilder(
        "gh", "api", "repos/$MOENGAGE_ORG/$repo/contents/package.json"
    ).redirectErrorStream(false).start()
    val stdout = process.inputStream.bufferedReader().readText()
    val stderr = process.errorStream.bufferedReader().readText()
    val exit = process.waitFor()
    if (exit != 0) {
        error("gh api failed for $repo (exit $exit): $stderr")
    }
    val apiJson = JSONObject(stdout)
    val contentBase64 = apiJson.getString("content").replace("\n", "")
    val decoded = String(Base64.getDecoder().decode(contentBase64))
    val pkg = JSONObject(decoded)
    val podVersion = pkg.getJSONArray("packages").getJSONObject(0).getString("version")
    val sdkVerMin = pkg.getString("sdkVerMin")
    return UpstreamVersions(podVersion, sdkVerMin)
}

// ── Podspec read/write ─────────────────────────────────────────────────────────

fun readPodspecPinnedVersion(file: File, podName: String): String? {
    // s.dependency 'MoEngagePluginBase', '6.8.2'  (single or double quotes)
    val regex = Regex("""s\.dependency\s+['"]${Regex.escape(podName)}['"]\s*,\s*['"]([0-9][^'"]*)['"]""")
    return regex.find(file.readText())?.groupValues?.get(1)
}

fun rewritePodspec(file: File, podName: String, oldVersion: String, newVersion: String) {
    val text = file.readText()
    // Try single-quote then double-quote form. Replace only the first occurrence.
    val singleOld = "s.dependency '$podName', '$oldVersion'"
    val singleNew = "s.dependency '$podName', '$newVersion'"
    val doubleOld = "s.dependency \"$podName\", \"$oldVersion\""
    val doubleNew = "s.dependency \"$podName\", \"$newVersion\""
    val updated = when {
        text.contains(singleOld) -> text.replace(singleOld, singleNew)
        text.contains(doubleOld) -> text.replace(doubleOld, doubleNew)
        else -> error("Could not find pinned dependency line for $podName at version $oldVersion in ${file.path}")
    }
    file.writeText(updated)
}

// ── Package.swift read/write ───────────────────────────────────────────────────

fun readPackageSwiftPinnedVersion(file: File, swiftPackageDirName: String): String? {
    val regex = Regex(
        """\.package\(\s*url:\s*"https://github\.com/$MOENGAGE_ORG/${Regex.escape(swiftPackageDirName)}(?:\.git)?"\s*,\s*exact:\s*"([0-9][^"]*)""""
    )
    return regex.find(file.readText())?.groupValues?.get(1)
}

fun rewritePackageSwift(
    file: File, swiftPackageDirName: String, oldVersion: String, newVersion: String
) {
    val text = file.readText()
    // Build the exact-form string. Current state: all 4 files use ".git" suffix.
    val gitForm = ".package(url: \"https://github.com/$MOENGAGE_ORG/$swiftPackageDirName.git\", exact: \"$oldVersion\")"
    val gitFormNew = ".package(url: \"https://github.com/$MOENGAGE_ORG/$swiftPackageDirName.git\", exact: \"$newVersion\")"
    val noGitForm = ".package(url: \"https://github.com/$MOENGAGE_ORG/$swiftPackageDirName\", exact: \"$oldVersion\")"
    val noGitFormNew = ".package(url: \"https://github.com/$MOENGAGE_ORG/$swiftPackageDirName\", exact: \"$newVersion\")"
    val updated = when {
        text.contains(gitForm) -> text.replace(gitForm, gitFormNew)
        text.contains(noGitForm) -> text.replace(noGitForm, noGitFormNew)
        else -> error("Could not find SPM dependency line for $swiftPackageDirName at version $oldVersion in ${file.path}")
    }
    file.writeText(updated)
}

// ── Changelog Update — iOS Package ────────────────────────────────────────────
//
// Format written into an unreleased section:
//   - [minor] Updated `MoEngage-iOS-SDK` to `X.Y.Z`.
//
// The [minor] tag is read by the pre-release script to determine the release type.
// It is stripped out automatically when the version is stamped at release time.

fun updateIosChangelog(file: File, newNativeSdkVersion: String) {
    val entry = "- [minor] Updated `$NATIVE_SDK_POD` to `$newNativeSdkVersion`."
    val lines = file.readLines().toMutableList()
    val hasUnreleased = lines.any { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }

    if (hasUnreleased) {
        val releaseVersionIdx = lines.indexOfFirst { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }
        val nextHeaderIdx = lines.subList(releaseVersionIdx + 1, lines.size)
            .indexOfFirst { it.startsWith("#") }
            .let { if (it < 0) lines.size else releaseVersionIdx + 1 + it }

        val existingIdx = lines.subList(releaseVersionIdx, nextHeaderIdx)
            .indexOfFirst { NATIVE_SDK_LINE_REGEX.matches(it.trim()) }
            .let { if (it < 0) -1 else releaseVersionIdx + it }

        if (existingIdx >= 0) {
            lines[existingIdx] = entry
        } else {
            var insertAt = nextHeaderIdx
            while (insertAt > releaseVersionIdx + 1 && lines[insertAt - 1].isBlank()) insertAt--
            lines.add(insertAt, entry)
        }
    } else {
        val firstDatedIdx = lines.indexOfFirst { it.matches(DATED_ENTRY_REGEX) }
        val insertAt = if (firstDatedIdx >= 0) firstDatedIdx else lines.size
        lines.addAll(insertAt, listOf(
            "# $CHANGELOG_DATE_PLACEHOLDER", "", "## $CHANGELOG_VERSION_PLACEHOLDER", "", entry, ""
        ))
    }

    file.writeText(lines.joinToString("\n") + "\n")
}

// ── Changelog Update — Public Package ─────────────────────────────────────────
//
// Format written into an unreleased section:
//   - iOS
//       - [minor] Updated `MoEngage-iOS-SDK` to `X.Y.Z`.
//
// Indent under `- iOS` is 4 spaces (matches historical public CHANGELOG entries).
// If `- Android` heading is present, `- iOS` is inserted AFTER it.

fun updatePublicChangelog(file: File, newNativeSdkVersion: String) {
    val iosSectionHeader = "- iOS"
    val androidSectionHeader = "- Android"
    val entry = "    - [minor] Updated `$NATIVE_SDK_POD` to `$newNativeSdkVersion`."
    val lines = file.readLines().toMutableList()
    val hasUnreleased = lines.any { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }

    if (hasUnreleased) {
        val releaseVersionIdx = lines.indexOfFirst { it.contains(CHANGELOG_VERSION_PLACEHOLDER) }
        val nextHeaderIdx = lines.subList(releaseVersionIdx + 1, lines.size)
            .indexOfFirst { it.startsWith("#") }
            .let { if (it < 0) lines.size else releaseVersionIdx + 1 + it }

        val unreleasedLines = lines.subList(releaseVersionIdx, nextHeaderIdx)

        val iosSectionIdx = unreleasedLines
            .indexOfFirst { it.trim() == iosSectionHeader }
            .let { if (it < 0) -1 else releaseVersionIdx + it }

        if (iosSectionIdx >= 0) {
            // Find end of iOS subsection: stops at next top-level `- ` bullet or next header
            val iosContentEnd = lines.subList(iosSectionIdx + 1, nextHeaderIdx)
                .indexOfFirst { it.startsWith("- ") && it.trim() != iosSectionHeader }
                .let { if (it < 0) nextHeaderIdx else iosSectionIdx + 1 + it }

            val existingIdx = lines.subList(iosSectionIdx + 1, iosContentEnd)
                .indexOfFirst { NATIVE_SDK_LINE_REGEX.matches(it.trim()) }
                .let { if (it < 0) -1 else iosSectionIdx + 1 + it }

            if (existingIdx >= 0) {
                lines[existingIdx] = entry
            } else {
                // Insert at end of iOS subsection (before blank lines / next section)
                var insertAt = iosContentEnd
                while (insertAt > iosSectionIdx + 1 && lines[insertAt - 1].isBlank()) insertAt--
                lines.add(insertAt, entry)
            }
        } else {
            // iOS section not present — insert AFTER Android section if it exists,
            // otherwise at the start of the unreleased block.
            val androidSectionIdx = unreleasedLines
                .indexOfFirst { it.trim() == androidSectionHeader }
                .let { if (it < 0) -1 else releaseVersionIdx + it }

            val insertAt = if (androidSectionIdx >= 0) {
                // Find end of Android subsection
                lines.subList(androidSectionIdx + 1, nextHeaderIdx)
                    .indexOfFirst { it.startsWith("- ") && it.trim() != androidSectionHeader }
                    .let { if (it < 0) nextHeaderIdx else androidSectionIdx + 1 + it }
                    .let { idx ->
                        var i = idx
                        while (i > androidSectionIdx + 1 && lines[i - 1].isBlank()) i--
                        i
                    }
            } else {
                var i = releaseVersionIdx + 1
                while (i < nextHeaderIdx && lines[i].isBlank()) i++
                i
            }

            lines.add(insertAt, entry)
            lines.add(insertAt, iosSectionHeader)
        }
    } else {
        val firstDatedIdx = lines.indexOfFirst { it.matches(DATED_ENTRY_REGEX) }
        val insertAt = if (firstDatedIdx >= 0) firstDatedIdx else lines.size
        lines.addAll(insertAt, listOf(
            "# $CHANGELOG_DATE_PLACEHOLDER", "", "## $CHANGELOG_VERSION_PLACEHOLDER", "",
            iosSectionHeader, entry, ""
        ))
    }

    file.writeText(lines.joinToString("\n") + "\n")
}

// ── Main ───────────────────────────────────────────────────────────────────────

fun updateIosDeps() {
    val projectRoot = File(".").canonicalFile
    println("Project root: $projectRoot")
    println()

    val summary = mutableListOf<String>()

    for (config in podConfigs) {
        println("── ${config.podName} ──────────────────────────────")

        val podspecFile = File(projectRoot, config.podspecPath)
        val packageSwiftFile = File(projectRoot, config.packageSwiftPath)

        if (!podspecFile.exists()) {
            println("  WARN: ${config.podspecPath} not found, skipping ${config.podName}.")
            summary += "  WARN  ${config.podName} (podspec missing)"
            continue
        }
        if (!packageSwiftFile.exists()) {
            println("  WARN: ${config.packageSwiftPath} not found, skipping ${config.podName}.")
            summary += "  WARN  ${config.podName} (Package.swift missing)"
            continue
        }

        val upstream = try {
            fetchUpstreamVersions(config.pluginRepo)
        } catch (e: Exception) {
            println("  ERROR fetching upstream package.json for ${config.pluginRepo}: ${e.message}")
            summary += "  ERROR ${config.podName} (upstream fetch failed)"
            continue
        }
        println("  upstream pod version: ${upstream.podVersion}")
        println("  upstream sdkVerMin:   ${upstream.nativeSdkVerMin}")

        val oldPodVer = readPodspecPinnedVersion(podspecFile, config.podName)
            ?: error("Could not parse pinned version for ${config.podName} in ${config.podspecPath}")
        val oldSpmVer = readPackageSwiftPinnedVersion(packageSwiftFile, config.swiftPackageDirName)
            ?: error("Could not parse pinned SPM version for ${config.swiftPackageDirName} in ${config.packageSwiftPath}")

        println("  podspec  pinned: $oldPodVer")
        println("  SPM      pinned: $oldSpmVer")

        if (oldPodVer != oldSpmVer) {
            println("  WARN: podspec ($oldPodVer) and Package.swift ($oldSpmVer) pins disagree — both will be rewritten to ${upstream.podVersion}.")
        }

        if (oldPodVer == upstream.podVersion && oldSpmVer == upstream.podVersion) {
            println("  SKIP-NOOP ${config.podName}: already at ${upstream.podVersion}")
            summary += "  SKIP  ${config.podName} (already at ${upstream.podVersion})"
            continue
        }

        rewritePodspec(podspecFile, config.podName, oldPodVer, upstream.podVersion)
        println("  UPDATED ${config.podspecPath}: $oldPodVer -> ${upstream.podVersion}")

        rewritePackageSwift(packageSwiftFile, config.swiftPackageDirName, oldSpmVer, upstream.podVersion)
        println("  UPDATED ${config.packageSwiftPath}: $oldSpmVer -> ${upstream.podVersion}")

        val iosChangelogFile = File(projectRoot, config.iosChangelogPath)
        if (iosChangelogFile.exists()) {
            updateIosChangelog(iosChangelogFile, upstream.nativeSdkVerMin)
            println("  UPDATED ${config.iosChangelogPath} (MoEngage-iOS-SDK ${upstream.nativeSdkVerMin})")
        } else {
            println("  WARN: ${config.iosChangelogPath} not found, skipping iOS CHANGELOG.")
        }

        val publicChangelogFile = File(projectRoot, config.publicChangelogPath)
        if (publicChangelogFile.exists()) {
            updatePublicChangelog(publicChangelogFile, upstream.nativeSdkVerMin)
            println("  UPDATED ${config.publicChangelogPath} (MoEngage-iOS-SDK ${upstream.nativeSdkVerMin})")
        } else {
            println("  WARN: ${config.publicChangelogPath} not found, skipping public CHANGELOG.")
        }

        summary += "  OK    ${config.podName}: $oldPodVer -> ${upstream.podVersion} (native ${upstream.nativeSdkVerMin})"
        println()
    }

    println()
    println("── Summary ──────────────────────────────")
    summary.forEach { println(it) }
    println()
    println("Done.")
}

// ── Entry Point ────────────────────────────────────────────────────────────────

updateIosDeps()
