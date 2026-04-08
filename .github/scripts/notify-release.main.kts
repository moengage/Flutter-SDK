#!/usr/bin/env kotlin

@file:Import("../../../sdk-automation-scripts/scripts/common/utils.main.kts")

import java.io.File

 private val releaseNotes = args[0]

val packages = listOf(
    "moengage_flutter",
    "moengage_cards",
    "moengage_geofence",
    "moengage_inbox"
)

/**
 * Kotlin script to fetch versions of the top-level MoEngage Flutter packages.
 * 
 * Usage: kotlin scripts/fetch-versions.kts
 * 
 * Run from the Flutter-SDK root directory.
 */

/**
 * Extracts the version from a pubspec.yaml file content.
 */
fun extractVersion(content: String): String? {
    val versionRegex = Regex("""^version:\s*(.+)$""", RegexOption.MULTILINE)
    return versionRegex.find(content)?.groupValues?.get(1)?.trim()
}

/**
 * Fetches version information for all top-level packages.
 * Returns a map where key is package name and value is version.
 */
fun fetchPackageVersions(): Map<String, String> {
    return packages.mapNotNull { packageName ->
        val pubspecPath = File("packages/$packageName/$packageName/pubspec.yaml")
        
        if (!pubspecPath.exists()) {
            println("⚠️  Warning: pubspec.yaml not found for $packageName")
            return@mapNotNull null
        }
        
        val version = extractVersion(pubspecPath.readText())
        if (version != null) {
            packageName to version
        } else {
            println("⚠️  Warning: Could not extract version for $packageName")
            null
        }
    }.toMap()
}

/**
 * Builds a version string with each entry on a new line.
 */
fun buildVersionString(versions: Map<String, String>): String {
    return versions.entries.joinToString("\n") { "${it.key}: ${it.value}" }
}

val versions = fetchPackageVersions()
if (versions.isEmpty()) {
    println("No package versions found.")
} else {
    triggerReleaseNotification(mapOf(
  notifyReleaseFrameworkParameterName to "Flutter SDK",
  notifyReleaseVersionParameterName to "Core version: ${versions["moengage_flutter"]}",
  notifyReleaseMessageParameterName to buildVersionString(versions),
  notifyReleaseReleaseNotesParameterName to releaseNotes
))
}
