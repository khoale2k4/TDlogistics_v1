import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> _saveSignature() async {
    if (await Permission.storage.request().isGranted) {
      final Uint8List? data = await _controller.toPngBytes();
      if (data != null) {
        Navigator.of(context).pop(data);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission Denied')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature App'),
      ),
      body: Column(
        children: [
          Signature(
            controller: _controller,
            height: MediaQuery.of(context).size.height - 300,
            backgroundColor: Colors.grey[200]!,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.clear();
                },
                child: Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _saveSignature,
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}