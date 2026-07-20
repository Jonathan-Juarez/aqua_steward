import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class DeleteNotificationUseCase {
  final NotificationRepositoryInterface _repository;

  DeleteNotificationUseCase(this._repository);

  Future<Result<void>> call({required String notificationId, required String token}) {
    return _repository.deleteNotification(notificationId: notificationId, token: token);
  }
}
