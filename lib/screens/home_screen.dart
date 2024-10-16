import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitingcard_scanner/screens/result_screen.dart';

import '../services/image_picker_service.dart';
import '../services/ocr_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visiting Card Scanner',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF033254),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Capture or Select a Card',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:Color(0xFF033254),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF033254), // Custom color for button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _processImage(context, ImageSource.camera),
                child: const Text(
                  'Capture Image',
                  style: TextStyle(fontSize: 18,color:Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF033254), // Custom color for button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _processImage(context, ImageSource.gallery),
                child: const Text(
                  'Select Image',
                  style: TextStyle(fontSize: 18,color:Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _processImage(BuildContext context, ImageSource source) async {
    final imagePicker = ImagePickerService();
    final ocrService = OCRService();

    try {
      final image = await imagePicker.pickImage(source);
      if (image != null) {
        final scannedText = await ocrService.performOCR(image);
        if (scannedText.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(scannedText: scannedText),
            ),
          );
        } else {
          _showErrorDialog(context, 'No text found in the image.');
        }
      }
    } catch (e) {
      _showErrorDialog(context, 'Error processing image: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
