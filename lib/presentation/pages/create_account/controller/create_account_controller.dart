import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmFocus = FocusNode();

  final hidePassword = true.obs;
  final hideConfirm = true.obs;

  final emailError = RxnString();
  final passError = RxnString();
  final confirmError = RxnString();

  late final TapGestureRecognizer termsTap;
  late final TapGestureRecognizer privacyTap;

  @override
  void onInit() {
    super.onInit();
    termsTap = TapGestureRecognizer()..onTap = openTerms;
    privacyTap = TapGestureRecognizer()..onTap = openPrivacy;
  }

  void submit() {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    emailError.value = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Informe um e-mail válido.';
    passError.value = pass.length >= 6 ? null : 'Use ao menos 6 caracteres.';
    confirmError.value =
        confirmController.text == pass ? null : 'As senhas não coincidem.';

    if (emailError.value == null &&
        passError.value == null &&
        confirmError.value == null) {
      FocusManager.instance.primaryFocus?.unfocus();
      // TODO: chamar o cadastro (repository/usecase) e navegar para o próximo passo
    }
  }

  void goToLogin() =>
      Get.back(); // veio da FirstAccess; troque quando existir a rota de login
  void openTerms() {} // TODO
  void openPrivacy() {} // TODO

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    confirmFocus.dispose();
    termsTap.dispose();
    privacyTap.dispose();
    super.onClose();
  }
}
