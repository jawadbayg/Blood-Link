import 'package:bloodbankmanager/adddonationform.dart';
import 'package:bloodbankmanager/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  String _searchQuery = '';
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(
                    255, 220, 20, 60), // Crimson color for the drawer header
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10), // Add some space
                  FutureBuilder(
                    future: FirebaseAuth.instance.authStateChanges().first,
                    builder:
                        (BuildContext context, AsyncSnapshot<User?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                            snapshot.data!.email ??
                                '', // Display email if available
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          );
                        } else {
                          return Text(
                            'User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.data_usage),
              title: Text('My Data'),
              onTap: () {
                // Navigate to a new screen to display the user's data
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyDataPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 190.0,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(255, 220, 20, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Builder(
                          builder: (context) {
                            return IconButton(
                              icon: Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Blood Link',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DonationForm()));
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: TextEditingController(text: _searchQuery),
                      decoration: InputDecoration(
                        hintText: 'Search by City or Blood Group',
                        hintStyle: TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.redAccent, // Crimson color
                      textAlign: TextAlign
                          .left, // Ensure cursor stays at rightmost position
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),

                  // Dropdown for selecting search criteria
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('BloodLink')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No donors found.'),
                        );
                      }
                      // Filter the data based on search query
                      final filteredData = snapshot.data!.docs.where((doc) {
                        final locationMatch = doc['Address']
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                        final bloodGroupMatch = doc['BloodGroup']
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                        return locationMatch || bloodGroupMatch;
                      }).toList();
                      if (filteredData.isEmpty) {
                        return Center(
                          child: Text('No donors found for $_searchQuery'),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = filteredData[index];
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailsScreen(userId: document.id),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 230, 228),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                trailing: Icon(Icons.arrow_forward),
                                title: Text(
                                  data['Name'],
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  data['BloodGroup'],
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({required this.userId});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donar Details'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('BloodLink')
            .doc(userId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 220, 20, 60),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('User not found.'),
            );
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 220, 20, 60),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Column(
                      children: [
                        CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                AssetImage("assets/images/avatar.jpg")),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${data['Name']}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),

                    ListTile(
                      title: Text(
                        'Age: ${data['Age']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Gender: ${data['Gender']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Blood Group: ${data['BloodGroup']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    // ListTile(
                    //   title: Text(
                    //     'Contact: ${data['Contact']}',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    ListTile(
                      title: Text(
                        'Address: ${data['Address']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Disease: ${data['Disease']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _makePhoneCall(data['Contact']);
                        },
                        icon: Icon(Icons.call, color: Colors.redAccent),
                        label: Text('Call',
                            style: TextStyle(color: Colors.redAccent)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color.fromARGB(255, 220, 20, 60),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MyDataPage extends StatefulWidget {
  const MyDataPage({Key? key}) : super(key: key);

  @override
  _MyDataPageState createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  late User? user;
  late CollectionReference bloodLinkCollection;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    bloodLinkCollection = FirebaseFirestore.instance.collection("BloodLink");
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserData() async {
    if (user != null) {
      final querySnapshot = await bloodLinkCollection
          .where('email', isEqualTo: user!.email)
          .get() as QuerySnapshot<Map<String, dynamic>>;
      return querySnapshot;
    } else {
      throw Exception('User is not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Data'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> doc) {
                return ListTile(
                  title: Text(doc['Name'] as String),
                  subtitle: Text(doc['BloodGroup'] as String),
                  // Add more fields as needed
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
