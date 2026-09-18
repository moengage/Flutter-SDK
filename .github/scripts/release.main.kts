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

    // pub.dev only allows the FIRST version of a brand-new package to be published manually via
    // `dart pub login` + `dart pub publish` - it cannot be automated via service-account/OIDC
    // tokens (see isPublishedOnPubDev doc comment). Skip such packages here instead of letting
    // them fail the whole release batch; publish them once via scripts/publish-new-package.sh,
    // then they're picked up automatically on every subsequent release.
    val neverPublishedPackages = packageParentFolder.keys.filter { !isPublishedOnPubDev(it) }
    if (neverPublishedPackages.isNotEmpty()) {
        println(
            "⚠️  Skipping never-published package(s) from the automated release: $neverPublishedPackages. " +
                "pub.dev requires their first version to be published manually - run " +
                "'scripts/publish-new-package.sh <package-path>' locally (after 'dart pub login') for each, " +
                "then they will be included automatically in future releases."
        )
    }
    val ignoreOption = if (neverPublishedPackages.isNotEmpty()) {
        " --ignore=${neverPublishedPackages.joinToString(",")}"
    } else {
        ""
    }

    println("Publish plugins")
    // --no-published skips packages already live on pub.dev, so retries resume from where they left off.
    val publishExitCode = executeCommandOnShell("melos publish --no-dry-run --yes --no-published$ignoreOption")

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

private fun releaseExistsForTag(tag: String): Boolean {
    return executeCommandOnShell("gh release view $tag") == 0
}
