#!/usr/bin/env kotlin

// ── Semver Diff ──────────────────────────────────────────────────────────────
//
// Only the major/minor segments are compared; the patch segment (and any
// suffix, e.g. "-SNAPSHOT") never affects the result and defaults to "patch".
// This is intentional — pre-release suffixes are not classified specially
// when bumping versions.

fun determineReleaseType(oldVersion: String, newVersion: String): String {
    val oldParts = oldVersion.split(".").map { it.toIntOrNull() ?: 0 }
    val newParts = newVersion.split(".").map { it.toIntOrNull() ?: 0 }
    return when {
        newParts.getOrElse(0) { 0 } != oldParts.getOrElse(0) { 0 } -> "major"
        newParts.getOrElse(1) { 0 } != oldParts.getOrElse(1) { 0 } -> "minor"
        else -> "patch"
    }
}
