import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/astralia_text_field.dart';
import '../../../common/widgets/glass_card.dart';
import '../../../common/widgets/gold_button.dart';
import '../controllers/forgot_password_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_error.dart';
import '../widgets/validators.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthScaffold(
      title: l10n.forgotTitle,
      subtitle: l10n.forgotIntro,
      child: Column(
        children: [
          GlassCard(
            child: Obx(
              () => controller.sent.value
                  ? Text(
                      l10n.forgotSent,
                      key: const Key('forgot-sent'),
                      style: AstraliaType.sans(size: 13),
                    )
                  : Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          AstraliaTextField(
                            label: l10n.email,
                            controller: controller.email,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => controller.submit(),
                            validator: (v) => Validators.email(l10n, v),
                          ),
                          const SizedBox(height: 18),
                          FormError(error: controller.error),
                          SizedBox(
                            width: double.infinity,
                            child: GoldButton(
                              label: l10n.sendLink,
                              loadingLabel: l10n.sending,
                              loading: controller.loading.value,
                              onPressed: controller.submit,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: Get.back,
            child: Text(
              l10n.backToLogin,
              style: AstraliaType.sans(size: 12, color: AstraliaColors.lilac),
            ),
          ),
        ],
      ),
    );
  }
}
