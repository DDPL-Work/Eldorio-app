// import 'package:eldoriaCare/model/local_notification.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class NotificationDbHelper {
//   static final NotificationDbHelper _instance =
//       NotificationDbHelper._internal();
//
//   factory NotificationDbHelper() => _instance;
//
//   NotificationDbHelper._internal();
//
//   static Database? _db;
//
//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await _initDB();
//     return _db!;
//   }
//
//   Future<Database> _initDB() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'notifications.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE notifications (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             title TEXT,
//             body TEXT,
//             data TEXT,
//             timestamp TEXT,
//             read INTEGER DEFAULT 0
//           )
//         ''');
//       },
//     );
//   }
//
//   Future<void> insertNotification(LocalNotification notification) async {
//     final db = await database;
//     await db.insert(
//       'notifications',
//       notification.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<List<LocalNotification>> getAllNotifications() async {
//     final db = await database;
//     final result = await db.query('notifications', orderBy: 'id DESC');
//     return result.map((e) => LocalNotification.fromMap(e)).toList();
//   }
//
//   Future<void> clearNotifications() async {
//     final db = await database;
//     await db.delete('notifications');
//   }
//
//   Future<void> markAsRead(int id, bool read) async {
//     final db = await database;
//     await db.update(
//       'notifications',
//       {'read': read ? 1 : 0},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<void> deleteNotification(int id) async {
//     final db = await database;
//     await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
//   }
//
// }
