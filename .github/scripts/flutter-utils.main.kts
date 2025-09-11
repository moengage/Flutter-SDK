#!/usr/bin/env kotlin

import java.io.File

val packageParentFolder = mapOf(
    "moengage_cards" to "moengage_cards",
    "moengage_cards_android" to "moengage_cards",
    "moengage_cards_ios" to "moengage_cards",
    "moengage_cards_platform_interface" to "moengage_cards",
    "moengage_flutter" to "moengage_flutter",
    "moengage_flutter_android" to "moengage_flutter",
    "moengage_flutter_ios" to "moengage_flutter",
    "moengage_flutter_platform_interface" to "moengage_flutter",
    "moengage_flutter_web" to "moengage_flutter",
    "moengage_geofence" to "moengage_geofence",
    "moengage_geofence_android" to "moengage_geofence",
    "moengage_geofence_ios" to "moengage_geofence",
    "moengage_geofence_platform_interface" to "moengage_geofence",
    "moengage_inbox" to "moengage_inbox",
    "moengage_inbox_android" to "moengage_inbox",
    "moengage_inbox_ios" to "moengage_inbox",
    "moengage_inbox_platform_interface" to "moengage_inbox"
)

val dependencyMapping = mapOf(
    /** Cards Packages */
    "moengage_cards" to mapOf(
        "moengage_cards_android" to "pinned",
        "moengage_cards_ios" to "pinned",
        "moengage_cards_platform_interface" to "pinned",
        "moengage_flutter" to "incremental"
    ),
    "moengage_cards_android" to mapOf(
        "moengage_cards_platform_interface" to "incremental",
        "moengage_flutter" to "incremental"
    ),
    "moengage_cards_ios" to mapOf(
        "moengage_cards_platform_interface" to "incremental",
        "moengage_flutter" to "incremental"
    ),
    "moengage_cards_platform_interface" to mapOf(
        "moengage_flutter" to "incremental"
    ),

    /** Core Packages */
    "moengage_flutter" to mapOf(
        "moengage_flutter_android" to "pinned",
        "moengage_flutter_ios" to "pinned",
        "moengage_flutter_platform_interface" to "pinned",
        "moengage_flutter_web" to "pinned"
    ),
    "moengage_flutter_android" to mapOf(
        "moengage_flutter_platform_interface" to "incremental"
    ),
    "moengage_flutter_ios" to mapOf(
        "moengage_flutter_platform_interface" to "incremental"
    ),
    "moengage_flutter_platform_interface" to emptyMap<String, String>(),
    "moengage_flutter_web" to mapOf(
        "moengage_flutter_platform_interface" to "incremental"
    ),

    /** Geofence Packages */
    "moengage_geofence" to mapOf(
        "moengage_geofence_android" to "pinned",
        "moengage_geofence_ios" to "pinned",
        "moengage_geofence_platform_interface" to "pinned",
        "moengage_flutter" to "incremental"
    ),
    "moengage_geofence_android" to mapOf(
        "moengage_geofence_platform_interface" to "incremental",
        "moengage_flutter" to "incremental"
    ),
    "moengage_geofence_ios" to mapOf(
        "moengage_geofence_platform_interface" to "incremental",
        "moengage_flutter" to "incremental"
    ),
    "moengage_geofence_platform_interface" to mapOf(
        "moengage_flutter" to "incremental"
    ),

    /** Inbox Packages */
    "moengage_inbox" to mapOf(
        "moengage_inbox_android" to "pinned",
        "moengage_inbox_ios" to "pinned",
        "moengage_inbox_platform_interface" to "pinned",
        "moengage_flutter" to "incremental"
    ),
    "moengage_inbox_android" to mapOf(
        "moengage_inbox_platform_interface" to "incremental",
        "moengage_flutter" to "incremental"
    ),
    "moengage_inbox_ios" to mapOf(
        "moengage_inbox_platform_interface" to "incremental",
        "moengage_flutter" to "incremental"
    ),
    "moengage_inbox_platform_interface" to mapOf(
        "moengage_flutter" to "incremental"
    )
)

fun isPackageFile(filePath: String): Boolean {
    return filePath.split("/").first() == "packages"
}

fun getPackageName(filePath: String): String? {
    val packageSegment = filePath.split("/")
    return if (packageSegment.size > 3 && dependencyMapping.containsKey(packageSegment[2])) {
        packageSegment[2]
    } else {
        null
    }
}

fun getPackageFullPath(packageName: String): String {
    return "packages/${packageParentFolder[packageName]}/$packageName"
}

fun updatePackageVersion(packageName: String, updatedVersion: String) {
    updatePackageDependencyVersion(packageName, "version", updatedVersion)
}

fun updatePackageDependencyVersion(
    packageName: String,
    dependencyName: String,
    updatedVersion: String
) {
    val pubspecFile = File("${getPackageFullPath(packageName)}/pubspec.yaml")
    if (!pubspecFile.exists()) {
        throw IllegalArgumentException("pubspec.yaml not found for $packageName")
    }

    val lines = pubspecFile.readLines().toMutableList()
    for (lineNumber in lines.indices) {
        when (dependencyName) {
            "version" -> {
                if (lines[lineNumber].trim().startsWith("$dependencyName:")) {
                    lines[lineNumber] = "$dependencyName: $updatedVersion"
                    break
                }
            }
            
            else -> {
                if (lines[lineNumber].trim().startsWith("$dependencyName:")) {
                    val version = lines[lineNumber].split("$dependencyName:").last()
                    if (doesVersionHasIncrementalPrefix(version)) {
                        lines[lineNumber] = "  $dependencyName: ^$updatedVersion"
                    } else {
                        lines[lineNumber] = "  $dependencyName: $updatedVersion"
                    }
                    break
                }
            }
        }
    }

    pubspecFile.writeText(lines.joinToString("\n"))
}

fun getVersionForPackage(packageName: String, versionIdentifier: String): String {
    val pubspecFile = File("${getPackageFullPath(packageName)}/pubspec.yaml")
    if (!pubspecFile.exists()) {
        throw IllegalArgumentException("pubspec.yaml not found for $packageName")
    }

    val lines = pubspecFile.readLines()
    for (line in lines) {
        if (line.trim().startsWith("$versionIdentifier:")) {
            return getVersionWithoutPrefix(line.split("$versionIdentifier:").last())
        }
    }

    throw IllegalArgumentException("version identifier $versionIdentifier not found in pubspec.yaml for $packageName")
}

fun doesVersionHasIncrementalPrefix(version: String): Boolean {
    return version.trim().startsWith("^")
}

fun getVersionWithoutPrefix(version: String): String {
    return if (version.trim().startsWith("^")) {
        version.split("^").last().trim()
    } else {
        version.trim()
    }
}