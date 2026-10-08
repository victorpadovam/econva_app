import 'package:flutter/material.dart';

class EconvaLogo extends StatelessWidget {
  const EconvaLogo({super.key, required this.size});
  final double size;

  static const _color = Color(0xFF9147E8);

  @override
  Widget build(BuildContext context) {
    final cell = size * 0.44;
    final gap = size * 0.12;
    final big = Radius.circular(cell / 2);
    final small = Radius.circular(cell * 0.08);

    // Folha: curva grande em cima-esquerda e embaixo-direita,
    // pontas retas em cima-direita e embaixo-esquerda.
    final leaf = BorderRadius.only(
      topLeft: big,
      topRight: small,
      bottomLeft: small,
      bottomRight: big,
    );
    final circle = BorderRadius.all(big);

    Widget shape(BorderRadius b) => Container(
          width: cell,
          height: cell,
          decoration: BoxDecoration(color: _color, borderRadius: b),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            shape(leaf),
            SizedBox(width: gap),
            shape(circle),
          ],
        ),
        SizedBox(height: gap),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            shape(circle),
            SizedBox(width: gap),
            shape(leaf), // mesma orientação da folha de cima
          ],
        ),
      ],
    );
  }
}
