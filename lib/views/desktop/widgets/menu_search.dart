import 'package:flutter/material.dart';

class MenuSearch extends StatefulWidget {
  const MenuSearch({super.key});

  @override
  State<MenuSearch> createState() => _MenuSearchState();
}

class _MenuSearchState extends State<MenuSearch> {
  bool hovered = false;
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: Container(
        height: 54,
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: selected ? const Color(0xFF111111) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                size: 25.0,
                color: hovered || selected
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF898989),
              ),
              SizedBox(width: 10.0),
              Text(
                "Search",
                style: TextStyle(
                  color: hovered || selected
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF898989),
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
