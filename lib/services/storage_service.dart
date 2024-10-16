import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:visitingcard_scanner/models/visiting_card.dart';

class StorageService {
  static const String _cardsKey = 'saved_cards';

  Future<void> saveCard(VisitingCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCards = prefs.getStringList(_cardsKey) ?? [];
    savedCards.add(jsonEncode(card.toJson()));
    await prefs.setStringList(_cardsKey, savedCards);
  }

  Future<List<VisitingCard>> getSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCards = prefs.getStringList(_cardsKey) ?? [];
    return savedCards
        .map((cardJson) => VisitingCard.fromJson(jsonDecode(cardJson)))
        .toList();
  }
}