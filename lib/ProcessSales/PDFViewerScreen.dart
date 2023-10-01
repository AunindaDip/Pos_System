import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final PDFDocument pdfDocument;

  PDFViewerScreen(this.pdfDocument, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFViewer(
        document: pdfDocument,
        zoomSteps: 1,
      ),
    );
  }
}