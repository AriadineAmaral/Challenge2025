import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String titulo;
  final Color backgroundColor;
  final Color textColor;
  final IconData backIcon;
  final Widget? destinoAoVoltar;
  final double height; 

  const Header({
    super.key,
    required this.titulo,
    this.backgroundColor = const Color(0xFF00358E),
    this.textColor = Colors.white,
    this.backIcon = Icons.arrow_back_ios,
    this.destinoAoVoltar,
    this.height = 70, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, 
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(backIcon, color: textColor),
            onPressed: () {
              if (destinoAoVoltar != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destinoAoVoltar!),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                titulo,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
