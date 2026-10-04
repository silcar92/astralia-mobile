// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Astralia';

  @override
  String get navCosmos => 'COSMOS';

  @override
  String get navDiscover => 'DISCOVER';

  @override
  String get navStorm => 'STORM';

  @override
  String get navCommunity => 'COMMUNITY';

  @override
  String get navGalaxy => 'GALAXY';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonBody =>
      'This section is coming to the app soon. In the meantime you can use it on the web.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Log out';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Try again';

  @override
  String get loginTitle => 'Enter your galaxy';

  @override
  String get loginSubtitle => 'Discover people who can complement you.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get signIn => 'Sign in';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get noAccount => 'Don\'t have an account yet?';

  @override
  String get createAccount => 'Create account';

  @override
  String get creatingAccount => 'Creating account…';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'A first step to finding your galaxy.';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get forgotTitle => 'Recover your password';

  @override
  String get forgotIntro =>
      'Enter your email and, if an account exists, we\'ll send you a link to create a new password.';

  @override
  String get sendLink => 'Send link';

  @override
  String get sending => 'Sending…';

  @override
  String get forgotSent =>
      'If the email is registered, we sent you a link. Check your inbox and spam folder.';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get onboardingTitle => 'Your cosmic profile';

  @override
  String get onboardingBody =>
      'Complete your profile on the web to enter Astralia. Soon you\'ll be able to do it here.';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get emailInvalid => 'Enter a valid email.';

  @override
  String get passwordTooShort => 'At least 8 characters.';

  @override
  String get errorGeneric => 'Something went wrong. Try again.';

  @override
  String get errorNetwork =>
      'We couldn\'t reach the server. Check your connection and try again.';

  @override
  String get errorServer =>
      'We had a problem on our side. Try again in a moment.';

  @override
  String get errorUnauthorized => 'Your session expired. Sign in again.';

  @override
  String get errorInvalidCredentials => 'Wrong email or password.';

  @override
  String get errorTooManyAttempts =>
      'Too many attempts. Wait a while and try again.';

  @override
  String get errorEmailTaken => 'An account with that email already exists.';

  @override
  String get errorWeakPassword =>
      'That password is too weak. Use a longer, less common one.';

  @override
  String get errorEmailInvalid => 'Enter a valid email.';
}
