// import 'dart:io';
// import 'package:llama_cpp_dart/llama_cpp_dart.dart';

// class AiService {
//   LlamaParent? _llamaParent;
//   bool get isInitialized => _llamaParent != null;

//   /// Loads the GGUF model into memory
//   Future<void> initialize(File modelFile) async {
//     if (_llamaParent != null) return;

//     final loadCommand = LlamaLoad(
//       path: modelFile.path,
//       modelParams: ModelParams(),
//       contextParams: ContextParams(),
//       samplingParams: SamplerParams(),
//     );

//     _llamaParent = LlamaParent(loadCommand);
//     await _llamaParent!.init();
//   }

//   /// Generate a bedtime story stream for a kid
//   Stream<String> generateStoryStream(String topic) async* {
//     if (_llamaParent == null) {
//       throw Exception("Model not loaded");
//     }

//     final prompt =
//         """
// <|system|>
// You are a creative children's storyteller. Write a short, fun, and imaginative story for a 5-year-old child about the user's topic. Use simple words and happy endings.
// </s>
// <|user|>
// Topic: $topic
// </s>
// <|assistant|>
// """;

//     _llamaParent!.sendPrompt(prompt);

//     await for (final response in _llamaParent!.stream) {
//       if (response == '</s>' || response == '<|end|>') {
//         break;
//       }
//       yield response;
//     }
//   }

//   /// Generate creative drawing ideas
//   Stream<String> generateDrawingIdeaStream() async* {
//     if (_llamaParent == null) {
//       throw Exception("Model not loaded");
//     }

//     final prompt = """
// <|system|>
// You are a friendly art teacher for kids. Give exactly ONE fun, simple, and silly drawing idea for a 5-year-old to draw on their canvas right now. For example: "Draw a pink elephant wearing sunglasses!"
// </s>
// <|user|>
// Give me a drawing idea!
// </s>
// <|assistant|>
// """;

//     _llamaParent!.sendPrompt(prompt);

//     await for (final response in _llamaParent!.stream) {
//       if (response == '</s>' || response == '<|end|>') {
//         break;
//       }
//       yield response;
//     }
//   }

//   void dispose() {
//     _llamaParent?.stop();
//   }
// }
