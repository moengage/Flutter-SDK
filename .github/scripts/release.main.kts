#!/usr/bin/env kotlin

@file:Import("../../../sdk-automation-scripts/scripts/common/utils.main.kts")
@file:Import("./flutter-utils.main.kts")

import kotlin.system.exitProcess

val releasebranch = "master"
releasePlugins(args[0])

fun releasePlugins(releaseNotes: String) {
    executeCommandOrExitOnFailure("git checkout $releasebranch")

    println("Running Melos BootStrap")
    executeCommandOrExitOnFailure("melos bootstrap")
    println("Running Melos get")
    executeCommandOrExitOnFailure("melos get")

    println("Publish plugins")
    // --no-published skips packages already live on pub.dev, so retries resume from where they left off.
    val publishExitCode = executeCommandOnShell("melos publish --no-dry-run --yes --no-published")

    // Tag/release whatever is actually live on pub.dev, before checking the exit code, so
    // an earlier success isn't dropped if a later package fails.
    tagAndReleasePublishedPackages(releaseNotes)

    if (publishExitCode != 0) {
        println("::error::melos publish failed (exit code $publishExitCode). Re-run this workflow to resume with the remaining packages.")
        exitProcess(publishExitCode)
    }

    println("Published plugins successfully")
}

// Ground truth is pub.dev, not melos's own tag/exit-code bookkeeping: for each
// release-tracked package whose current version is actually published, tag it and
// release it if that hasn't happened yet. Independent of HEAD, of what melos tagged
// locally, and of where an earlier attempt stopped.
private fun tagAndReleasePublishedPackages(releaseNotes: String) {
    val releasedVersions = packageParentFolder.values.toSet()
        .map { it to getVersionForPackage(it, "version") }
        .filter { (packageName, version) -> isPublishedOnPubDev(packageName, version) }

    println("Published on pub.dev: $releasedVersions")
    if (releasedVersions.isEmpty()) return

    releasedVersions.forEach { (packageName, version) ->
        if (!isTagExistForVersion(version, packageName)) {
            executeCommandOrExitOnFailure("git tag -a $packageName-v$version -m \"Publish $packageName-v$version\"")
        }
    }
    pushLocalTags()

    releasedVersions.forEach { (packageName, version) ->
        val tag = "$packageName-v$version"
        if (!releaseExistsForTag(tag)) {
            println("Creating release for tag: $tag")
            createGitRelease(tag, releaseNotes)
        }
    }
}

private fun isPublishedOnPubDev(packageName: String, version: String): Boolean {
    val statusCode = executeShellCommandWithStringOutput(
        "curl --write-out %{http_code} --silent --output /dev/null https://pub.dev/api/packages/$packageName/versions/$version"
    )
    return statusCode == "200"
}

private fun releaseExistsForTag(tag: String): Boolean {
    return executeCommandOnShell("gh release view $tag") == 0
}
