import 'package:econva_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/background_decoration.dart';
import '../../widgets/econva_logo.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/section_label.dart';

class FirstAccessPage extends StatelessWidget {
  const FirstAccessPage({super.key, this.onCreateAccount, this.onHaveAccount});

  final VoidCallback? onCreateAccount;
  final VoidCallback? onHaveAccount;

  void goToCreateAccount() => Get.toNamed(AppRoutes.createAccount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08060F),
      body: BackgroundDecoration(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final h = c.maxHeight;
              final hPad = w * 0.063;
              final titleSize = (w * 0.145).clamp(34.0, 64.0);

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: h),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 8),
                          Center(
                            child: Hero(
                              tag: 'econva-logo',
                              child: EconvaLogo(size: w * 0.27),
                            ),
                          ),
                          const Spacer(flex: 10),
                          const SectionLabel(text: 'PRIMEIRO ACESSO'),
                          SizedBox(height: h * 0.022),
                          Text(
                            'Seu dinheiro.\nSob controle.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: titleSize * 0.80,
                              fontWeight: FontWeight.w800,
                              height: 1.08,
                              letterSpacing: -titleSize * 0.04,
                            ),
                          ),
                          SizedBox(height: h * 0.022),
                          Text(
                            'Uma visão clara de cada real do seu mês e a\npróxima decisão sempre à mão.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: const Color(0xFF9A98A8),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: h * 0.04),
                          Text(
                            'Econva',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -titleSize * 0.03,
                            ),
                          ),
                          const Spacer(flex: 6),
                          PrimaryButton(
                            label: 'Criar conta',
                            onPressed: goToCreateAccount,
                          ),
                          SizedBox(height: h * 0.025),
                          Center(
                            child: SecondaryButton(
                              label: 'Já tenho conta',
                              onPressed: onHaveAccount ?? () {},
                            ),
                          ),
                          SizedBox(height: h * 0.03),
                        ],
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
}
