import '../models/loan_model.dart';

class LoanService {
  static List<Loan> loanList = [];

  static void addLoan(Loan loan) {
    loanList.add(loan);
  }

  static void removeLoan(String loanId) {
    loanList.removeWhere((loan) => loan.id == loanId);
  }
}
