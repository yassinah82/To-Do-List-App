import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Secondpage.dart';
import 'dart:math';

class to_do_list extends StatefulWidget {
  const to_do_list({super.key});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<to_do_list> {
  Database? database;

  TextEditingController newSentence = TextEditingController();

  List<String> sentence = [];

  List<bool> checkboxValues = [];

  List<Color> textColor = [];

  @override
  void initState() {
    // This function is executed when the app starts. It creates the database if it doesn't exist and loads data if available.

    super.initState();

    createDatabase().then((_) {
      loadDataFromDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff0140a28),
          leading: const Icon(Icons.menu),
          title: const Text(
            "To Do List",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 325,
                child: TextFormField(
                  controller: newSentence,
                  decoration: const InputDecoration(
                    labelText: "New Sentence",
                    labelStyle: TextStyle(color: Color(0xff321a70)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff321a70))),
                    prefixIcon: Icon(Icons.edit),
                    prefixIconColor: Color(0xff321a70),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                  onPressed: () async {
                    if (newSentence.text.isNotEmpty) {
                      // Store the input before clearing the text field

                      final taskText = newSentence.text;

                      setState(() {
                        // Add the new task to the list

                        sentence.add(taskText);

                        checkboxValues.add(false); // Default unchecked

                        textColor
                            .add(const Color(0xff321a70)); // Default text color

                        newSentence.clear(); // Clear the input field
                      });

                      // Insert the new task into the database

                      try {
                        await insertToDatabase(
                          id: Random().nextInt(1000),
                          task: taskText,
                          flag: false,
                          database: database!,
                        );
                      } catch (e) {
                        print("Error inserting data: $e");
                      }
                    } else {
                      print("Input is empty.");
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: const Color(0xff321a70),
                  textColor: Colors.white,
                  child: const Text('Submit')),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondPage()));
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                color: const Color(0xff321a70),
                textColor: Colors.white,
                child: const Text('Second Page'),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sentence.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: checkboxValues[index],
                        onChanged: (value) {
                          setState(() {
                            checkboxValues[index] = value!;

                            if (value) {
                              textColor[index] = Colors.grey;
                            } else {
                              textColor[index] = Color(0xff321a70);
                            }
                          });
                          if (value == true) {
                            try {
                              deletefromdatabase(
                                  task: sentence[index], database: database!);
                              setState(() {
                                sentence.removeAt(index);
                                checkboxValues.removeAt(index);
                                textColor.removeAt(index);
                              });
                            } catch (e) {
                              print('Error deleting task $e');
                            }
                          }
                        },
                        activeColor: const Color(0xff321a70),
                      ),
                      Text(
                        sentence[index],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor[index]),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ));
  }

  // Creates the database if it doesn't exist or opens it if it does

  Future<void> createDatabase() async {
    database = await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, task TEXT, flag BIT)');
      },
    );
  }

  // Fetches data from the database

  Future<List<Map>> getDataFromDatabase(Database database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }

  // Loads data from the database and updates the app state

  Future<void> loadDataFromDatabase() async {
    List<Map> tasks = await getDataFromDatabase(database!);

    setState(() {
      sentence = tasks.map((task) => task['task'] as String).toList();

      checkboxValues = tasks.map((task) => (task['flag'] as int) == 1).toList();

      textColor = checkboxValues
          .map((checked) => checked ? Colors.grey : const Color(0xff321a70))
          .toList();
    });
  }

  // Inserts a new task into the database

  Future<void> insertToDatabase({
    required int id,
    required String task,
    required bool flag,
    required Database database,
  }) async {
    await database.transaction((txn) {
      return txn.rawInsert('INSERT INTO tasks (id, task, flag) VALUES(?, ?, ?)',
          [id, task, flag ? 1 : 0]);
    });
  }

  // Updates the flag of a task in the database

  Future<void> updateTaskFlag({
    required String task,
    required bool flag,
    required Database database,
  }) async {
    await database.rawUpdate(
      'UPDATE tasks SET flag = ? WHERE task = ?',
      [flag ? 1 : 0, task],
    );
  }
}

Future<void> deletefromdatabase({
  required String task,
  required Database database,
}) async {
  await database.rawDelete('DELETE FROM tasks WHERE task = ?', [task]);
}
