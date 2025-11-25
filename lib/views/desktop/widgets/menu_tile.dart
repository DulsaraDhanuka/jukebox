import 'package:flutter/material.dart';

class MenuTile extends StatefulWidget {
  const MenuTile({
    super.key,
    required this.title,
    required this.iconFilled,
    required this.iconOutlined,
    required this.selected,
    this.onTap,
  });

  final String title;
  final IconData iconFilled;
  final IconData iconOutlined;
  final bool selected;
  final VoidCallback? onTap; 

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
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
            color: widget.selected ? const Color(0xFF111111) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.selected ? widget.iconFilled : widget.iconOutlined,
                  size: 25.0,
                  color: widget.selected || hovered
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF898989),
                ),
                SizedBox(width: 10.0),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.selected || hovered
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
      ),
    );
  }
}
