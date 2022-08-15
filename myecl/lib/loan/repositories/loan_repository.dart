import 'package:myecl/loan/class/loan.dart';
import 'package:myecl/tools/repository/repository.dart';

class LoanRepository extends Repository {
  @override
  // ignore: overridden_fields
  final ext = "loans/";

  Future<List<Loan>> getLoanListByLoanerId(String loanerId) async {
    return List<Loan>.from(
        (await getList(suffix: "loaner/" + loanerId + "/loans"))
            .map((x) => Loan.fromJson(x)));
  }

  Future<List<Loan>> getMyLoanList() async {
    return List<Loan>.from(
        (await getList(suffix: "users/me")).map((x) => Loan.fromJson(x)));
  }

  Future<Loan> getLoan(String id) async {
    return Loan.fromJson(await getOne(id));
  }

  Future<Loan> createLoan(Loan loan) async {
    return Loan.fromJson(await create(loan.toJson()));
  }

  Future<bool> updateLoan(Loan loan) async {
    return await update(loan.toJson(), loan.id);
  }

  Future<bool> deleteLoan(Loan loan) async {
    return await delete(loan.id);
  }

  Future<bool> extendLoan(Loan loan) async {
    await create(loan.toJson(), suffix: loan.id + "/extend");
    return true;
  }

  Future<bool> returnLoan(Loan loan) async {
    await create(loan.toJson(), suffix: loan.id + "/return");
    return true;
  }

  Future<List<Loan>> getHistory() async {
    return List<Loan>.from(
        (await getList(suffix: "history")).map((x) => Loan.fromJson(x)));
  }
}
