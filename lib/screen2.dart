import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert'; // For decoding base64 strings

class Screen2 extends StatefulWidget {
  final String imgAsset; // This will hold the base64 image string
  const Screen2(this.imgAsset, {super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Future<pw.MemoryImage> _loadImageFromBase64(String base64Image) async {
    final Uint8List imageBytes =
        base64Decode(base64Image); // Decode base64 string to Uint8List
    return pw.MemoryImage(imageBytes); // Return as MemoryImage
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    // Load the image from the base64 string
    final image = await _loadImageFromBase64(widget.imgAsset);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.contain), // Add image to PDF
        ),
      ),
    );

    return pdf.save(); // Return the PDF in Uint8List format
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image to PDF"),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format), // Generate PDF when previewing
      ),
    );
  }
}
