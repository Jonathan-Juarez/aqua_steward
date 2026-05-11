import 'package:aqua_steward/core/error/result.dart';
import 'package:aqua_steward/features/deposit/data/models/deposit_model.dart';
import 'package:aqua_steward/features/deposit/domain/repositories/deposit_repository_interface.dart';

class UpdateDepositUsecase {
  IDepositRepository repository;

  UpdateDepositUsecase({required this.repository});

  Future<Result<void>> updateDeposit({
    required String depositId,
    required String token,
    required DepositModel deposit,
  }) {
    return repository.updateDeposit(
      depositId: depositId,
      token: token,
      deposit: deposit,
    );
  }
}
