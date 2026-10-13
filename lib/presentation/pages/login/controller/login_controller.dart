import 'package:econva_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  final hidePassword = true.obs;
  final loading = false.obs;

  final emailError = RxnString();
  final passError = RxnString();
  final formError = RxnString();

  bool _validate() {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    emailError.value = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Informe um e-mail válido.';
    passError.value = pass.length >= 6 ? null : 'Use ao menos 6 caracteres.';

    return emailError.value == null && passError.value == null;
  }

  Future<void> submit() async {
    if (loading.value) return;
    formError.value = null;
    if (!_validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    loading.value = true;
    try {
      // await _authRepository.login(
      //   emailController.text.trim(),
      //   passwordController.text,
      // );
    } catch (_) {
      formError.value = 'Não foi possível entrar. Tente novamente.';
    } finally {
      loading.value = false;
    }
  }

  void toggleObscure() => hidePassword.toggle();

  void goToCreateAccount() => Get.offNamed(AppRoutes.createAccount);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    super.onClose();
  }
}
