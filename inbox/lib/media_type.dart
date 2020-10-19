enum MediaType { image, audio, video }

extension MediaTypeExt on MediaType {
  String get asString {
    switch (this) {
      case MediaType.image:
        return _valueImage;
      case MediaType.audio:
        return _valueAudio;
      case MediaType.video:
        return _valueVideo;
    }
    throw Exception("unsupported type");
  }

  static MediaType fromString(String string) {
    switch (string) {
      case _valueImage:
        return MediaType.image;
      case _valueAudio:
        return MediaType.audio;
      case _valueVideo:
        return MediaType.video;
    }
    throw Exception("unsupported type");
  }
}

const String _valueAudio = "audio";
const String _valueImage = "image";
const String _valueVideo = "video";
