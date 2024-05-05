// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Automatic FlutterFlow imports

import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProdScannerWidget extends StatefulWidget {
  const ProdScannerWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<ProdScannerWidget> createState() => _ProdScannerWidgetState();
}

class _ProdScannerWidgetState extends State<ProdScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: widget.width! * 0.8,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Distinguish between different types of codes
      switch (scanData.format) {
        case BarcodeFormat.qrcode:
          // Handle QR Code
          print("Scanned QR Code: ${scanData.code}");
          break;
        case BarcodeFormat.ean8:
        case BarcodeFormat.ean13:
        case BarcodeFormat.upcA:
        case BarcodeFormat.upcE:
          // Handle Barcodes
          print("Scanned Barcode: ${scanData.code}");
          break;
        default:
          // Handle other formats or unknown format
          print("Scanned Other/Unknown Format: ${scanData.code}");
          break;
      }
      // Implement additional actions based on the scanned code here
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
