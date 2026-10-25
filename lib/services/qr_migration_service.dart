import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/solve.dart';

class QrMigrationService {
  // A standard QR Code (version 40, L error correction) can hold ~2953 bytes.
  // Base64 expands size, so we'll chunk at 1200 characters of base64 data to be safe and ensure quick scanning.
  static const int _chunkSize = 1200;
  static const String _headerPrefix = 'CT_QR:';

  /// Converts a list of solves into compressed base64 chunks.
  /// Format: CT_QR:<total_chunks>:<current_index>:<chunk_base64_data>
  static List<String> encodeSolvesToQrChunks(List<Solve> solves) {
    if (solves.isEmpty) return [];

    // 1. Serialize to JSON array
    final jsonList = solves.map((s) => s.toMap()).toList();
    final jsonString = jsonEncode(jsonList);

    // 2. Compress using GZip on native, or raw UTF-8 on web/WebView where dart:io gzip is unavailable
    final utf8Bytes = utf8.encode(jsonString);
    final payloadBytes = kIsWeb ? utf8Bytes : gzip.encode(utf8Bytes);

    // 3. Encode to Base64
    final base64String = base64Encode(payloadBytes);

    // 4. Split into chunks
    List<String> chunks = [];
    for (int i = 0; i < base64String.length; i += _chunkSize) {
      final end = (i + _chunkSize < base64String.length)
          ? i + _chunkSize
          : base64String.length;
      chunks.add(base64String.substring(i, end));
    }

    // 5. Add headers
    final totalChunks = chunks.length;
    for (int i = 0; i < totalChunks; i++) {
      chunks[i] = '$_headerPrefix$totalChunks:$i:${chunks[i]}';
    }

    return chunks;
  }

  /// Parses a single scanned QR chunk and returns whether the assembly is complete,
  /// current progress, and the fully decoded List<Solve> if finished.
  /// Retruns [isComplete, decodedSolves, errorMessage]
  static QrDecodeResult decodeQrChunk(
      String scannedData, Map<int, String> chunkBuffer) {
    if (!scannedData.startsWith(_headerPrefix)) {
      return QrDecodeResult(
          false, null, 'Formato QR non valido per CubeTrainer.');
    }

    try {
      final parts = scannedData.substring(_headerPrefix.length).split(':');
      if (parts.length < 3) throw Exception('Header corrotto');

      final totalChunks = int.parse(parts[0]);
      final currentIndex = int.parse(parts[1]);
      final data = parts.sublist(2).join(':'); // In case data contains a colon

      chunkBuffer[currentIndex] = data;

      if (chunkBuffer.length == totalChunks) {
        // We have all chunks, reassemble
        // Sort keys to ensure order
        final sortedKeys = chunkBuffer.keys.toList()..sort();
        final assembledBase64 = sortedKeys.map((k) => chunkBuffer[k]!).join('');

        // Decode Base64
        final decodedBytes = base64Decode(assembledBase64);

        // Decompress GZip if GZip magic header (0x1f 0x8b) is present and not on web
        final bool isGzipped = decodedBytes.length >= 2 &&
            decodedBytes[0] == 0x1f &&
            decodedBytes[1] == 0x8b;
        final List<int> utf8Bytes =
            (isGzipped && !kIsWeb) ? gzip.decode(decodedBytes) : decodedBytes;

        // Decode JSON
        final jsonString = utf8.decode(utf8Bytes);
        final dynamic decodedList = jsonDecode(jsonString);

        if (decodedList is! List) {
          throw Exception('Formato JSON non valido (attesa lista)');
        }

        final solves = decodedList
            .map(
                (item) => Solve.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();

        return QrDecodeResult(true, solves, null);
      } else {
        return QrDecodeResult(
            false, null, null, totalChunks, chunkBuffer.length);
      }
    } catch (e) {
      return QrDecodeResult(false, null, 'Errore di decodifica QR: $e');
    }
  }
}

class QrDecodeResult {
  final bool isComplete;
  final List<Solve>? solves;
  final String? errorMessage;
  final int totalChunks;
  final int currentScannedChunks;

  QrDecodeResult(this.isComplete, this.solves, this.errorMessage,
      [this.totalChunks = 0, this.currentScannedChunks = 0]);
}
