import 'dart:math';

String formatFileSize(int bytes, [int decimals = 1]) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB"];

  // Calculate index in suffixes array based on log base 1024
  final i = (log(bytes) / log(1024)).floor();

  // Scale down the bytes and format to the desired decimal places
  final size = bytes / pow(1024, i);
  return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
}
