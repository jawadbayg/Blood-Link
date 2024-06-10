import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloodbankmanager/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? Name, Age, Cell;
  List<Map<String, dynamic>> dataList = [];

  void getUserName(String name) {
    this.Name = name;
  }

  void getUserAge(String age) {
    this.Age = age;
  }

  void getUserCell(String cell) {
    this.Cell = cell;
  }

  createData() {
    if (Name != null && Age != null && Cell != null) {
      print("Creating data for $Name");
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("bloodbank").doc(Name);

      Map<String, String> data = {"Name": Name!, "Age": Age!, "Cell": Cell!};

      documentReference
          .set(data)
          .whenComplete(() => print("$Name created"))
          .catchError((e) => print(e));
    } else {
      print("Name, Age, or Cell is null. Cannot create document.");
    }
  }

  readData() {
    if (Name != null) {
      print("Reading data for $Name");
      FirebaseFirestore.instance
          .collection("bloodbank")
          .doc(Name)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey("Name")) {
            print("Name: ${data['Name']}");
            if (data.containsKey("Age")) {
              print("Age: ${data['Age']}");
            }
            if (data.containsKey("Cell")) {
              print("Cell: ${data['Cell']}");
            }
          } else {
            print("Name field does not exist in the document");
          }
        } else {
          print("Document does not exist in the database");
        }
      }).catchError((error) {
        print("Error: $error");
      });
    } else {
      print("Name is null. Cannot read document.");
    }
  }

  updateData() {
    if (Name != null) {
      print("Updating data for $Name");
      FirebaseFirestore.instance
          .collection("bloodbank")
          .doc(Name)
          .update({
            if (Age != null) "Age": Age,
            if (Cell != null) "Cell": Cell,
          })
          .then((_) => print("$Name updated"))
          .catchError((error) => print("Failed to update $Name: $error"));
    } else {
      print("Name is null. Cannot update document.");
    }
  }

  deleteData() {
    if (Name != null) {
      print("Deleting data for $Name");
      FirebaseFirestore.instance
          .collection("bloodbank")
          .doc(Name)
          .delete()
          .then((_) => print("$Name deleted"))
          .catchError((error) => print("Failed to delete $Name: $error"));
    } else {
      print("Name is null. Cannot delete document.");
    }
  }

  // Function to sign out
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (String name) {
                  getUserName(name);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Age",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (String age) {
                  getUserAge(age);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Cell",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onChanged: (String cell) {
                  getUserCell(cell);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      createData();
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    readData();
                  },
                  child: Text(
                    "Read",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                  onPressed: () {
                    updateData();
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    deleteData();
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0), // Spacer between buttons and data
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: dataList.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text("Name: ${dataList[index]['Name']}"),
            //         subtitle: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text("Age: ${dataList[index]['Age']}"),
            //             Text("Cell: ${dataList[index]['Cell']}"),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Container(
              height: MediaQuery.of(context).size.height *
                  0.5, // Adjust the height as needed
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("bloodbank")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot = docs[index];
                        final data =
                            documentSnapshot.data() as Map<String, dynamic>;
                        final name = data["Name"];
                        final age = data["Age"];
                        final cell = data["Cell"];
                        return ListTile(
                          title: Text(name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Age: $age"),
                              Text("Cell: $cell"),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Text("No data available");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
