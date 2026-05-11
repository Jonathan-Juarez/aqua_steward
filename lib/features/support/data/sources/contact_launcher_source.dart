import 'package:url_launcher/url_launcher.dart';

class ContactLauncherSource {
  static const String _supportEmail = "jonathan.juarez@ulv.edu.mx";

  /// Lanza la aplicación de correo con el asunto y mensaje proporcionados.
  Future<void> sendSupportEmail({
    required String subject,
    required String message,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: _encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': message,
      }),
    );

    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  /// Codifica los parámetros de consulta para una URI.
  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
