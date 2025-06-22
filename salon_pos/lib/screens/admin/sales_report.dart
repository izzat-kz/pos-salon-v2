import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../services/sales_crud.dart';
import '../../models/sales_model.dart';
import '../../widgets/left_sidebar.dart';
import '../../services/db_helper.dart';

class SalesReportScreen extends StatefulWidget {
  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  late Future<List<SalesReport>> _salesData;
  late Future<List<SalesData>> _chartData;

  @override
  void initState() {
    super.initState();
    _salesData = SalesService.getAllSales();
    _chartData = _fetchSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5D5D5),
      body: Row(
        children: [
          // ⏹️ Left Sidebar
          LeftSidebar(isAdmin: true),

          // ⏹️ Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Top Row: Sales Chart & Summary Card
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Last 30 Days Sales Chart (Left)
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 350,
                          padding: const EdgeInsets.all(16),
                          decoration: _cardStyle(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Last 30 Days Sales",
                                style: TextStyle(
                                    fontFamily: "Oswald", fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              _salesChart(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Sales Summary Card (Right Side)
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 350,
                          padding: const EdgeInsets.all(16),
                          decoration: _cardStyle(),
                          child: FutureBuilder<List<SalesReport>>(
                            future: _salesData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text("No sales data available"));
                              }

                              final sales = snapshot.data!;
                              return Column(
                                children: [
                                  const Text(
                                    "Sales Summary – Last 30 Days",
                                    style: TextStyle(
                                        fontFamily: "Oswald", fontSize: 20),
                                  ),
                                  const Divider(),
                                  _summaryRow("Total Sales",
                                      "RM ${_calculateTotalSales(sales)}"),
                                  _summaryRow("No. of Customers",
                                      "${_calculateTotalPax(sales)}"),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ⏹️ Bottom Row: Employee Sales Card + Sales Trend Chart
                  Row(
                    children: [
                      // Sales by Employees
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 330,
                          padding: const EdgeInsets.all(16),
                          decoration: _cardStyle(),
                          child: FutureBuilder<List<SalesData>>(
                            future: _fetchEmployeeSalesData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text(
                                        "No employee sales data available"));
                              }

                              final data = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Sales Made by Employees",
                                    style: TextStyle(
                                        fontFamily: "Oswald", fontSize: 20),
                                  ),
                                  const Divider(),
                                  ...data.map((sale) => _summaryRow(sale.day,
                                      "RM ${sale.amount.toStringAsFixed(2)}")),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Sales Trends
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _cardStyle(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sales Trends",
                                style: TextStyle(
                                    fontFamily: "Oswald", fontSize: 20),
                              ),
                              const Divider(),
                              _salesTrendChart(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ⚙️ Sales Trend Chart Widget
  Widget _salesTrendChart() {
    return FutureBuilder<List<SalesData>>(
      future: _fetchSalesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No sales trend data available"));
        }

        final data = snapshot.data!;

        return SizedBox(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.y',
              builder: (data, point, series, pointIndex, seriesIndex) {
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "RM ${(point.y as num).toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Oswald",
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
            series: <ChartSeries>[
              LineSeries<SalesData, String>(
                dataSource: data,
                xValueMapper: (SalesData sales, _) => sales.day, // Date
                yValueMapper: (SalesData sales, _) =>
                    sales.amount, // Sales Total
                color: Colors.greenAccent,
                name: 'Sales Trend',
              )
            ],
          ),
        );
      },
    );
  }

  /// ⚙️ Fetch Employee Sales Data
  Future<List<SalesData>> _fetchEmployeeSalesData() async {
    final db = await DBHelper().database;
    final result = await db.rawQuery('''
    SELECT s.staff_name AS employeeName, SUM(sr.total_amount) AS totalSales
    FROM sales_report sr
    LEFT JOIN staff s ON sr.staff_id = s.staff_id
    WHERE sr.date >= date('now', '-30 days')
    GROUP BY s.staff_name
    ORDER BY totalSales DESC
  ''');

    return result.map((row) {
      return SalesData(row['employeeName'] as String? ?? "Unknown Staff",
          (row['totalSales'] as num).toDouble());
    }).toList();
  }

  /// ⚙️ Fetch Last 30 Days Sales Data for Chart
  Future<List<SalesData>> _fetchSalesData() async {
    final db = await DBHelper().database;
    final result = await db.rawQuery('''
    SELECT strftime('%d-%m-%Y', date) AS formattedDate, SUM(total_amount) AS totalSales
    FROM sales_report
    WHERE date >= date('now', '-30 days')
    GROUP BY formattedDate
    ORDER BY formattedDate ASC
  ''');

    return result.map((row) {
      final displayDate = row['formattedDate'] as String;
      return SalesData(displayDate, (row['totalSales'] as num).toDouble());
    }).toList();
  }

  /// ⚙️ Sales Chart Widget
  Widget _salesChart() {
    return FutureBuilder<List<SalesData>>(
      future: _fetchSalesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No sales data available"));
        }

        final data = snapshot.data!;

        return SizedBox(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.y',
              builder: (data, point, series, pointIndex, seriesIndex) {
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "RM ${(point.y as num).toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Oswald",
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
            series: <ChartSeries>[
              ColumnSeries<SalesData, String>(
                dataSource: data,
                xValueMapper: (SalesData sales, _) => sales.day, // Date
                yValueMapper: (SalesData sales, _) =>
                    sales.amount, // Sales Total
                color: Colors.blueAccent,
                name: 'Sales',
              )
            ],
          ),
        );
      },
    );
  }

  /// ⚙️ Summary Calculation Helpers
  double _calculateTotalSales(List<SalesReport> sales) =>
      sales.fold(0, (sum, sale) => sum + sale.totalAmount);

  int _calculateTotalPax(List<SalesReport> sales) =>
      sales.fold(0, (sum, sale) => sum + sale.pax);

  /// 📋 Summary Row UI
  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Card Styling
  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
      ],
    );
  }
}

/// ⚙️ SalesData Model
class SalesData {
  final String day;
  final double amount;

  SalesData(this.day, this.amount);
}
