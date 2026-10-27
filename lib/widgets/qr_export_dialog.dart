import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/solve.dart';
import '../services/qr_migration_service.dart';

class QrExportDialog extends StatefulWidget {
  final List<Solve> solves;
  final String cubeTypeLabel;

  const QrExportDialog(
      {super.key, required this.solves, required this.cubeTypeLabel});

  @override
  State<QrExportDialog> createState() => _QrExportDialogState();
}

class _QrExportDialogState extends State<QrExportDialog> {
  late List<String> chunks;
  final PageController _pageController = PageController();
  final GlobalKey _qrKey = GlobalKey();
  int _currentPage = 0;
  bool _isGenerating = true;

  @override
  void initState() {
    super.initState();
    _generateQRs();
  }

  Future<void> _generateQRs() async {
    chunks = QrMigrationService.encodeSolvesToQrChunks(widget.solves);
    setState(() {
      _isGenerating = false;
    });
  }

  Future<void> _shareQrCode() async {
    try {
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final buffer = byteData.buffer;
      final bytes =
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      final fileName = 'cubetrainer_qr_${_currentPage + 1}.png';

      if (kIsWeb) {
        await Share.shareXFiles(
          [XFile.fromData(bytes, mimeType: 'image/png', name: fileName)],
          text:
              'CubeTrainer - Sessione ${widget.cubeTypeLabel} (Parte ${_currentPage + 1} di ${chunks.length})',
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)],
          text:
              'CubeTrainer - Sessione ${widget.cubeTypeLabel} (Parte ${_currentPage + 1} di ${chunks.length})');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore durante la condivisione: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isGenerating) {
      return const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Generazione QR in corso..."),
          ],
        ),
      );
    }

    if (chunks.isEmpty) {
      return AlertDialog(
        title: const Text("Errore"),
        content: const Text("Nessun dato da esportare."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Chiudi"))
        ],
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final qrBoxSize = math.min(240.0, screenWidth - 96.0);

    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Esporta Sessione (${widget.cubeTypeLabel})",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              chunks.length > 1
                  ? "Scansiona tutti i QR code in sequenza o condividili come immagine."
                  : "Scansiona il QR code o condividilo come immagine.",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: qrBoxSize,
              width: qrBoxSize,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: chunks.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: RepaintBoundary(
                      key: index == _currentPage ? _qrKey : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: QrImageView(
                          data: chunks[index],
                          version: QrVersions.auto,
                          size: qrBoxSize - 16,
                          gapless: false,
                          errorCorrectionLevel: QrErrorCorrectLevel.L,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (chunks.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 16),
                    onPressed: _currentPage > 0
                        ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut)
                        : null,
                  ),
                  Text("Parte ${_currentPage + 1} di ${chunks.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: _currentPage < chunks.length - 1
                        ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut)
                        : null,
                  ),
                ],
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share, size: 18),
                label: const Text("Condividi Immagine",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _shareQrCode,
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Chiudi", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
