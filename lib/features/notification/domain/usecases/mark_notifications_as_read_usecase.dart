import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class MarkNotificationsAsReadUseCase {
  final NotificationRepositoryInterface _repository;

  MarkNotificationsAsReadUseCase(this._repository);

  Future<Result<void>> call({required String token}) {
    return _repository.markNotificationsAsRead(token: token);
  }
}
