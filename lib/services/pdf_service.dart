import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:hrbdairy/constants.dart';
import 'package:hrbdairy/models/milk_entry.dart';

class PdfService {
  Future<Uint8List> generateCustomerSummaryPdf(List<MilkEntry> entries, String customerName, String startDate, String endDate) async {
    final pdf = pw.Document();
    double totalQuantity = entries.fold(0, (sum, entry) => sum + entry.quantity);
    double totalAmount = entries.fold(0, (sum, entry) => sum + entry.amount);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(Constants.dairyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(Constants.ownerName),
              pw.Text('Mob: ${Constants.mobileNumber}'),
              pw.SizedBox(height: 20),
              pw.Text('Customer Summary for $customerName'),
              pw.Text('From $startDate to $endDate'),
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Date'),
                      pw.Text('Shift'),
                      pw.Text('Quantity'),
                      pw.Text('Fat'),
                      pw.Text('Rate'),
                      pw.Text('Amount'),
                    ],
                  ),
                  ...entries.map((entry) => pw.TableRow(
                    children: [
                      pw.Text(entry.date),
                      pw.Text(entry.shift),
                      pw.Text(entry.quantity.toStringAsFixed(2)),
                      pw.Text(entry.fat.toStringAsFixed(2)),
                      pw.Text(entry.rate.toStringAsFixed(2)),
                      pw.Text(entry.amount.toStringAsFixed(2)),
                    ],
                  )),
                  pw.TableRow(
                    children: [
                      pw.Text('Total'),
                      pw.Text(''),
                      pw.Text(totalQuantity.toStringAsFixed(2)),
                      pw.Text(''),
                      pw.Text(''),
                      pw.Text(totalAmount.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> generateAllCustomersPdf(List<Map<String, dynamic>> customerSummaries) async {
    final pdf = pw.Document();

    for (var summary in customerSummaries) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(Constants.dairyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text(Constants.ownerName),
                pw.Text('Mob: ${Constants.mobileNumber}'),
                pw.SizedBox(height: 20),
                pw.Text('Customer: ${summary['name']}'),
                pw.SizedBox(height: 20),
                pw.Table(
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text('Date'),
                        pw.Text('Shift'),
                        pw.Text('Quantity'),
                        pw.Text('Fat'),
                        pw.Text('SNF'),
                        pw.Text('Amount'),
                      ],
                    ),
                    ...(summary['entries'] as List<MilkEntry>).map((entry) => pw.TableRow(
                      children: [
                        pw.Text(entry.date),
                        pw.Text(entry.shift),
                        pw.Text(entry.quantity.toStringAsFixed(2)),
                        pw.Text(entry.fat.toStringAsFixed(2)),
                        pw.Text(entry.snf.toStringAsFixed(2)),
                        pw.Text(entry.amount.toStringAsFixed(2)),
                      ],
                    )),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'all_customers_summary.pdf');
  }

  Future<void> generateTotalSummaryPdf(List<Map<String, dynamic>> summaries, String startDate, String endDate) async {
    final pdf = pw.Document();
    double grandTotalMilk = summaries.fold(0, (sum, s) => sum + s['totalMilk']);
    double grandTotalAmount = summaries.fold(0, (sum, s) => sum + s['totalAmount']);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(Constants.dairyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(Constants.ownerName),
              pw.Text('Mob: ${Constants.mobileNumber}'),
              pw.SizedBox(height: 20),
              pw.Text('Total Summary from $startDate to $endDate'),
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Customer'),
                      pw.Text('Total Milk'),
                      pw.Text('Total Amount'),
                    ],
                  ),
                  ...summaries.map((s) => pw.TableRow(
                    children: [
                      pw.Text(s['name']),
                      pw.Text(s['totalMilk'].toStringAsFixed(2)),
                      pw.Text(s['totalAmount'].toStringAsFixed(2)),
                    ],
                  )),
                  pw.TableRow(
                    children: [
                      pw.Text('Grand Total'),
                      pw.Text(grandTotalMilk.toStringAsFixed(2)),
                      pw.Text(grandTotalAmount.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'total_summary.pdf');
  }

  // Method 1: Customer ID, Date, Shift, Quantity, Fat, Rate, Amount with totals
  Future<Uint8List> generateCustomerSummaryPdfMethod1(List<MilkEntry> entries, String customerName, String date) async {
    final pdf = pw.Document();
    double totalQuantity = entries.fold(0, (sum, entry) => sum + entry.quantity);
    double totalAmount = entries.fold(0, (sum, entry) => sum + entry.amount);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(Constants.dairyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(Constants.ownerName),
              pw.Text('Mob: ${Constants.mobileNumber}'),
              pw.SizedBox(height: 20),
              pw.Text('Customer: $customerName'),
              pw.Text('Date: $date'),
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Customer ID'),
                      pw.Text('Date'),
                      pw.Text('Shift'),
                      pw.Text('Quantity'),
                      pw.Text('Fat'),
                      pw.Text('Rate'),
                      pw.Text('Amount'),
                    ],
                  ),
                  ...entries.map((entry) => pw.TableRow(
                    children: [
                      pw.Text(entry.customerId.toString()),
                      pw.Text(entry.date),
                      pw.Text(entry.shift),
                      pw.Text(entry.quantity.toStringAsFixed(2)),
                      pw.Text(entry.fat.toStringAsFixed(2)),
                      pw.Text(entry.rate.toStringAsFixed(2)),
                      pw.Text(entry.amount.toStringAsFixed(2)),
                    ],
                  )),
                  pw.TableRow(
                    children: [
                      pw.Text('Total'),
                      pw.Text(''),
                      pw.Text(''),
                      pw.Text(totalQuantity.toStringAsFixed(2)),
                      pw.Text(''),
                      pw.Text(''),
                      pw.Text(totalAmount.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Method 2: Customer ID, Date, Shift, Fat, SNF, Amount with totals
  Future<Uint8List> generateCustomerSummaryPdfMethod2(List<MilkEntry> entries, String customerName, String date) async {
    final pdf = pw.Document();
    double totalQuantity = entries.fold(0, (sum, entry) => sum + entry.quantity);
    double totalAmount = entries.fold(0, (sum, entry) => sum + entry.amount);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(Constants.dairyName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(Constants.ownerName),
              pw.Text('Mob: ${Constants.mobileNumber}'),
              pw.SizedBox(height: 20),
              pw.Text('Customer: $customerName'),
              pw.Text('Date: $date'),
              pw.SizedBox(height: 20),
              pw.Table(
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Customer ID'),
                      pw.Text('Date'),
                      pw.Text('Shift'),
                      pw.Text('Fat'),
                      pw.Text('SNF'),
                      pw.Text('Amount'),
                    ],
                  ),
                  ...entries.map((entry) => pw.TableRow(
                    children: [
                      pw.Text(entry.customerId.toString()),
                      pw.Text(entry.date),
                      pw.Text(entry.shift),
                      pw.Text(entry.fat.toStringAsFixed(2)),
                      pw.Text(entry.snf.toStringAsFixed(2)),
                      pw.Text(entry.amount.toStringAsFixed(2)),
                    ],
                  )),
                  pw.TableRow(
                    children: [
                      pw.Text('Total'),
                      pw.Text(''),
                      pw.Text(''),
                      pw.Text(''),
                      pw.Text(''),
                      pw.Text(totalAmount.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
