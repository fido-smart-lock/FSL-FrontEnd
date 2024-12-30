import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';

Future<Map<String, dynamic>?> startNFCReading() async {
  try {
    // Check if NFC is available on the device
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      debugPrint('NFC not available.');
      return null; // Return null if NFC is not available
    }

    // Completer to capture the NFC tag data asynchronously
    final Completer<Map<String, dynamic>?> completer = Completer();

    // Start NFC session and listen for discovered tags
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        debugPrint('NFC Tag Detected: ${tag.data}');

        // Complete the future with the tag data
        completer.complete(tag.data);

        // Stop the session after receiving the tag
        await NfcManager.instance.stopSession();
      },
    );

    // Return the result once the tag is discovered
    return completer.future;
  } catch (e) {
    debugPrint('Error reading NFC: $e');
    return null; // Return null in case of an error
  }
}
