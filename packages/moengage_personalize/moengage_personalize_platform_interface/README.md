# moengage_personalize_platform_interface

A common platform interface for the [`moengage_personalize`][1] plugin.

This interface allows platform-specific implementations of the `moengage_personalize`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `moengage_personalize`, extend
[`MoEngagePersonalizePlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`MoEngagePersonalizePlatform` by calling
`MoEngagePersonalizePlatform.instance = MyPlatformMoEngagePersonalize()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: ../moengage_personalize
[2]: lib/moengage_personalize_platform_interface.dart
