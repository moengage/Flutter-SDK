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
    val publishExitCode = executeCommandOnShell("melos publish --no-dry-run --git-tag-version --yes --no-published")

    // Tag/release before checking the exit code, so an earlier success isn't dropped if a later package fails.
    tagAndReleasePublishedPackages(releaseNotes)

    if (publishExitCode != 0) {
        println("::error::melos publish failed (exit code $publishExitCode). Re-run this workflow to resume with the remaining packages.")
        exitProcess(publishExitCode)
    }

    println("Published plugins successfully")
}

private fun getTagsPointingAtHead(): Set<String> {
    return executeShellCommandWithStringOutput("git tag --points-at HEAD").trim()
        .let { if (it.isBlank()) emptySet() else it.split("\n").toSet() }
}

private fun getLocalTags(): Set<String> {
    return executeShellCommandWithStringOutput("git tag --list").trim()
        .let { if (it.isBlank()) emptySet() else it.split("\n").toSet() }
}

private fun getRemoteTags(): Set<String> {
    return executeShellCommandWithStringOutput("git ls-remote --tags origin").trim()
        .let { if (it.isBlank()) emptyList() else it.split("\n") }
        .mapNotNull { it.substringAfter("refs/tags/", "").removeSuffix("^{}").ifBlank { null } }
        .toSet()
}

// Idempotent regardless of where an earlier attempt stopped: candidates are tags not yet
// pushed to origin (this run's new tags) plus tags still at HEAD (in case a previous
// attempt pushed the tag but crashed before creating its release). Each candidate only
// gets a release if it doesn't already have one.
private fun tagAndReleasePublishedPackages(releaseNotes: String) {
    val unpushedTags = getLocalTags() - getRemoteTags()
    val candidateTags = unpushedTags + getTagsPointingAtHead()
    println("Candidate tags: $candidateTags")
    if (candidateTags.isEmpty()) return

    pushLocalTags()

    val releaseTagPackages = packageParentFolder.values.toSet()
    candidateTags.forEach { tag ->
        if (releaseTagPackages.contains(tag.split("-").first()) && !releaseExistsForTag(tag)) {
            println("Creating release for tag: $tag")
            createGitRelease(tag, releaseNotes)
        }
    }
}

private fun releaseExistsForTag(tag: String): Boolean {
    return executeCommandOnShell("gh release view $tag") == 0
}
