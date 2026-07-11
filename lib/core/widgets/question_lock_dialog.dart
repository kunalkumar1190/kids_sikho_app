import 'package:flutter/material.dart';
import 'package:seekho_basic/core/theme/app_text_style.dart';
import 'dart:math';

enum LockMode { parent, child }

Future<bool> showParentLockDialog(BuildContext context,
    {LockMode mode = LockMode.parent}) async {
  final int num1;
  final int num2;

  final random = Random();

  if (mode == LockMode.parent) {
    // Parent mode: generate numbers from 1 to 4
    num1 = random.nextInt(4) + 1; // Range: 1–4
    num2 = random.nextInt(4) + 1; // Range: 1–4
  } else {
    // Child mode: generate easy numbers from 1 to 4
    num1 = random.nextInt(2) + 1; // Range: 1–2
    num2 = random.nextInt(4) + 1; // Range: 1–4
  }

  final correctAnswer = num1 + num2;

  final controller = TextEditingController();
  bool isError = false;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(mode == LockMode.parent ? Icons.lock : Icons.extension,
                    color:
                        mode == LockMode.parent ? Colors.red : Colors.orange),
                const SizedBox(width: 10),
                Text(mode == LockMode.parent ? "Parent Lock" : "Quick Check"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To unlock, please solve:",
                  style: AppTextStyle.nunito(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "$num1 + $num2 = ?",
                  style: AppTextStyle.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Answer",
                    errorText: isError ? "Incorrect, try again!" : null,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  if (controller.text.trim() == correctAnswer.toString()) {
                    Navigator.pop(context, true);
                  } else {
                    setState(() {
                      isError = true;
                    });
                    controller.clear();
                  }
                },
                child:
                    const Text("Unlock", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );

  return result == true;
}
