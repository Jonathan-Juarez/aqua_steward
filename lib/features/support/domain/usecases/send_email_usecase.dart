import 'package:aqua_steward/features/support/domain/repositories/contact_repository_interface.dart';

class SendEmailUsecase {
  final IContactRepository repository;

  SendEmailUsecase(this.repository);

  Future<void> call({required String subject, required String message}) async {
    return repository.sendSupportEmail(subject: subject, message: message);
  }
}
