import 'package:flutter/material.dart';

class RatingStarsWidget extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;

  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.size = 18,
    this.color = Colors.amber,
    this.isInteractive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        if (isInteractive) {
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (onRatingChanged != null) {
                onRatingChanged!(starValue);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(icon, size: size, color: color),
            ),
          );
        }

        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
