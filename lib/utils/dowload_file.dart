import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFile(String _fileName, dynamic data) async {
  final response = await Dio().get(
    data,
    options: Options(
      responseType: ResponseType.bytes,
      followRedirects: false,
      receiveTimeout: 0,
    ),
  );
  final dynamic dataSave = response.data;
  if (Platform.isAndroid) {
    try {
      const String dir = '/storage/emulated/0/Download';
      await writeFile(dir, _fileName, dataSave);
    } catch (e) {
      final tempDir = await getExternalStorageDirectory();
      await writeFile(tempDir?.path ?? '', _fileName, dataSave);
    }
  } else if (Platform.isIOS) {
    final tempDir = await getApplicationDocumentsDirectory();
    await writeFile(tempDir.path, _fileName, dataSave);
  }
}

Future<void> writeFile(String path, String _fileName, dynamic data) async {
  int count = 1;
  final List<String> listName = _fileName.split('.');
  String nameFile = '';
  for (var index = 0; index < listName.length - 1; index++) {
    if (index != listName.length - 2) {
      nameFile += '${listName[index]}.';
    } else {
      nameFile += listName[index];
    }
  }
  final String extension = listName.last;
  String fullPath = '$path/$_fileName';
  File file = File(fullPath);
  while (file.existsSync()) {
    fullPath = '$path/$nameFile($count).$extension';
    count += 1;
    file = File(fullPath);
  }
  print(fullPath);
  final raf = file.openSync(mode: FileMode.write);
  raf.writeFromSync(data);
  await raf.close();
}
