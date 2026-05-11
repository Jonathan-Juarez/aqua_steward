import 'package:aqua_steward/features/support/domain/usecases/send_email_usecase.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final SendEmailUsecase _sendEmailUsecase;

  ContactProvider({required SendEmailUsecase sendEmailUsecase})
    : _sendEmailUsecase = sendEmailUsecase;

  TextEditingController get subjectController => _subjectController;
  TextEditingController get messageController => _messageController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendEmail({
    required String subject,
    required String message,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _sendEmailUsecase.call(subject: subject, message: message);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
