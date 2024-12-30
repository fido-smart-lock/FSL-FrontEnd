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

String? extractNfcUid(Map<String, dynamic> tagData) {
  try {
    // Check for 'nfca' key, which commonly contains the identifier
    if (tagData.containsKey('nfca')) {
      List<int> identifier = tagData['nfca']['identifier'];

      // Convert the identifier list to a hex string UID
      String uid = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');
      return uid; // Return UID as a string
    }
  } catch (e) {
    debugPrint('Error extracting NFC UID: $e');
  }
  return null; // Return null if UID is not found
}
