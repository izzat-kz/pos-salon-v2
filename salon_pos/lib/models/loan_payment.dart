class LoanPayment {
  final int id;
  final String loanId;
  final double amountPaid;
  final String paymentDate;

  LoanPayment({
    required this.id,
    required this.loanId,
    required this.amountPaid,
    required this.paymentDate,
  });

  Map<String, dynamic> toMap() => {
        'loan_id': loanId,
        'amount_paid': amountPaid,
        'payment_date': paymentDate,
      };

  factory LoanPayment.fromMap(Map<String, dynamic> map) => LoanPayment(
        id: map['id'],
        loanId: map['loan_id'],
        amountPaid: (map['amount_paid'] as num).toDouble(),
        paymentDate: map['payment_date'],
      );
}
