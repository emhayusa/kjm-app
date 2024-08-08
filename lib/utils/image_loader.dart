import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildImageFromUrl(String imageUrl, double size) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(size - 30),
    child: CachedNetworkImage(
      width: 2.5 * size,
      height: 2 * size,
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          const CircularProgressIndicator(), // Menampilkan loading saat gambar sedang dimuat
      errorWidget: (context, url, error) => const Icon(
          Icons.error), // Menampilkan ikon error jika gagal memuat gambar
      fit: BoxFit.cover,
    ),
  );
}

Widget buildImageFromUrlTop(String imageUrl, double size) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      width: 2.5 * size,
      height: 2 * size,
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          const CircularProgressIndicator(), // Menampilkan loading saat gambar sedang dimuat
      errorWidget: (context, url, error) => const Icon(
          Icons.error), // Menampilkan ikon error jika gagal memuat gambar
      fit: BoxFit.cover,
    ),
  );
}
