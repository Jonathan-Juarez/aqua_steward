import 'package:aqua_steward/features/support/data/sources/contact_launcher_source.dart';
import 'package:aqua_steward/features/support/domain/repositories/contact_repository_interface.dart';

class ContactRepositoryImpl implements IContactRepository {
  final ContactLauncherSource contactLauncherSource;

  ContactRepositoryImpl(this.contactLauncherSource);

  @override
  Future<void> sendSupportEmail({
    required String subject,
    required String message,
  }) async {
    return contactLauncherSource.sendSupportEmail(
      subject: subject,
      message: message,
    );
  }
}
