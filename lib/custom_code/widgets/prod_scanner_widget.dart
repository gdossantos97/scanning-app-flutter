// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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
  bool isDialogShowing =
      false; // Flag to check if the dialog is currently shown

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null && mounted) {
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
      if (scanData.code != null && !isDialogShowing) {
        // Check if dialog is not already shown
        controller.pauseCamera(); // Pause the camera when a barcode is scanned
        print("Code scanned: ${scanData.code}"); // Confirm code is scanned
        _showScanResult(scanData.code); // Show the dialog with the scan result
      }
    }, onError: (error) {
      print("Error occurred while scanning: $error");
    });
  }

  void _showScanResult(String? barcode) {
    if (barcode == null) {
      print("Barcode is null, no action taken.");
      return; // Exit the function if barcode is null
    }
    isDialogShowing = true; // Set flag to true when dialog is being shown
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Result'),
          content: Text(
              'Your product code $barcode has successfully been stored as a variable!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                isDialogShowing = false; // Reset flag when dialog is closed
                controller
                    ?.resumeCamera(); // Resume camera after the dialog is closed
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
