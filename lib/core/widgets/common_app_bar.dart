import 'package:flutter/material.dart';
import 'package:anganwadikids/core/theme/app_text_style.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final bool? isBottomSpace;

  const CommonAppBar(
      {super.key,
      required this.title,
      this.actions,
      this.onBackPressed,
      this.backgroundColor,
      this.isBottomSpace = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isBottomSpace!
          ? const EdgeInsets.only(bottom: 20.0)
          : EdgeInsets.zero, // Added bottom margin
      child: AppBar(
        toolbarHeight: 80, // Added spacing for top and bottom

        title: Text(
          title,
          style: AppTextStyle.fredoka(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
            shadows: [
              const Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor ?? Colors.lightBlue,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 12.0,
              top: 16.0,
              bottom: 16.0), // Adjusted padding to fit taller app bar
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
                color: Colors.orangeAccent,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(80 + 20); // Match toolbarHeight + bottom margin
}
