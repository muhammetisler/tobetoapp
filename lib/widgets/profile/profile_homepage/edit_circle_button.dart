import 'package:flutter/material.dart';
import 'package:tobetoappv1/widgets/profile/profile_edit/edit_screen.dart';

class EditCircleButton extends StatelessWidget {
  const EditCircleButton({
    Key? key,
    required this.size,
    required this.percent,
  }) : super(key: key);

  final Size size;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: size.height * 0.10,
      right: 10,
      child: percent < 0.2
          ? TweenAnimationBuilder<double>(
          tween: percent < 0.17
              ? Tween(begin: 1, end: 0)
              : Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, widget) {
            return Transform.scale(
              scale: 1.0 - value,
              child: CircleAvatar(
                minRadius: 20,
                backgroundColor: Colors.purple,
                child: GestureDetector(
                  child: const Icon(
                    Icons.note_alt_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const EditScreen()));
                  },
                ),
              ),
            );
          })
          : const SizedBox(),
    );
  }
}