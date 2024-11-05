/// Possible media types for [InboxMessage]
enum MediaType {
  /// Image Type
  image,

  /// Audio Type
  audio,

  /// Video Type
  video
}

/// Extension Util For [MediaType]
extension MediaTypeExt on MediaType {
  /// Convert [MediaType] to [String]
  String get asString {
    switch (this) {
      case MediaType.image:
        return _valueImage;
      case MediaType.audio:
        return _valueAudio;
      case MediaType.video:
        return _valueVideo;
    }
  }

  /// Get [MediaType] Instance from [String]
  static MediaType fromString(String string) {
    switch (string) {
      case _valueImage:
        return MediaType.image;
      case _valueAudio:
        return MediaType.audio;
      case _valueVideo:
        return MediaType.video;
    }
    throw Exception('unsupported type');
  }
}

const String _valueAudio = 'audio';
const String _valueImage = 'image';
const String _valueVideo = 'video';
