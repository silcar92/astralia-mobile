import '../../../../l10n/app_localizations.dart';

/// Validaciones de los formularios. El backend vuelve a validar todo: esto solo ahorra un viaje al servidor.
class Validators {
  const Validators._();

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(AppLocalizations l10n, String? value) =>
      (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null;

  static String? email(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return l10n.fieldRequired;
    return _email.hasMatch(value.trim()) ? null : l10n.emailInvalid;
  }

  static String? newPassword(AppLocalizations l10n, String? value) {
    if (value == null || value.isEmpty) return l10n.fieldRequired;
    return value.length >= 8 ? null : l10n.passwordTooShort;
  }
}
