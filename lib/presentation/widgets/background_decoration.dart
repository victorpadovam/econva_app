import 'package:flutter/material.dart';

class BackgroundDecoration extends StatefulWidget {
  const BackgroundDecoration({super.key, required this.child});
  final Widget child;

  @override
  State<BackgroundDecoration> createState() => _BackgroundDecorationState();
}

class _BackgroundDecorationState extends State<BackgroundDecoration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
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
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _BackgroundPainter(animation: _controller),
            ),
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;

  static const _accent = Color(0xFF9C46F1);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final t = Curves.easeInOut.transform(animation.value);

    // Glow roxo superior, pulsando de leve.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.1, -1.0),
          radius: 1.0,
          colors: [
            Color.lerp(const Color(0xFF2A1A4F), const Color(0xFF331F5E), t)!,
            const Color(0x0007080B),
          ],
        ).createShader(rect),
    );

    // Mesmo centro e mesmos raios de antes, agora respirando.
    final center = Offset(size.width * 0.31, size.height * 0.145);
    final base = size.width * 0.38;

    for (var i = 0; i < 5; i++) {
      // Cada anel respira com um pequeno atraso em relação ao anterior.
      final phase = (animation.value - i * 0.08) % 1.0;
      final wave = Curves.easeInOut.transform(phase);

      final radius = base * (1 - i * 0.17) * (1 + 0.03 * wave);
      final baseOpacity = i == 0 ? 0.30 : 0.07;
      final opacity = baseOpacity * (0.65 + 0.7 * wave);

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = _accent.withValues(alpha: opacity.clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) =>
      old.animation != animation;
}
