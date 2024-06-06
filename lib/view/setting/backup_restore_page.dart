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

  Future<void> _showConfirmationDialog(
      BuildContext context, Function onConfirmed) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: MyColors.primary,
                size: 120,
              ),
              Text(
                'Konfirmasi pemulihan data',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary,
                    fontSize: 16),
              ),
            ],
          ),
          content: Text(
            'Apakah kamu yakin ingin memulihkan data?\nSeluruh data yang ada akan terganti dengan data yang dipilih!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 12),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed();
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFormatWarningDialog(
      BuildContext context, Function onContinue) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_rounded,
                color: MyColors.primary,
                size: 80,
              ),
              SizedBox(height: 10),
              Text(
                'Peringatan Format File',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary,
                    fontSize: 16),
              ),
            ],
          ),
          content: Text(
            'Pastikan memilih file dengan format .db',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 12),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onContinue();
              },
              child: Text(
                'Lanjutkan',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary),
              ),
            ),
          ],
        );
      },
    );
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
                  _showFormatWarningDialog(context, () async {
                    var databasesPath = await getDatabasesPath();
                    var dbPath = join(databasesPath, 'pos.db');

                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      // Replace the database with the new one
                      _showConfirmationDialog(context, () async {
                        // Replace the database with the new one
                        File source = File(result.files.single.path!);
                        await source.copy(dbPath);
                        showCustomSnackbar(
                            context: context,
                            title: 'Berhasil Restore Data',
                            message:
                                'Berhasil restore data dari ${result.files.single.path}',
                            theme: SnackbarTheme.success);
                      });
                    } else {
                      showCustomSnackbar(
                          context: context,
                          title: 'Gagal Memuat Data',
                          message: 'Gagal restore data',
                          theme: SnackbarTheme.error);
                      // User canceled the picker
                    }
                    // User canceled the picker
                  });
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
