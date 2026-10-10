import 'dart:convert';
import 'helper.dart';

class Logger {
  static var encoder = const JsonEncoder.withIndent("     ");

  //For Error
  static void e({
    dynamic baseName = '',
    String tag = 'Logger',
    dynamic value = '',
    bool sendToServer = false,
  }) {
    if (Helper.isTester) {
      print(
        '${baseName != null && baseName.toString().isNotEmpty ? '${baseName.toString().toUpperCase()} :: ' : ''}💢 ERROR >> $tag : $value',
      );
      // _write('ERROR', tag, value);
    }
    if (sendToServer) {
      saveLogToServer('ERROR', tag, value.toString());
    }
  }

  //For Exception
  static void ex({
    dynamic baseName = '',
    String tag = 'Logger',
    dynamic value = '',
    bool sendToServer = false,
  }) {
    if (Helper.isTester) {
      print(
        '${baseName != null && baseName.toString().isNotEmpty ? '${baseName.toString().toUpperCase()} :: ' : ''}👻 EXCEPTION >> $tag : $value',
      );
      // _write('EXCEPTION', tag, value);
    }
    if (sendToServer) {
      saveLogToServer('EXCEPTION', tag, value.toString());
    }
  }

  //For Message
  static void m({
    dynamic baseName = '',
    String tag = 'Logger',
    dynamic value = '',
    bool sendToServer = false,
  }) {
    if (Helper.isTester) {
      print(
        '${baseName != null && baseName.toString().isNotEmpty ? '${baseName.toString().toUpperCase()} :: ' : ''}💬 MESSAGE >> $tag : $value',
      );
      // _write('MESSAGE', tag, value);
    }
    if (sendToServer) {
      saveLogToServer('MESSAGE', tag, value.toString());
    }
  }

  //For Response
  static void r({
    dynamic baseName = '',
    String tag = 'Logger',
    dynamic value = '',
    bool sendToServer = false,
  }) {
    if (Helper.isTester) {
      print(
        '${baseName != null && baseName.toString().isNotEmpty ? '${baseName.toString().toUpperCase()} :: ' : ''}🧾 RESPONSE >> $tag : $value',
      );
      // _write('RESPONSE', tag, value);
    }
    if (sendToServer) {
      saveLogToServer('RESPONSE', tag, value.toString());
    }
  }

  // static void _write(String type, String tag, dynamic log,
  //     {int tried = 0}) async {
  //   try {
  //     String logs = await readLogs(type);
  //     String newLogs = ',\n${encoder.convert({
  //           'time': Helper.getCurrentDate(Helper.DATE_FORMAT_3),
  //           'tag': tag,
  //           'log': log,
  //         })}$logs';
  //     String path = await getPath(type);
  //     final File file = File(path);
  //     await file.writeAsString(newLogs);
  //   } catch (e) {
  //     // print("Couldn't write file");
  //     // print(e);
  //     if (tried == 0) {
  //       _write(type, tag, log.toString(), tried: 1);
  //     }
  //   }
  // }

  // static Future<String> readLogs(String type) async {
  //   String path = await getPath(type);
  //   String text = '';
  //   try {
  //     final File file = File(path);
  //     text = await file.readAsString();
  //   } catch (e) {
  //     print("Couldn't read file");
  //     print(e.toString());
  //   }
  //   return text;
  // }

  // static Future<String> getPath(String type) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //
  //   Directory dir = Directory(
  //       '${directory.path}/${Helper.getCurrentDate(Helper.DATE_FORMAT_6)}');
  //   if (!await dir.exists()) {
  //     dir = await dir.create();
  //   }
  //
  //   File file = File('${dir.path}/${type.toLowerCase()}.txt');
  //   if (!await file.exists()) {
  //     file = await file.create();
  //   }
  //
  //   return file.path;
  // }

  static void saveLogToServer(String type, String tag, String log) {
    // Repository.instance.saveLogToServer(type: type, tag: tag, log: log);
  }
}
