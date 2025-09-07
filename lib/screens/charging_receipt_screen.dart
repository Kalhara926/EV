// lib/screens/charging_receipt_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart'; // For PDF document
import 'package:pdf/widgets.dart' as pw; // For PDF widgets
import 'package:printing/printing.dart'; // For PDF printing/sharing
import 'package:path_provider/path_provider.dart'; // For temporary directory
import 'dart:io'; // For File operations
import 'package:open_filex/open_filex.dart'; // To open the generated PDF
import 'package:flutter/services.dart'; // Required for PdfGoogleFonts

import '../models/charging_session.dart'; // Make sure this path is correct

class ChargingReceiptScreen extends StatelessWidget {
  final ChargingSession session;

  const ChargingReceiptScreen({super.key, required this.session});

  // Function to generate the PDF receipt
  Future<Uint8List> _generatePdf(PdfPageFormat format, ThemeData theme) async {
    final pdf = pw.Document();

    // Load fonts using rootBundle.load or from PdfGoogleFonts
    // Note: PdfGoogleFonts requires 'flutter/services.dart' import
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'EV Charge Hub - Charging Receipt',
                style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 24,
                    color: PdfColor.fromInt(
                        theme.primaryColor.value)), // Use theme color
              ),
              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 16),
              _buildPdfDetailRow(
                  'Session ID:',
                  '#${session.hashCode.toString().substring(0, 8)}',
                  font,
                  boldFont),
              _buildPdfDetailRow(
                  'Station Name:', session.stationName, font, boldFont),
              _buildPdfDetailRow(
                  'Connector Type:', session.connectorType, font, boldFont),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey200),
              pw.SizedBox(height: 12),
              _buildPdfDetailRow(
                  'Start Time:',
                  DateFormat('yyyy-MM-dd HH:mm')
                      .format(session.startTime.toLocal()),
                  font,
                  boldFont),
              _buildPdfDetailRow(
                  'End Time:',
                  DateFormat('yyyy-MM-dd HH:mm')
                      .format(session.endTime.toLocal()),
                  font,
                  boldFont),
              _buildPdfDetailRow(
                  'Duration:',
                  _formatDuration(
                      session.endTime.difference(session.startTime)),
                  font,
                  boldFont),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColors.grey200),
              pw.SizedBox(height: 12),
              _buildPdfDetailRow(
                  'Energy Consumed:',
                  '${session.energyConsumedKWh.toStringAsFixed(2)} kWh',
                  font,
                  boldFont),
              _buildPdfDetailRow(
                  'Payment Method:', session.paymentMethod, font, boldFont),
              pw.SizedBox(height: 16),
              pw.Text(
                'Total Cost:',
                style: pw.TextStyle(
                    font: boldFont, fontSize: 18, color: PdfColors.blueGrey800),
              ),
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Text(
                  'LKR ${session.cost.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      font: boldFont, fontSize: 28, color: PdfColors.green700),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Center(
                child: pw.Text(
                  'Thank you for using EV Charge Hub!',
                  style: pw.TextStyle(
                      font: font, fontSize: 12, color: PdfColors.grey600),
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  // Helper for PDF detail rows
  pw.Widget _buildPdfDetailRow(
      String label, String value, pw.Font font, pw.Font boldFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
                font: font, fontSize: 14, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
                font: boldFont, fontSize: 14, color: PdfColors.blueGrey800),
          ),
        ],
      ),
    );
  }

  // Helper to format duration (copied from previous screen)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (duration.inHours > 0) {
      return "${twoDigitHours}h ${twoDigitMinutes}m";
    } else if (duration.inMinutes > 0) {
      return "${twoDigitMinutes}m";
    } else {
      return "${twoDigits(duration.inSeconds)}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final accentColor = theme
        .colorScheme.secondary; // Access accentColor here within build method

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Receipt Details',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor, // Solid color for receipt screen app bar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.8),
              const Color(0xFF1A1A2E),
              const Color(0xFF0F0F1A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReceiptCard(theme),
              const SizedBox(height: 30),
              _buildActionButton(
                context,
                'Download Receipt (PDF)',
                Icons.download_rounded,
                primaryColor,
                () async {
                  await _savePdfAndOpen(context, theme);
                },
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                'Share Receipt',
                Icons.share_rounded,
                accentColor, // Correctly using accentColor here
                () async {
                  await _sharePdf(context, theme);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI building helpers for the screen ---

  Widget _buildReceiptCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.95), // Closer to white for receipt look
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EV Charge Hub',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          Text(
            'Charging Receipt',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[600],
            ),
          ),
          const Divider(height: 30, thickness: 1.5, color: Colors.grey),
          _buildReceiptDetailRow('Session ID:',
              '#${session.hashCode.toString().substring(0, 8)}', theme),
          _buildReceiptDetailRow('Station Name:', session.stationName, theme),
          _buildReceiptDetailRow(
              'Connector Type:', session.connectorType, theme),
          const SizedBox(height: 15),
          _buildReceiptDetailRow(
              'Start Time:',
              DateFormat('yyyy-MM-dd HH:mm')
                  .format(session.startTime.toLocal()),
              theme),
          _buildReceiptDetailRow(
              'End Time:',
              DateFormat('yyyy-MM-dd HH:mm').format(session.endTime.toLocal()),
              theme),
          _buildReceiptDetailRow(
              'Duration:',
              _formatDuration(session.endTime.difference(session.startTime)),
              theme),
          const SizedBox(height: 15),
          _buildReceiptDetailRow('Energy Consumed:',
              '${session.energyConsumedKWh.toStringAsFixed(2)} kWh', theme,
              valueColor: Colors.teal),
          _buildReceiptDetailRow(
              'Payment Method:', session.paymentMethod, theme),
          const Divider(height: 30, thickness: 1.5, color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Cost:',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              Text(
                'LKR ${session.cost.toStringAsFixed(2)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Thank you for your charge!',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptDetailRow(String label, String value, ThemeData theme,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.blueGrey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: valueColor ?? Colors.blueGrey[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 24),
      label: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
      ),
    );
  }

  // --- PDF Save and Share Logic ---

  Future<void> _savePdfAndOpen(BuildContext context, ThemeData theme) async {
    try {
      final pdfBytes = await _generatePdf(PdfPageFormat.a4, theme);
      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/ev_charge_receipt_${session.hashCode.toString().substring(0, 6)}.pdf');
      await file.writeAsBytes(pdfBytes);

      // Open the PDF
      await OpenFilex.open(file.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt downloaded successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download receipt: $e')),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context, ThemeData theme) async {
    try {
      final pdfBytes = await _generatePdf(PdfPageFormat.a4, theme);
      await Printing.sharePdf(
          bytes: pdfBytes,
          filename:
              'ev_charge_receipt_${session.hashCode.toString().substring(0, 6)}.pdf');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share receipt: $e')),
        );
      }
    }
  }
}
