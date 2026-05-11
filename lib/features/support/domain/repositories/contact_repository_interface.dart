abstract class IContactRepository {
  Future<void> sendSupportEmail({
    required String subject,
    required String message,
  });
}
