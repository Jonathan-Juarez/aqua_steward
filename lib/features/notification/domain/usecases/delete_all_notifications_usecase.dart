import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class DeleteAllNotificationsUseCase {
  final NotificationRepositoryInterface _repository;

  DeleteAllNotificationsUseCase(this._repository);

  Future<Result<void>> call({required String token}) {
    return _repository.deleteAllNotifications(token: token);
  }
}
