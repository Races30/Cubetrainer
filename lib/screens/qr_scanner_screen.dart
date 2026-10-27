import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/qr_migration_service.dart';
import '../services/solve_repository.dart';
import '../models/solve.dart';
import '../utils/ios_platform_helper.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final Map<int, String> _scannedChunks = {};
  int _totalChunks = 0;
  bool _isProcessing = false;
  MobileScannerController cameraController = MobileScannerController();

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final result =
            QrMigrationService.decodeQrChunk(barcode.rawValue!, _scannedChunks);

        if (result.errorMessage != null) {
          continue;
        }

        if (result.totalChunks > 0 && result.currentScannedChunks > 0) {
          setState(() {
            _totalChunks = result.totalChunks;
          });
        }

        if (result.isComplete && result.solves != null) {
          _isProcessing = true;
          IosPlatformHelper.mediumImpact();
          cameraController.stop();
          _showImportPreview(result.solves!);
          break;
        }
      }
    }
  }

  void _showImportPreview(List<Solve> solves) {
    final total = solves.length;
    final best = solves.isEmpty
        ? null
        : solves
            .map((s) => s.effectiveTimeMs())
            .reduce((a, b) => a < b ? a : b);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              title: const Text('Dati scelti pronti!'),
              content: Text(
                  'Rilevate $total solve.\nTempo migliore: ${best != null ? '${(best / 1000).toStringAsFixed(2)}s' : '--'}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _scannedChunks.clear();
                        _totalChunks = 0;
                        _isProcessing = false;
                      });
                      cameraController.start();
                    },
                    child: const Text('Annulla')),
                FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _importSolves(solves);
                    },
                    child: const Text('Importa',
                        style: TextStyle(color: Colors.white))),
              ]);
        });
  }

  Future<void> _importSolves(List<Solve> solves) async {
    final repo = ref.read(solveRepositoryProvider);
    final existingSolves = repo.getSolves();
    int imported = 0;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
                content: Row(children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Importazione...")
            ])));

    for (var s in solves) {
      final isDuplicate = existingSolves.any((ext) =>
          ext.date.microsecondsSinceEpoch == s.date.microsecondsSinceEpoch &&
          ext.scramble == s.scramble);
      if (!isDuplicate) {
        await repo.saveSolve(s);
        imported++;
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Importate $imported nuove solve (saltati ${solves.length - imported} duplicati)')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
        appBar: AppBar(title: const Text('Scan QR Sessione')),
        body: Stack(children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _handleBarcode,
          ),
          Center(
              child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF38BDF8), width: 4),
                borderRadius: BorderRadius.circular(16)),
          )),
          Positioned(
              bottom: bottomSafe + 40,
              left: 24,
              right: 24,
              child: Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF38BDF8))),
                      child: Text(
                        _totalChunks > 0
                            ? "Scansionate: ${_scannedChunks.length} di $_totalChunks parti"
                            : "Inquadra il QR Code nel box",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )))),
        ]));
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
