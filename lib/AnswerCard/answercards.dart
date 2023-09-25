import 'package:flutter/material.dart';

class AnswerCard extends StatefulWidget {
  final String answerText;
  final Function(String) onAnswerSelected;
  final bool isSelected; // Add a isSelected property

  AnswerCard(this.answerText, this.isSelected, this.onAnswerSelected);

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: widget.isSelected ? Colors.blueAccent : Colors.white,
      child: ListTile(
        title: Text(widget.answerText),
        onTap: () {
          widget.onAnswerSelected(widget.answerText);
        },
      ),
    );
  }
}
