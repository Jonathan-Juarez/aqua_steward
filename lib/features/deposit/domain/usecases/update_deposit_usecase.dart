import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/domain/entities/deposit.dart';
import 'package:aqua_steward/features/deposit/domain/repositories/deposit_repository_interface.dart';

class UpdateDepositUsecase {
  IDepositRepository repository;

  UpdateDepositUsecase({required this.repository});

  Future<Result<void>> updateDeposit({
    required String depositId,
    required String token,
    required Deposit deposit,
  }) {
    return repository.updateDeposit(
      depositId: depositId,
      token: token,
      deposit: deposit,
    );
  }
}
