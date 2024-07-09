// ignore_for_file: file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart'
    show consolidateHttpClientResponseBytes, kIsWeb;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPdfViewer extends StatefulWidget {
  const MyPdfViewer(
      {super.key, required this.pdfPath, required this.downloadUrl});
  final String pdfPath;
  final String downloadUrl;

  @override
  // ignore: library_private_types_in_public_api
  _MyPdfViewerState createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  @override
  void initState() {
    super.initState();
    getPdfBytes();
  }

  Uint8List? documentbytes;

  @override
  Widget build(BuildContext context) {
    Widget child = const CircularProgressIndicator();
    if (documentbytes != null) {
      child = SfPdfViewer.memory(documentbytes!);
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('View Notice'),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: child,
          ),
        ));
  }

  void getPdfBytes() async {
    if (kIsWeb) {
      firebase_storage.Reference pdfRef =
          firebase_storage.FirebaseStorage.instanceFor(
                  bucket: 'com.example.societyuser_app')
              .refFromURL(widget.pdfPath);
      //size mentioned here is max size to download from firebase.
      await pdfRef.getData(104857600).then((value) {
        documentbytes = value;
        setState(() {});
      });
    } else {
      HttpClient client = HttpClient();
      final Uri url = Uri.base.resolve(widget.pdfPath);
      final HttpClientRequest request = await client.getUrl(url);
      final HttpClientResponse response = await request.close();
      documentbytes = await consolidateHttpClientResponseBytes(response);
      setState(() {});
    }
  }
}
