import 'package:flutter/material.dart';

class To_do_list extends StatelessWidget {
  const To_do_list({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff0140a28),
        leading: const Icon(Icons.menu),
        title: const Text("To do List "),
        actions: [
          IconButton(
              onPressed: () {
                print("add");
              },
              icon: const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff321a70),
                child: Icon(Icons.add, size: 30, color: Colors.grey),
              ))
        ],
      ),
      body: Container(
          width: double.infinity,
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[300],
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xff636161),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Search",
                    style: TextStyle(color: Color(0xff636161)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: false,
                    onChanged: (value) {
                      print("Finished");
                    }),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Study for the exam",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            )
          ])),
    );
  }
}
