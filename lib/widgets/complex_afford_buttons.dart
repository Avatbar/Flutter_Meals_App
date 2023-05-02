import 'package:flutter/material.dart';

class ComplexAffordButtons extends StatefulWidget {
  const ComplexAffordButtons({super.key});

  @override
  State<ComplexAffordButtons> createState() => _ComplexAffordButtonsState();
}

class _ComplexAffordButtonsState extends State<ComplexAffordButtons> {
  final List<bool> _selectedComplexity = <bool>[true, false, false];
  final List<bool> _selectedAffordability = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedComplexity.length; i++) {
                  _selectedComplexity[i] = i == index;
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.blue[700],
            selectedColor: Colors.black,
            fillColor: Colors.blue[200],
            color: Colors.blue[400],
            isSelected: _selectedComplexity,
            children: const <Widget>[
              Text("Easy"),
              Text("Medium"),
              Text("Hard"),
            ]),
        const SizedBox(width: 20),
        ToggleButtons(
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedAffordability.length; i++) {
                  _selectedAffordability[i] = i == index;
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.blue[700],
            selectedColor: Colors.black,
            fillColor: Colors.blue[200],
            color: Colors.blue[400],
            isSelected: _selectedAffordability,
            children: const <Widget>[
              Text("€"),
              Text("€€"),
              Text("€€€"),
            ]),
      ],
    );
  }
}
