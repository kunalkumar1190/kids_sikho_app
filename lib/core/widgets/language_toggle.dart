import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seekho_basic/core/theme/app_text_style.dart';
import '../settings/settings_cubit.dart';

class LanguageToggleWidget extends StatelessWidget {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, bool>(
      builder: (context, isHindi) {
        return GestureDetector(
          onTap: () {
            context.read<SettingsCubit>().setLanguage(!isHindi);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 85,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isHindi
                    ? [
                        const Color(0xFFFF9933),
                        const Color(0xFF138808)
                      ] // India Flag vibes
                    : [
                        const Color(0xFF448AFF),
                        const Color(0xFF1976D2)
                      ], // English Blue vibes
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isHindi ? Colors.orange : Colors.blue).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  top: 4,
                  bottom: 4,
                  left: isHindi ? 49 : 4,
                  right: isHindi ? 4 : 49,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        isHindi ? "अ" : "A",
                        style: AppTextStyle.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isHindi
                              ? const Color(0xFFFF9933)
                              : const Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: isHindi
                            ? const Text("EN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: !isHindi
                            ? const Text("HI",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
