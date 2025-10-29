import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

/// Barcode scanner service using `flutter_barcode_scanner`.
class BarcodeScannerService {
  /// Launches the platform scanner and returns the scanned code, or null if
  /// the user cancelled or an error occurred.
  Future<String?> scanBarcode() async {
    try {
      // The plugin returns '-1' when cancelled on some platforms.
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (result == '-1' || result.isEmpty) return null;
      return result;
    } catch (_) {
      return null;
    }
  }
}
