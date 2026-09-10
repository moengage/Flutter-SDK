#!/usr/bin/env kotlin

@file:Import("../../../sdk-automation-scripts/scripts/common/utils.main.kts")
@file:Import("./flutter-utils.main.kts")

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
    executeCommandOrExitOnFailure("melos publish --no-dry-run --git-tag-version --yes$ignoreOption")
    println("Merge master branch to development")

    val newTags = executeShellCommandWithStringOutput("git tag --points-at HEAD").trim().split("\n")
    println("New tags: $newTags")
    // Post Release
    mergeMasterToDevBranch()
    pushLocalTags()
    val releaseTagPackages = packageParentFolder.values.toSet()
    newTags.forEach { tag ->
        if (releaseTagPackages.contains(tag.split("-").first())) {
            println("Creating release for tag: $tag")
            createGitRelease(tag, releaseNotes)
        }
    }
    println("Published plugins successfully")
}