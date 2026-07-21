enum AssetType { image, audio, video, pdf, document, archive, unknown }

class AssetTypeIdentifier {
  // Mapping by exact file extensions (lowercase)
  static final Map<String, AssetType> _extensionMap = {
    // Images
    'jpg': AssetType.image,
    'jpeg': AssetType.image,
    'png': AssetType.image,
    'gif': AssetType.image,
    'webp': AssetType.image,
    'bmp': AssetType.image,
    'heic': AssetType.image,

    // Audio
    'mp3': AssetType.audio,
    'm4a': AssetType.audio,
    'wav': AssetType.audio,
    'ogg': AssetType.audio,
    'aac': AssetType.audio,
    'flac': AssetType.audio,

    // Video
    'mp4': AssetType.video,
    'mov': AssetType.video,
    'avi': AssetType.video,
    'mkv': AssetType.video,
    'webm': AssetType.video,

    // PDFs
    'pdf': AssetType.pdf,

    // Documents
    'doc': AssetType.document,
    'docx': AssetType.document,
    'xls': AssetType.document,
    'xlsx': AssetType.document,
    'ppt': AssetType.document,
    'pptx': AssetType.document,
    'txt': AssetType.document,
    'rtf': AssetType.document,

    // Archives
    'zip': AssetType.archive,
    'rar': AssetType.archive,
    '7z': AssetType.archive,
    'tar': AssetType.archive,
    'gz': AssetType.archive,
  };

  /// Identifies the asset type using file extension or full MIME type
  static AssetType fromFile({String? extension, String? mimeType}) {
    // 1. Try matching with extension first (most reliable on file_picker)
    if (extension != null && extension.isNotEmpty) {
      final cleanExt = extension.toLowerCase().replaceAll('.', '').trim();
      if (_extensionMap.containsKey(cleanExt)) {
        return _extensionMap[cleanExt]!;
      }
    }

    // 2. Fallback to MIME type prefix if extension doesn't match or is missing
    if (mimeType != null && mimeType.isNotEmpty) {
      final cleanMime = mimeType.toLowerCase();
      if (cleanMime.startsWith('image/')) return AssetType.image;
      if (cleanMime.startsWith('audio/')) return AssetType.audio;
      if (cleanMime.startsWith('video/')) return AssetType.video;
      if (cleanMime == 'application/pdf') return AssetType.pdf;
    }

    return AssetType.unknown;
  }
}
