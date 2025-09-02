#!/usr/bin/env kotlin

@file:Import("../../../sdk-automation-scripts/scripts/common/utils.main.kts")

val releasebranch = "master"
releasePlugins(args[0])

fun releasePlugins(releaseNotes: String) {
    executeCommandOrExitOnFailure("git checkout $releasebranch")

    println("Running Melos BootStrap")
    executeCommandOrExitOnFailure("melos bootstrap")
    println("Running Melos get")
    executeCommandOrExitOnFailure("melos get")
    println("Publish plugins")
    executeCommandOrExitOnFailure("melos publish --no-dry-run --git-tag-version --yes")
    println("Merge master branch to development")

    val newTags = executeShellCommandWithStringOutput("git tag --points-at HEAD").trim().split("\n")
    println("New tags: $newTags")

    val releaseTagPackages = packageParentFolder.values.toSet()
    newTags.forEach { tag ->
        if (releaseTagPackages.contains(tag.split("-").first())) {
            println("Creating release for tag: $tag")
            createGitRelease(tag, releaseNotes)
        }
    }

    // Post Release
    mergeMasterToDevBranch()
    pushLocalTags()
    println("Published plugins successfully")
}