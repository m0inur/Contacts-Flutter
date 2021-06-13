import 'package:contacts/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite {
  dynamic database;
  late List<Contact> contacts;

  Future getDatabase() async {
    // IF we already have the database
    if (database != null) return;

    database = openDatabase(
      join(await getDatabasesPath(), 'contacts_database.db'),
      onCreate: (db, version) {
        print("Creating");
        return db.execute(
          'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, companyName TEXT, email TEXT, avatarImage TEXT, mobile INT, work INT, isFavourite INT)',
        );
      },
      version: 1,
    );

    if (database == null) {
      print("Couldn't connect to database - after");
    }
  }

  // Define a function that inserts dogs into the database
  Future<void> insertContact(Contact contact) async {
    // Get database
    await getDatabase();
    final db = await database;
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getContacts() async {
    // Future<List<Contact>> getContacts() async {
    await getDatabase();
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('contacts');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    contacts = List.generate(maps.length, (i) {
      return Contact(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['companyName'],
          maps[i]['email'],
          maps[i]['mobile'],
          maps[i]['work'],
          maps[i]['avatarImage'],
          maps[i]['isFavourite'],
      );
    });
  }

  Future<void> updateContact(Contact contact) async {
    await getDatabase();
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'contacts',
      contact.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    await getDatabase();
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'contacts',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
