import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/notification/domain/entities/notification.dart';
import 'package:aqua_steward/features/notification/domain/repositories/notification_repository_interface.dart';

class GetNotificationsUseCase {
  final INotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Result<List<Notification>>> call({required String token}) {
    return _repository.getNotifications(token: token);
  }
}
