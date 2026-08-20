import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class UnregisterFCMTokenUseCase {
  final INotificationRepository _repository;

  UnregisterFCMTokenUseCase(this._repository);

  Future<Result<void>> call({
    required String fcmToken,
    required String authToken,
  }) {
    return _repository.unregisterToken(
      fcmToken: fcmToken,
      authToken: authToken,
    );
  }
}
