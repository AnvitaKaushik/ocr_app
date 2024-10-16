import 'package:flutter/material.dart';
import 'package:visitingcard_scanner/models/visiting_card.dart';


class CardDetailsWidget extends StatelessWidget {
  final VisitingCard visitingCard;

  const CardDetailsWidget({Key? key, required this.visitingCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${visitingCard.name}', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text('Phone: ${visitingCard.phoneNumber}'),
            const SizedBox(height: 8),
            Text('Email: ${visitingCard.email}'),
            const SizedBox(height: 8),
            Text('Company: ${visitingCard.company}'),
          ],
        ),
      ),
    );
  }
}