class AppUrls {
  static String getImageUrl(String artist, String title) {
    // Normalize the filename (remove extra spaces, special characters)
    final filename = _normalizeFilename('$artist - $title');

    // Try common image extensions in order of preference
    final extensions = ['png', 'jpg', 'jpeg', 'webp'];

    // Return URL with the first found extension
    for (final ext in extensions) {
      final encodedPath = Uri.encodeComponent('covers/$filename.$ext');
      return 'https://firebasestorage.googleapis.com/v0/b/spotify-clone-d53ef.appspot.com/o/$encodedPath?alt=media';
    }

    // Fallback to PNG if no extension is specified
    final encodedPath = Uri.encodeComponent('covers/$filename.png');
    return 'https://firebasestorage.googleapis.com/v0/b/spotify-clone-d53ef.appspot.com/o/$encodedPath?alt=media';
  }

  static String _normalizeFilename(String name) {
    return name
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'[^\w\s-]'), ''); // Remove special characters
  }
}