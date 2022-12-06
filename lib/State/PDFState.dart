import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

class PDFState extends ChangeNotifier {
  bool downloadProgressBarVisible = false;
  int progress = 0;

  void toggleProgressBarVisibility(bool state) {
    downloadProgressBarVisible = state;
    notifyListeners();
  }

  void DownloadPDF(String Path, String Code) async {
    toast("Pdf is downloading, please wait.");
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
    }

    try {
      toggleProgressBarVisibility(true);
      notifyListeners();
      Dio dio = Dio();
      Response response = await dio.download(
        Path,
        "${directory.path}/${Code}.pdf",
        onReceiveProgress: (count, total) => progress = total,
      );
      if (response.statusCode == 200) {
        toast("Downloaded Successfully");
      } else {
        toast("Failed to Download");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      toggleProgressBarVisibility(false);
      notifyListeners();
    }
  }
}
