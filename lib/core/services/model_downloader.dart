import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ModelDownloader {
  static const String _modelUrl =
      'https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf';
  static const String _modelFilename = 'tinyllama-q4.gguf';

  final Dio _dio = Dio();

  Future<File?> getLocalModelFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_modelFilename');
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<File> downloadModel(void Function(double progress) onProgress) async {
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/$_modelFilename';

    final file = File(savePath);
    if (await file.exists()) {
      return file;
    }

    try {
      await _dio.download(
        _modelUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );
      return File(savePath);
    } catch (e) {
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    }
  }
}
