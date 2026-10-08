import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/background_decoration.dart';
import '../../widgets/econva_logo.dart';

/// Paleta da identidade Econva (extraída da tela "Seu dinheiro. Sob controle.")
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

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({
    super.key,
    this.onSubmit,
    this.onHaveAccount,
    this.onTerms,
    this.onPrivacy,
  });

  final void Function(String email, String password)? onSubmit;
  final VoidCallback? onHaveAccount;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirm = true;
  bool _submitted = false;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = () => widget.onTerms?.call();
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => widget.onPrivacy?.call();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  String? get _emailError {
    if (!_submitted) return null;
    final v = _email.text.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    return ok ? null : 'Informe um e-mail válido.';
  }

  String? get _passError {
    if (!_submitted) return null;
    return _password.text.length >= 6 ? null : 'Use ao menos 6 caracteres.';
  }

  String? get _confirmError {
    if (!_submitted) return null;
    return _confirm.text == _password.text ? null : 'As senhas não coincidem.';
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_emailError == null && _passError == null && _confirmError == null) {
      FocusScope.of(context).unfocus();
      widget.onSubmit?.call(_email.text.trim(), _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: BackgroundDecoration(
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
                            SizedBox(height: h * 0.035),
                            _buildTitle(),
                            SizedBox(height: h * 0.03),
                            const _SectionDivider(label: 'SEU ACESSO'),
                            SizedBox(height: h * 0.022),
                            _AuthField(
                              label: 'E-mail',
                              hint: 'seu@email.com',
                              icon: Icons.mail_outline_rounded,
                              controller: _email,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              errorText: _emailError,
                              onSubmitted: (_) => _passFocus.requestFocus(),
                            ),
                            SizedBox(height: h * 0.022),
                            _AuthField(
                              label: 'Senha',
                              hint: 'Crie uma senha',
                              icon: Icons.lock_outline_rounded,
                              controller: _password,
                              focusNode: _passFocus,
                              obscure: _hidePass,
                              onToggleObscure: () =>
                                  setState(() => _hidePass = !_hidePass),
                              textInputAction: TextInputAction.next,
                              helperText: 'Mínimo de 6 caracteres.',
                              errorText: _passError,
                              onSubmitted: (_) => _confirmFocus.requestFocus(),
                            ),
                            SizedBox(height: h * 0.022),
                            _AuthField(
                              label: 'Confirmar senha',
                              hint: 'Digite a senha novamente',
                              icon: Icons.shield_outlined,
                              controller: _confirm,
                              focusNode: _confirmFocus,
                              obscure: _hideConfirm,
                              onToggleObscure: () =>
                                  setState(() => _hideConfirm = !_hideConfirm),
                              textInputAction: TextInputAction.done,
                              errorText: _confirmError,
                              onSubmitted: (_) => _submit(),
                            ),
                            const Spacer(),
                            SizedBox(height: h * 0.025),
                            _buildTerms(),
                            SizedBox(height: h * 0.022),
                            _GradientButton(
                              label: 'Criar conta',
                              onPressed: _submit,
                            ),
                            SizedBox(height: h * 0.025),
                            _buildLoginLink(),
                            SizedBox(height: h * 0.03),
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
            Container(width: 20, height: 2, color: _C.accent),
            const SizedBox(width: 10),
            const Text(
              'NOVO CADASTRO',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: _C.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Crie sua conta.',
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
          'Leva menos de um minuto. Depois, conecte seus bancos.',
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

  Widget _buildTerms() {
    const base = TextStyle(
      fontFamily: 'Roboto',
      color: _C.textMuted,
      fontSize: 13,
      height: 1.5,
    );
    const link = TextStyle(
      fontFamily: 'Roboto',
      color: _C.accentLight,
      fontSize: 13,
      height: 1.5,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: _C.accentLight,
    );
    return Center(
      child: Text.rich(
        TextSpan(
          style: base,
          children: [
            const TextSpan(
                text: 'Ao criar sua conta, você concorda com nossos '),
            TextSpan(text: 'Termos de Uso', style: link, recognizer: _termsTap),
            const TextSpan(text: ' e '),
            TextSpan(
              text: 'Política de Privacidade',
              style: link,
              recognizer: _privacyTap,
            ),
            const TextSpan(text: '.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: widget.onHaveAccount,
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
                TextSpan(text: 'Já tem uma conta? '),
                TextSpan(
                  text: 'Entrar',
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

/// Divisor "ícone + rótulo + linha" da seção.
class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.vpn_key_outlined, size: 16, color: _C.textHint),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: _C.textHint,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_C.fieldBorder, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Campo de texto com estado de foco em roxo.
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
    this.helperText,
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
  final String? helperText;
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
                          spreadRadius: 0,
                        ),
                      ]
                    : const [],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    icon,
                    size: 22,
                    color: focused ? _C.accentLight : _C.textHint,
                  ),
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
        if (hasError || helperText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText ?? helperText!,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: hasError ? _C.error : _C.textMuted,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Botão principal com o degradê roxo, brilho interno e glow externo.
class _GradientButton extends StatefulWidget {
  const _GradientButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

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
            onTap: widget.onPressed,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: Stack(
              children: [
                // Brilho suave no topo, dá a sensação de iluminação
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
                  child: Text(
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
    );
  }
}
