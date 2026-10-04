import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/astralia_text_field.dart';
import '../../../common/widgets/glass_card.dart';
import '../../../common/widgets/gold_button.dart';
import '../controllers/register_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_error.dart';
import '../widgets/validators.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthScaffold(
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      child: Column(
        children: [
          GlassCard(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  AstraliaTextField(
                    label: l10n.name,
                    controller: controller.name,
                    autofillHints: const [AutofillHints.givenName],
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.required(l10n, v),
                  ),
                  const SizedBox(height: 14),
                  AstraliaTextField(
                    label: l10n.email,
                    controller: controller.email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.email(l10n, v),
                  ),
                  const SizedBox(height: 14),
                  AstraliaTextField(
                    label: l10n.password,
                    controller: controller.password,
                    obscure: true,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.submit(),
                    validator: (v) => Validators.newPassword(l10n, v),
                  ),
                  const SizedBox(height: 18),
                  FormError(error: controller.error),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: GoldButton(
                        label: l10n.createAccount,
                        loadingLabel: l10n.creatingAccount,
                        loading: controller.loading.value,
                        onPressed: controller.submit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.haveAccount,
                style: AstraliaType.sans(size: 12, color: AstraliaColors.lilac),
              ),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  l10n.signIn,
                  style: AstraliaType.sans(
                    size: 12,
                    weight: FontWeight.w700,
                    color: AstraliaColors.gold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
