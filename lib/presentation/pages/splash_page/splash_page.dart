import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/background_decoration.dart';
import '../../widgets/econva_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _turns;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // 3 voltas completas: termina exatamente na rotação 0,
    // assim o Hero não dá "pulo" quando começa a subir.
    _turns = Tween<double>(begin: 0, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // O texto "Aguarde" some no finalzinho da animação
    _textOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().whenComplete(_goToFirstAccess);
  }

  void _goToFirstAccess() {
    if (!mounted) return;
    Get.offNamed(AppRoutes.firstAccess);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08060F),
      body: BackgroundDecoration(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              return Stack(
                children: [
                  // Logo no centro, girando
                  Center(
                    child: RotationTransition(
                      turns: _turns,
                      child: Hero(
                        tag: 'econva-logo',
                        child: EconvaLogo(size: w * 0.27),
                      ),
                    ),
                  ),
                  // Texto embaixo
                  Align(
                    alignment: const Alignment(0, 0.35),
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: const Text(
                        'Aguarde, carregando...',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xFF9A98A8),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
