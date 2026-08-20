import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class MarkNotificationsAsReadUseCase {
  final INotificationRepository _repository;

  MarkNotificationsAsReadUseCase(this._repository);

  Future<Result<void>> call({required String token, String? notificationId}) {
    return _repository.markNotificationsAsRead(
      token: token,
      notificationId: notificationId,
    );
  }
}
