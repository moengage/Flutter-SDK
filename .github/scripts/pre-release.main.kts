#!/usr/bin/env kotlin

@file:Import("../../../sdk-automation-scripts/scripts/common/utils.main.kts")
@file:Import("./flutter-utils.main.kts")
@file:DependsOn("org.json:json:20240303")

import java.io.File
import org.json.JSONObject
import kotlin.system.exitProcess

val releaseBranch = "master"

preRelease(args[0])

fun preRelease(releaseTicket: String) {
    executeCommandOrExitOnFailure("git checkout $releaseBranch")
    
    // Find package to be release
    val changedFiles = getChangedFilesAfterLastRelease(releaseBranch)
    val packagesToBeRelease = mutableSetOf<String>()
    changedFiles.forEach { filePath ->
        if (isPackageFile(filePath)) {
            getPackageName(filePath)?.let { packagesToBeRelease.add(it) }
        }
    }
    println("Packages to be release: $packagesToBeRelease")

    // Validate changelog
    packagesToBeRelease.forEach { packageName ->
        if (!changedFiles.contains("${getPackageFullPath(packageName)}/CHANGELOG.md")) {
            println("Changelog is not updated for $packageName")
            exitProcess(1)
        }
    }
    
    val filteredReleasingPackage = packagesToBeRelease.filter {
        val changelogPath = "${getPackageFullPath(it)}/CHANGELOG.md"
        val releaseType = getReleaseTypeForModule(changelogPath)
        releaseType != "NA"
    }
    println("Filtered packages to be release: $filteredReleasingPackage")

    // Get the package after updating the version if needed
    val packageVersion = mutableMapOf<String, String>()
    dependencyMapping.forEach { (packageName, _) ->
        if (filteredReleasingPackage.contains(packageName)) {
            updateVersionForPackage(packageName)
        }

        packageVersion[packageName] = getVersionForPackage(packageName, "version")
    }

    // Update dependency version
    filteredReleasingPackage.forEach { packageName ->
        dependencyMapping[packageName]?.forEach { dependency, updateType ->
            val currentDependencyVersion = getVersionForPackage(packageName, "$dependency")
            val updatedDependencyVersion = packageVersion[dependency] ?: run {
                println("No version found for dependency $dependency")
                exitProcess(1)
            }
            if (updateType == "incremental" && getReleaseTypeForVersion(
                    currentDependencyVersion,
                    updatedDependencyVersion
                ) != releaseTypeMajor
            ) {
                println("Skipping $dependency update for $packageName as the update is not major")
            } else {
                updatePackageDependencyVersion(packageName, dependency, updatedDependencyVersion)
            }
        }
    }

    if (filteredReleasingPackage.isEmpty()) {
        println("No package to be release, exiting...")
        exitProcess(0)
    }

    // Commit and push changes
    commitAndPush(getReleaseCommitMessage(filteredReleasingPackage, packageVersion, releaseTicket))
}

private fun updateVersionForPackage(packageName: String) {
    val changelogPath = "${getPackageFullPath(packageName)}/CHANGELOG.md"

    val releaseType = getReleaseTypeForModule(changelogPath)
    println("Release type for $packageName is $releaseType")

    if (!isValidReleaseType(releaseType)) {
        println("Exiting workflow, due to incorrect release type of $packageName as $releaseType")
        exitProcess(1)
    }

    if (releaseType == releaseTypeNA) {
        println("Skipping $packageName release as the release not required")
        return
    }

    val currentVersion = getVersionForPackage(packageName, "version")
    val releaseVersion = getIncremenetedVersion(releaseType, currentVersion)

    println("Current version for $packageName is $currentVersion, new version is $releaseVersion")
    updatePackageVersion(packageName, releaseVersion)
    updateChangelogFile(changelogPath, releaseVersion)
    updateConfigJsonVersion(packageName, releaseVersion)
}

private fun updateConfigJsonVersion(packageName: String, version: String) {
    val file = File("${getPackageFullPath(packageName)}/config.json")
    if (!file.exists()) {
        println("No config.json found for $packageName, skipping...")
        return
    }

    val configContent = JSONObject(file.readText())
    configContent.put("version", version)
    file.writeText(configContent.toString(2))
}

private fun getReleaseCommitMessage(
    packageNames: List<String>,
    packageVersion: Map<String, String>,
    releaseTicket: String
): String {
    var changelogMessage = ""
    packageNames.forEach {
        changelogMessage += "$it: ${packageVersion[it]}, "
    }
    return "$releaseTicket: Updating packages: ${changelogMessage.trim().dropLast(1)}"
}