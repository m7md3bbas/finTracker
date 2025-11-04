import 'dart:io';
import 'package:finance_track/core/models/transactions_model.dart';
import 'package:finance_track/core/utils/helper/gemini_service/gemini_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanService {
  final ImagePicker _picker = ImagePicker();

  final SupabaseClient supabaseClient = Supabase.instance.client;
  Future<File?> pickReceiptImage({bool fromGallery = false}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );
      if (image != null) return File(image.path);
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<TransactionModel?> extractReceiptText(File imageFile) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final result = await GeminiService().generateText(recognizedText.text);
      return result;
    } catch (e) {
      throw "Failed to extract text: $e";
    } finally {
      await textRecognizer.close();
    }
  }
}
