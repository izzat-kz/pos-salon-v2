import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/item_catalog.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class ReceiptService {
  static Future<void> printReceipt(Map<Item, int> bill, double subtotal) async {
    final pdf = pw.Document();

    final ByteData logoData = await rootBundle.load('assets/logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    String formattedDate =
        DateFormat("dd-MM-yyyy hh:mma").format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), width: 100),
              pw.SizedBox(height: 3),

              pw.Text("-- RECEIPT --", style: pw.TextStyle(fontSize: 23)),
              pw.SizedBox(height: 5),

              pw.Text("Date: $formattedDate",
                  style: pw.TextStyle(fontSize: 14)),

              // ⏹️ divider
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: List.generate(
                      28,
                      (index) =>
                          pw.Text("- ", style: pw.TextStyle(fontSize: 18))),
                ),
              ),

              // ⏹️ Itemized List
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Column(
                  children: bill.entries.map((entry) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("${entry.key.name} x${entry.value}",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              "RM ${(entry.key.price * entry.value).toStringAsFixed(2)}",
                              style: pw.TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              pw.Spacer(),
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: List.generate(
                      28,
                      (index) =>
                          pw.Text("- ", style: pw.TextStyle(fontSize: 18))),
                ),
              ),

              pw.Text("Total: RM ${subtotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 15),

              pw.Text("THANK YOU & PLEASE COME AGAIN!",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              pw.Text("prepared by Group 8", style: pw.TextStyle(fontSize: 10)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
