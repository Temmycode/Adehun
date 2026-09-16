import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_text_styles.dart';
import 'custom_network_image.dart';

/// Circular avatar. Shows the photo when there is one, otherwise initials on
/// a warm tint chosen deterministically from the name so the same person
/// always gets the same colour.
class AvatarInitials extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double size;
  final bool showBorder;

  const AvatarInitials({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 40,
    this.showBorder = false,
  });

  static const _lightPairs = <(Color, Color)>[
    (Color(0xFFE6F3EE), Color(0xFF0B6E4F)),
    (Color(0xFFFBE3DC), Color(0xFFC24E33)),
    (Color(0xFFFBF0DC), Color(0xFF9A6410)),
    (Color(0xFFE5EFFA), Color(0xFF2F5FA8)),
    (Color(0xFFF0E6F5), Color(0xFF6E3F8F)),
    (Color(0xFFF2E7DF), Color(0xFF8A5A3C)),
  ];

  static const _darkPairs = <(Color, Color)>[
    (Color(0xFF14372B), Color(0xFF8FD3B8)),
    (Color(0xFF3D2620), Color(0xFFF3A48F)),
    (Color(0xFF3A2C14), Color(0xFFF0C878)),
    (Color(0xFF1A2A3D), Color(0xFF9DBCE8)),
    (Color(0xFF2E2238), Color(0xFFCDA8E3)),
    (Color(0xFF2E241E), Color(0xFFD9B79F)),
  ];

  static String initialsFor(String? name) {
    final trimmed = (name ?? '').trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  static (Color, Color) paletteFor(String? name, {required bool dark}) {
    final pairs = dark ? _darkPairs : _lightPairs;
    final key = (name ?? '').trim().toLowerCase();
    var hash = 0;
    for (final unit in key.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return pairs[hash % pairs.length];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (bg, fg) = paletteFor(name, dark: context.isDarkMode);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: colors.surface, width: 2) : null,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: hasImage
          ? CustomNetworkImage(image: imageUrl, width: size, height: size)
          : Text(
              initialsFor(name),
              style: AppTextStyles.labelLarge.copyWith(
                color: fg,
                fontSize: size * 0.38,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
    );
  }
}
