# moengage_recommendations_platform_interface

A common platform interface for the [`moengage_recommendations`][1] plugin.

This interface allows platform-specific implementations of the `moengage_recommendations` plugin,
as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `moengage_recommendations`, extend
`MoEngageRecommendationsPlatform` with an implementation that performs the platform-specific
behaviour, and when you register your plugin, set the default `MoEngageRecommendationsPlatform`
by calling `MoEngageRecommendationsPlatform.instance = MyPlatformRecommendations()`.

[1]: ../moengage_recommendations
