import 'package:flutter/material.dart';
import '../styles/text_styles.dart';
import '../widgets/left_sidebar.dart';
import '../services/loan_crud.dart';
import '../widgets/popups.dart';
import '../models/loan_model.dart';

class LoanListScreen extends StatefulWidget {
  @override
  _LoanListScreenState createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  List<Loan> _loans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    final loans = await LoanService.getAllLoans();
    setState(() {
      _loans = loans;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD5D5D5),
      body: Row(
        children: [
          LeftSidebar(isLoanListScreen: true),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Loan List", style: AppTextStyles.title),
                ),
                Divider(thickness: 2),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _loans.isEmpty
                          ? Center(
                              child: Text("No loans found",
                                  style: AppTextStyles.notice),
                            )
                          : GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 4.7,
                              ),
                              itemCount: _loans.length,
                              itemBuilder: (context, index) {
                                final loan = _loans[index];
                                return GestureDetector(
                                  onTap: () =>
                                      showLoanDetailsPopup(context, loan),
                                  child: Card(
                                    color: Colors.grey[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(loan.name,
                                                  style: AppTextStyles.subtitle2
                                                      .copyWith(
                                                          color: Colors.white)),
                                              SizedBox(height: 3),
                                              Text("Loan ID: ${loan.id}",
                                                  style: AppTextStyles.subtitle
                                                      .copyWith(
                                                          color:
                                                              Colors.white70)),
                                              Text("Date: ${loan.dateTime}",
                                                  style: AppTextStyles.subtitle
                                                      .copyWith(
                                                          color:
                                                              Colors.white70)),
                                            ],
                                          ),
                                          Spacer(),
                                          Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 160),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "RM${loan.totalAmount.toStringAsFixed(2)}",
                                              style: AppTextStyles.subtitle
                                                  .copyWith(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
