// lib/presentation/widgets/smart_image_loader.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class SmartImageLoader extends StatefulWidget {
  final String artist;
  final String title;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SmartImageLoader({
    super.key,
    required this.artist,
    required this.title,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<SmartImageLoader> createState() => _SmartImageLoaderState();
}

class _SmartImageLoaderState extends State<SmartImageLoader> {
  late Future<String> _imageUrlFuture;
  final _storage = FirebaseStorage.instance;
  final _extensions = ['png', 'jpg', 'jpeg', 'webp'];

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = _getImageUrlWithFallback();
  }

  Future<String> _getImageUrlWithFallback() async {
    try {
      final filename = _normalizeFilename('${widget.artist} - ${widget.title}');

      // Try direct URL first if you know the exact format
      final directUrl = _getDirectUrl(filename);
      if (await _testUrl(directUrl)) return directUrl;

      // Fallback to checking extensions
      for (final ext in _extensions) {
        try {
          final ref = _storage.ref('covers/$filename.$ext');
          final url = await ref.getDownloadURL();
          if (await _testUrl(url)) return url;
        } catch (e) {
          continue;
        }
      }

      // If all else fails, try the direct URL anyway
      return directUrl;
    } catch (e) {
      debugPrint('Error getting image URL: $e');
      return '';
    }
  }

  Future<bool> _testUrl(String url) async {
    try {
      final response = await CachedNetworkImage.evictFromCache(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _getDirectUrl(String filename) {
    final encodedPath = Uri.encodeComponent('covers/$filename.png');
    return 'https://firebasestorage.googleapis.com/v0/b/spotify-clone-d53ef.appspot.com/o/$encodedPath?alt=media';
  }

  String _normalizeFilename(String name) {
    return name
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s-]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildColoredPlaceholder(true);
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildColoredPlaceholder(false);
        }

        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 200),
          placeholder: (context, url) => _buildColoredPlaceholder(true),
          errorWidget: (context, url, error) {
            debugPrint('Image load failed: $error\nURL: $url');
            return _buildColoredPlaceholder(false);
          },
          cacheKey: snapshot.data!, // Important for proper caching
        );
      },
    );
  }

  Widget _buildColoredPlaceholder(bool isLoading) {
    final random = Random((widget.title + widget.artist).codeUnits.fold(0, (a, b) => a! + b));
    final baseHue = random.nextInt(360);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromAHSL(1.0, baseHue.toDouble(), 0.6, 0.6).toColor(),
            HSLColor.fromAHSL(1.0, (baseHue + 40) % 360.0, 0.7, 0.4).toColor(),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white70)
                : Icon(
              Icons.album,
              size: 60,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          if (!isLoading)
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                widget.title.isNotEmpty ? widget.title[0].toUpperCase() : "♪",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          if (!isLoading)
            Positioned(
              top: 8,
              left: 8,
              child: Text(
                widget.artist.isNotEmpty ? widget.artist[0].toUpperCase() : "A",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}