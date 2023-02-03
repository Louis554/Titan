import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/auth/providers/openid_provider.dart';
import 'package:myecl/loan/class/loaner.dart';
import 'package:myecl/loan/repositories/loaner_repository.dart';
import 'package:myecl/tools/providers/list_notifier.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';

class LoanerListNotifier extends ListNotifier<Loaner> {
  final LoanerRepository _loanerRepository = LoanerRepository();
  LoanerListNotifier({required String token})
      : super(const AsyncValue.loading()) {
    _loanerRepository.setToken(token);
  }

  Future<AsyncValue<List<Loaner>>> loadLoanerList() async {
    return await loadList(_loanerRepository.getLoanerList);
  }

  Future<bool> addLoaner(Loaner loaner) async {
    return await add(_loanerRepository.createLoaner, loaner);
  }

  Future<bool> updateLoaner(Loaner loaner) async {
    return await update(
        _loanerRepository.updateLoaner,
        (loaners, loaner) =>
            loaners..[loaners.indexWhere((i) => i.id == loaner.id)] = loaner,
        loaner);
  }

  Future<bool> deleteLoaner(Loaner loaner) async {
    return await delete(
        _loanerRepository.deleteLoaner,
        (loans, loan) => loans..removeWhere((i) => i.id == loan.id),
        loaner.id,
        loaner);
  }
}

final loanerListProvider =
    StateNotifierProvider<LoanerListNotifier, AsyncValue<List<Loaner>>>(
  (ref) {
    final token = ref.watch(tokenProvider);
    LoanerListNotifier orderListNotifier = LoanerListNotifier(token: token);
    tokenExpireWrapperAuth(ref, () async {
      await orderListNotifier.loadLoanerList();
    });
    return orderListNotifier;
  },
);