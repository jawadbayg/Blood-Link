import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationForm extends StatefulWidget {
  const DonationForm({Key? key}) : super(key: key);

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  String? Name, Age, Gender, BloodGroup, Contact, Address, Disease;
  List<Map<String, dynamic>> userdataList = [];
  String? _selectedGender;
  String? _selectedBloodGroup; // Define _selectedBloodGroup
  List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ]; // Define list of blood groups

  void getusername(String name) {
    this.Name = name;
  }

  void getuserage(String age) {
    this.Age = age;
  }

  void getusergender(String gender) {
    this.Gender = gender;
  }

  void getuserbloodgroup(String bloodgroup) {
    this.BloodGroup = bloodgroup;
  }

  void getusercontact(String contact) {
    this.Contact = contact;
  }

  void getuseraddress(String address) {
    this.Address = address;
  }

  void getuserdisease(String disease) {
    this.Disease = disease;
  }

  void createData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        Name != null &&
        Age != null &&
        Gender != null &&
        BloodGroup != null &&
        Contact != null &&
        Address != null &&
        Disease != null) {
      print("Creating data for $Name");
      CollectionReference bloodLinkCollection =
          FirebaseFirestore.instance.collection("BloodLink");
      bloodLinkCollection.doc(user.email!).set({
        "Name": Name!,
        "Age": Age!,
        "Gender": Gender!,
        "BloodGroup": BloodGroup!,
        "Contact": Contact!,
        "Address": Address!,
        "Disease": Disease!,
      }).then((value) {
        print("$Name created");
      }).catchError((error) {
        print("Failed to create data: $error");
      });
    } else {
      print(
          "One or more fields (Name, Age, Gender, BloodGroup, Contact, Address, Disease) are null. Cannot create document.");
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _diseaseController.dispose();
    _bloodgroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doner Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 220, 20,
                              60)), // Change border color when focused
                    ),
                    // Change label color
                  ),
                  cursorColor: Color.fromARGB(255, 220, 20, 60),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (String name) {
                    getusername(name);
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 220, 20,
                                    60)), // Change border color when focused
                          ),
                          // Change label color
                        ),
                        cursorColor: Color.fromARGB(255, 220, 20, 60),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onChanged: (String age) {
                          getuserage(age);
                        },
                      ),
                    ),
                    SizedBox(
                        width:
                            16), // Add spacing between Age field and Radio buttons
                    Text('Gender'),
                    Radio(
                      activeColor: Color.fromARGB(255, 220, 20, 60),
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value;
                          getusergender(
                              value!); // Call getusergender to update the form data
                        });
                      },
                    ),
                    Text('Male'),
                    Radio(
                      activeColor: Color.fromARGB(255, 220, 20, 60),
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value;
                          getusergender(
                              value!); // Call getusergender to update the form data
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _selectedBloodGroup,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedBloodGroup = value;
                      getuserbloodgroup(
                          value!); // Call getuserbloodgroup to update the form data
                    });
                  },
                  items: _bloodGroups.map((String bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Blood Group',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 220, 20,
                              60)), // Change border color when focused
                    ),
                    // Change label color
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your blood group';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 220, 20,
                              60)), // Change border color when focused
                    ),
                    // Change label color
                  ),
                  cursorColor: Color.fromARGB(255, 220, 20, 60),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  onChanged: (String contact) {
                    getusercontact(contact);
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 220, 20,
                              60)), // Change border color when focused
                    ),
                  ),
                  cursorColor: Color.fromARGB(
                      255, 220, 20, 60), // Change border color when focused

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                  onChanged: (String address) {
                    getuseraddress(address);
                  },
                ),
                TextFormField(
                  controller: _diseaseController,
                  decoration: InputDecoration(
                    labelText: 'Disease (if any)',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 220, 20,
                              60)), // Change border color when focused
                    ),
                    // Change label color
                  ),
                  cursorColor: Color.fromARGB(
                      255, 220, 20, 60), // Change cursor color when focused
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your disease';
                    }
                    return null;
                  },
                  onChanged: (String disease) {
                    getuserdisease(disease);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 220, 20, 60))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If all fields are valid, submit the form
                      _submitForm();
                    } else {
                      // If validation fails, show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all the fields')),
                      );
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text);
    final gender = _genderController.text;
    final bloodGroup = _selectedBloodGroup;
    final contact = _contactController.text;
    final address = _addressController.text;
    final disease = _diseaseController.text;

    createData();
    if (Name != null &&
        Age != null &&
        Gender != null &&
        BloodGroup != null &&
        Contact != null &&
        Address != null &&
        Disease != null) {
      _nameController.clear();
      _ageController.clear();
      _selectedGender = null;
      _selectedBloodGroup = null;
      _contactController.clear();
      _addressController.clear();
      _diseaseController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data')),
      );
    }
  }
}
