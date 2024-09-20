import 'package:ai_summary/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String? dob; // Optional date of birth
  String gender = '';
  String bio = '';
  String phoneNumber = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bio'),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      bio = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Gender'),
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            dob = DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                        }
                      },
                    ),
                  ),
                  readOnly: true,
                  initialValue: dob,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createUserProfile(name, dob, gender, bio, phoneNumber, email).then((_) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUserProfile(String name, String? dob, String gender, String bio, String phoneNumber, String email) async {
    String graphQLDocument = '''mutation CreateUserProfile(\$name: String!, \$dob: AWSDate, \$gender: String, \$bio: String, \$phoneNumber: String, \$email: String!) {
        createUserProfile(name: \$name, dateOfBirth: \$dob, gender: \$gender, bio: \$bio, phoneNumber: \$phoneNumber, email: \$email) {
          id
          name
          email
        }
      }''';

    var variables = {
      'name': name,
      'dob': dob,
      'gender': gender,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'email': email,
    };

    var request = GraphQLRequest<String>(document: graphQLDocument, variables: variables);
    var response = await Amplify.API.mutate(request: request).response;

    if (response.errors.isEmpty) {
      print('UserProfile created: ${response.data}');
    } else {
      print('Errors: ${response.errors}');
      // Handle error scenarios appropriately
    }
  }
}
