import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';

Future<Map<String, dynamic>?> startNFCReading() async {
  try {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      debugPrint('NFC not available on this device.');
      return Future.error('NFC not available on this device.');
    }

    final Completer<Map<String, dynamic>?> completer = Completer();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          debugPrint('NFC Tag Detected: ${tag.data}');
          completer.complete(tag.data); // Complete with tag data
        } catch (e) {
          debugPrint('Error processing NFC tag: $e');
          completer.completeError('Failed to process NFC tag.');
        } finally {
          await NfcManager.instance.stopSession();
        }
      },
    );

    // Add a timeout to stop the session after 10 seconds
    Future.delayed(Duration(seconds: 60), () {
      if (!completer.isCompleted) {
        completer.completeError('NFC session timed out.');
        NfcManager.instance.stopSession();
      }
    });

    return completer.future;
  } catch (e) {
    debugPrint('Error reading NFC: $e');
    NfcManager.instance.stopSession();
    return Future.error('Error reading NFC: $e');
  }
}

Future<String> extractNfcUid(Map<String, dynamic> tagData) async {
  try {
    // Prioritize checking for 'nfca', but check other keys if necessary
    if (tagData.containsKey('nfca')) {
      List<int> identifier = tagData['nfca']['identifier'];
      String uid = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');
      return uid;
    } else if (tagData.containsKey('ndef')) {
      // Example handling for NDEF tags (adjust based on actual tag structure)
      debugPrint('NDEF tag detected: ${tagData['ndef']}');
      return Future.error('NDEF tags not supported for UID extraction.');
    }
  } catch (e) {
    debugPrint('Error extracting NFC UID: $e');
  }
  return Future.error('Failed to extract NFC UID');
}
