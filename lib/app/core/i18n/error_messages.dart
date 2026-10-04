import '../../../l10n/app_localizations.dart';
import '../network/api_exception.dart';

/// Convierte un error en un texto traducido para la persona. Prioridad: código estable del backend > código de campo >
/// tipo de fallo > genérico. Nunca se muestra el `detail` del servidor (viene en español).
///
/// [wrongCredentialsOn401]: al entrar, un 401 significa correo o contraseña incorrectos, no "sesión vencida".
String errorMessage(
  AppLocalizations l10n,
  Object? error, {
  bool wrongCredentialsOn401 = false,
}) {
  if (error is! ApiException) return l10n.errorGeneric;
  if (error.isNetwork) return l10n.errorNetwork;

  switch (error.code) {
    case 'too_many_attempts':
      return l10n.errorTooManyAttempts;
    case 'weak_password':
      return l10n.errorWeakPassword;
  }

  for (final code in error.fieldCodes) {
    switch (code) {
      case 'email_taken':
        return l10n.errorEmailTaken;
      case 'password_too_short':
      case 'password_too_common':
      case 'password_entirely_numeric':
      case 'password_too_similar':
        return l10n.errorWeakPassword;
      case 'invalid':
        return l10n.errorEmailInvalid;
    }
  }

  if (error.status == 429) return l10n.errorTooManyAttempts;
  if (error.status == 401) {
    return wrongCredentialsOn401
        ? l10n.errorInvalidCredentials
        : l10n.errorUnauthorized;
  }
  if (error.isServerError) return l10n.errorServer;
  return l10n.errorGeneric;
}
