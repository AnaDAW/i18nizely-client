import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

Future<XFile?> openImageFile() async {
  final Directory documents = await getApplicationDocumentsDirectory();
  const XTypeGroup imageTypeGroup = XTypeGroup(
    label: 'Images (JPEGs, PNGs)',
    extensions: ['jpg', 'jpeg', 'png']
  );
  const XTypeGroup jpgTypeGroup = XTypeGroup(
    label: 'JPEGs',
    extensions: ['jpg', 'jpeg']
  );
  const XTypeGroup pngTypeGroup = XTypeGroup(
    label: 'PNGs',
    extensions: ['png']
  );

  return openFile(
    initialDirectory: documents.path,
    acceptedTypeGroups: [imageTypeGroup, jpgTypeGroup, pngTypeGroup],
    confirmButtonText: 'Add'
  );
}

Future<List<XFile>> openAppFiles() async {
  final Directory documents = await getApplicationDocumentsDirectory();
  const XTypeGroup fileTypeGroup = XTypeGroup(
    label: 'Files (JSONs, ARBs)',
    extensions: ['json', 'arb']
  );
  const XTypeGroup jsonTypeGroup = XTypeGroup(
    label: 'JSONs',
    extensions: ['json']
  );
  const XTypeGroup arbTypeGroup = XTypeGroup(
    label: 'ARBs',
    extensions: ['arb']
  );

  return openFiles(
    initialDirectory: documents.path,
    acceptedTypeGroups: [fileTypeGroup, jsonTypeGroup, arbTypeGroup],
    confirmButtonText: 'Import'
  );
}

Future<String?> saveZipFile(String name) async {
  final Directory documents = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  const XTypeGroup zipTypeGroup = XTypeGroup(
    label: 'ZIP',
    extensions: ['zip']
  );

  final FileSaveLocation? location = await getSaveLocation(
    initialDirectory: documents.path,
    acceptedTypeGroups: [zipTypeGroup],
    confirmButtonText: 'Save',
    suggestedName: '$name.zip'
  );
  return location?.path;
}