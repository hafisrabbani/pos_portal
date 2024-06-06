import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_portal/utils/colors.dart';
import 'package:pos_portal/widgets/button.dart';
import 'package:pos_portal/widgets/floating_button.dart';
import 'package:pos_portal/widgets/snackbar.dart';
import 'package:pos_portal/widgets/topbar.dart';
import 'package:sqflite/sqflite.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  bool _manageExternalStoragePermissionGranted = false;

  Future<void> _requestPermissions() async {
    await Permission.manageExternalStorage.request().then((value) {
      print('Manage external storage permission: ${value.isGranted}');
      setState(() {
        _manageExternalStoragePermissionGranted = value.isGranted;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          topBar(context: context, title: 'Backup & Restore', isCanBack: true),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                elevation: MaterialStateProperty.all<double>(0),
                backgroundColor:
                    MaterialStateProperty.all<Color>(MyColors.primary),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(style: BorderStyle.none),
                  ),
                ),
              ),
              onPressed: (_manageExternalStoragePermissionGranted)
                  ? () async {
                      final dbFolder = await getDatabasesPath();
                      File source1 = File('$dbFolder/pos.db');

                      Directory copyTo =
                          Directory("storage/emulated/0/POS Portal Backup");
                      if ((await copyTo.exists())) {
                        print("udah ada, jadi ga ngapa-ngapain");
                      } else {
                        print("not exist");
                        if (await copyTo
                            .create()
                            .then((_) => true)
                            .catchError((_) => false)) {
                          // Directory created successfully, proceed with copying
                        } else {
                          print('Please give permission');
                          return; // Return if permission is not granted or directory creation failed
                        }
                      }

                      String newPath = "${copyTo.path}/pos_portal_backup.db";
                      await source1.copy(newPath);

                      showCustomSnackbar(
                          context: context,
                          title: 'Berhasil Backup Data',
                          message: 'Berhasil backup data ke $newPath',
                          theme: SnackbarTheme.success);
                    }
                  : () {
                      _requestPermissions();
                    },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.backup,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Backup/Export Data',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          style: BorderStyle.solid,
                          color: MyColors.primary,
                          width: 3),
                    ),
                  ),
                ),
                onPressed: () async {
                  var databasesPath = await getDatabasesPath();
                  var dbPath = join(databasesPath, 'pos.db');

                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    // Replace the database with the new one
                    File source = File(result.files.single.path!);
                    await source.copy(dbPath);
                    showCustomSnackbar(
                        context: context,
                        title: 'Berhasil Restore Data',
                        message: 'Berhasil restore data dari ${result.files.single.path}',
                        theme: SnackbarTheme.success);
                  } else {
                    // User canceled the picker
                  }
                  // User canceled the picker
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.upload_file_rounded,
                          color: MyColors.primary,
                        ),
                      ),
                      Text(
                        'Restore/Import Data',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: MyColors.primary),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
