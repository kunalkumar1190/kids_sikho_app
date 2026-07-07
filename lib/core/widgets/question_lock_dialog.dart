import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

Future<bool> showParentLockDialog(BuildContext context) async {
  final num1 = 3 + Random().nextInt(7); // 3 to 9
  final num2 = 2 + Random().nextInt(8); // 2 to 9
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
              children: const [
                Icon(Icons.lock, color: Colors.red),
                SizedBox(width: 10),
                Text("Parent Lock"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To unlock, please solve:",
                  style: GoogleFonts.nunito(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "$num1 + $num2 = ?",
                  style: GoogleFonts.nunito(
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
