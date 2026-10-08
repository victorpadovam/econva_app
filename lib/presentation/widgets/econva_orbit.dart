import 'package:flutter/material.dart';

/// Anéis concêntricos "respirando" ao redor de [child] (a logo).
class EconvaOrbit extends StatefulWidget {
  const EconvaOrbit({super.key, required this.child, required this.size});

  final Widget child;

  /// Tamanho da logo. Os raios dos anéis são proporcionais a ele.
  final double size;

  @override
  State<EconvaOrbit> createState() => _EconvaOrbitState();
}

class _EconvaOrbitState extends State<EconvaOrbit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respeita "reduzir movimento" do sistema.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _OrbitPainter(animation: _controller),
        child: widget.child,
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  static const _color = Color(0xFF9C46F1);

  // Raios como múltiplos do tamanho da logo, do maior para o menor.
  static const _radii = [1.30, 1.05, 0.80, 0.55, 0.30];
  // Opacidade base de cada anel (o externo é o mais visível).
  static const _opacities = [0.34, 0.12, 0.09, 0.07, 0.05];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final base = size.width;
    final t = Curves.easeInOut.transform(animation.value);

    // Brilho suave atrás da logo, pulsando.
    canvas.drawCircle(
      center,
      base * (0.75 + 0.08 * t),
      Paint()
        ..shader = RadialGradient(
          colors: [
            _color.withValues(alpha: 0.10 + 0.08 * t),
            _color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: base * 0.85)),
    );

    for (var i = 0; i < _radii.length; i++) {
      // Cada anel respira com um pequeno atraso em relação ao anterior.
      final phase = ((animation.value - i * 0.08) % 1.0);
      final wave = Curves.easeInOut.transform(phase);
      final scale = 1 + 0.035 * wave;
      final opacity = _opacities[i] * (0.65 + 0.7 * wave);

      canvas.drawCircle(
        center,
        base * _radii[i] * scale,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == 0 ? 1.2 : 1
          ..color = _color.withValues(alpha: opacity.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) => old.animation != animation;
}
