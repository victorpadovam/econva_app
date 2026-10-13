import 'package:econva_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/background_decoration.dart';
import '../../widgets/econva_logo.dart';

class _C {
  static const bg = Color(0xFF08060F);
  static const field = Color(0xFF110F1A);
  static const fieldBorder = Color(0xFF241F33);
  static const accent = Color(0xFF8B45E0);
  static const accentLight = Color(0xFFA667F0);
  static const accentDeep = Color(0xFF5B21B6);
  static const textMuted = Color(0xFF9A98A8);
  static const textHint = Color(0xFF5E5B6E);
  static const error = Color(0xFFFF6B7A);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onSubmit, this.onCreateAccount});

  /// Conecte aqui a sua autenticação real. Se lançar exceção, a mensagem
  /// aparece como erro no formulário.
  final Future<void> Function(String email, String password)? onSubmit;
  final VoidCallback? onCreateAccount;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _hidePass = true;
  bool _submitted = false;
  bool _loading = false;
  String? _formError;

  bool _ready = false;
  bool _listening = false;
  Animation<double>? _routeAnim;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready || _listening) return;
    final anim = ModalRoute.of(context)?.animation;
    if (anim == null || anim.isCompleted) {
      _ready = true;
    } else {
      _routeAnim = anim..addStatusListener(_onRouteStatus);
      _listening = true;
    }
  }

  void _onRouteStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _routeAnim?.removeStatusListener(_onRouteStatus);
      _listening = false;
      setState(() => _ready = true);
    }
  }

  @override
  void dispose() {
    _routeAnim?.removeStatusListener(_onRouteStatus);
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  String? get _emailError {
    if (!_submitted) return null;
    final ok =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text.trim());
    return ok ? null : 'Informe um e-mail válido.';
  }

  String? get _passError {
    if (!_submitted) return null;
    return _password.text.length >= 6 ? null : 'Use ao menos 6 caracteres.';
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() {
      _submitted = true;
      _formError = null;
    });
    if (_emailError != null || _passError != null) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      await widget.onSubmit?.call(_email.text.trim(), _password.text);
    } catch (e) {
      if (mounted) {
        setState(
            () => _formError = 'Não foi possível entrar. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToCreateAccount() =>
      (widget.onCreateAccount ?? () => Get.offNamed(AppRoutes.createAccount))();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: RepaintBoundary(
        child: BackgroundDecoration(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final h = c.maxHeight;
                final hPad = w * 0.063;

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: h),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPad),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: h * 0.02),
                              _buildHeader(w),
                              Expanded(
                                child: IgnorePointer(
                                  ignoring: !_ready,
                                  child: AnimatedOpacity(
                                    opacity: _ready ? 1 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(flex: 5),
                                        _buildTitle(),
                                        SizedBox(height: h * 0.035),
                                        _AuthField(
                                          label: 'E-mail',
                                          hint: 'seu@email.com',
                                          icon: Icons.mail_outline_rounded,
                                          controller: _email,
                                          focusNode: _emailFocus,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          errorText: _emailError,
                                          onSubmitted: (_) =>
                                              _passFocus.requestFocus(),
                                        ),
                                        SizedBox(height: h * 0.022),
                                        _AuthField(
                                          label: 'Senha',
                                          hint: 'Digite sua senha',
                                          icon: Icons.lock_outline_rounded,
                                          controller: _password,
                                          focusNode: _passFocus,
                                          obscure: _hidePass,
                                          onToggleObscure: () => setState(
                                              () => _hidePass = !_hidePass),
                                          textInputAction: TextInputAction.done,
                                          errorText: _passError,
                                          onSubmitted: (_) => _submit(),
                                        ),
                                        if (_formError != null) ...[
                                          const SizedBox(height: 12),
                                          Text(
                                            _formError!,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              color: _C.error,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                        const Spacer(flex: 4),
                                        SizedBox(height: h * 0.025),
                                        _GradientButton(
                                          label: 'Entrar',
                                          loading: _loading,
                                          onPressed: _submit,
                                        ),
                                        SizedBox(height: h * 0.025),
                                        _buildCreateLink(),
                                        SizedBox(height: h * 0.03),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double w) {
    final logo = (w * 0.115).clamp(36.0, 52.0);
    return Row(
      children: [
        Hero(
          tag: 'econva-logo',
          flightShuttleBuilder:
              (flightContext, animation, direction, fromContext, toContext) {
            final hero = (direction == HeroFlightDirection.push
                ? toContext.widget
                : fromContext.widget) as Hero;
            return FittedBox(fit: BoxFit.contain, child: hero.child);
          },
          child: EconvaLogo(size: logo),
        ),
        const SizedBox(width: 12),
        const Text(
          'Econva',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 20, height: 2, color: _C.textHint),
            const SizedBox(width: 10),
            const Text(
              'ACESSO',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: _C.textHint,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Bom te ver de volta.',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Entre para continuar de onde parou.',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: _C.textMuted,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateLink() {
    return Center(
      child: GestureDetector(
        onTap: _goToCreateAccount,
        behavior: HitTestBehavior.opaque,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: 'Roboto',
                color: _C.textMuted,
                fontSize: 14,
              ),
              children: [
                TextSpan(text: 'Ainda não tem conta? '),
                TextSpan(
                  text: 'Criar conta',
                  style: TextStyle(
                    color: _C.accentLight,
                    fontWeight: FontWeight.w700,
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

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.focusNode,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xFFC9C7D6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ListenableBuilder(
          listenable: focusNode,
          builder: (context, _) {
            final focused = focusNode.hasFocus;
            final borderColor = hasError
                ? _C.error
                : focused
                    ? _C.accent
                    : _C.fieldBorder;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                color: _C.field,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor,
                  width: focused || hasError ? 1.4 : 1,
                ),
                boxShadow: focused && !hasError
                    ? [
                        BoxShadow(
                          color: _C.accent.withOpacity(0.22),
                          blurRadius: 16,
                        ),
                      ]
                    : const [],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(icon,
                      size: 22, color: focused ? _C.accentLight : _C.textHint),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      obscureText: obscure,
                      keyboardType: keyboardType,
                      textInputAction: textInputAction,
                      onSubmitted: onSubmitted,
                      cursorColor: _C.accentLight,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          color: _C.textHint,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                  if (onToggleObscure != null)
                    IconButton(
                      onPressed: onToggleObscure,
                      splashRadius: 20,
                      icon: Icon(
                        obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 22,
                        color: _C.textMuted,
                      ),
                    )
                  else
                    const SizedBox(width: 16),
                ],
              ),
            );
          },
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontFamily: 'Roboto',
                color: _C.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Mesmo degradê/brilho/glow do botão da CreateAccountPage, com estado de loading.
class _GradientButton extends StatefulWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
  });
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: Opacity(
        opacity: widget.loading ? 0.85 : 1,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [_C.accentLight, _C.accent, _C.accentDeep],
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: _C.accent.withOpacity(0.38),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.loading ? null : widget.onPressed,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              splashColor: Colors.white24,
              highlightColor: Colors.white10,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.white.withOpacity(0.16),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: widget.loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.label,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
