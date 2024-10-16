import 'package:flutter/material.dart';
import 'package:visitingcard_scanner/services/storage_service.dart';
import 'package:visitingcard_scanner/models/visiting_card.dart';

import '../widgets/card_details_widget.dart';

class ResultScreen extends StatelessWidget {
  final String scannedText;

  const ResultScreen({Key? key, required this.scannedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visitingCard = VisitingCard.fromScannedText(scannedText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Result',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF033254), // Custom color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CardDetailsWidget(visitingCard: visitingCard),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF033254), // Custom color for button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _saveCard(context, visitingCard),
                child: const Text(
                  'Save Card',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _buildSavedCardsSection(),

            const SizedBox(height: 20),
            // Additional UI elements can be added here

          ],
        ),
      ),
    );
  }

  Future<void> _saveCard(BuildContext context, VisitingCard card) async {
    final storageService = StorageService();
    try {
      await storageService.saveCard(card);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving card: $e')),
      );
    }
  }

  FutureBuilder<List<VisitingCard>> _buildSavedCardsSection() {
    return FutureBuilder<List<VisitingCard>>(
      future: StorageService().getSavedCards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No saved cards.');
        }

        final savedCards = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Previously Saved Cards:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF033254)),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
              itemCount: savedCards.length,
              itemBuilder: (context, index) {
                return CardDetailsWidget(visitingCard: savedCards[index]);
              },
            ),
          ],
        );
      },
    );
  }

}
