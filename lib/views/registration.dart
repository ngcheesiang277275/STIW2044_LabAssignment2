import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/views/loginscreen.dart';
import 'package:mytutor/constants.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  RegistrationState createState() => RegistrationState();
}

final _formKey = GlobalKey<FormState>();

class RegistrationState extends State<Registration> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController passwordReenterEditingController =
      TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController homeAddressEditingController = TextEditingController();
  late double screenHeight, screenWidth, rWidth;
  var _image;
  var pathAsset = "assets/images/Picture2.png";
  bool _pwVisibility = true;
  bool _pwReenterVisibility = true;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      rWidth = screenWidth;
    } else {
      rWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Fill up the following information and registration will be done!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: GestureDetector(
                          onTap: () => {_uploadSelection()},
                          child: SizedBox(
                              height: screenHeight / 4.0,
                              width: screenWidth,
                              child: _image == null
                                  ? Image.asset(pathAsset)
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ))),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailEditingController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        bool emailValidator = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);

                        if (!emailValidator) {
                          return "The email entered is invalid.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordEditingController,
                      obscureText: _pwVisibility,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _pwVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _pwVisibility = !_pwVisibility;
                              });
                            },
                          ),
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return "Password should be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordReenterEditingController,
                      obscureText: _pwReenterVisibility,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _pwReenterVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _pwReenterVisibility = !_pwReenterVisibility;
                              });
                            },
                          ),
                          labelText: "Re-enter Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value != passwordEditingController.text) {
                          return "Password does not match.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameEditingController,
                      decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.length < 2) {
                          return 'The minimum length of name is 2 letter';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneNumberEditingController,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone Number';
                        } else if (value.length > 15) {
                          return "The maximum digit of phone number is 15.";
                        } else if (value.length < 10) {
                          return "The minimum digit of phone number is 10.";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: homeAddressEditingController,
                      decoration: InputDecoration(
                          labelText: "Home Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your home address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Row(

                    // );
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        validateInformation();
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(50)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  _uploadSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Choose picture from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _gallery(),
                        },
                    icon: const Icon(Icons.browse_gallery_outlined),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () => {Navigator.of(context).pop(), _camera()},
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  Future<void> _gallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void validateInformation() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill up all the registration information.",
          toastLength: Toast.LENGTH_SHORT);
      return;
    } else if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please upload an image", toastLength: Toast.LENGTH_SHORT);
      return;
    } else {
      Fluttertoast.showToast(
          msg: "All information are filled up completely!.",
          toastLength: Toast.LENGTH_SHORT);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          title: const Text(
            "Register new account?",
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "YES",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _RegisterUser();
              },
            ),
            TextButton(
              child: const Text(
                "NO",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } //validateInformation

  void _RegisterUser() {
    String _email = emailEditingController.text;
    String _password = passwordEditingController.text;
    String _name = nameEditingController.text;
    String _phoneNumber = phoneNumberEditingController.text;
    String _homeAddress = homeAddressEditingController.text;
    String base64image = base64Encode(_image!.readAsBytesSync());
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/user_reg.php"),
          body: {
            "name": _name,
            "email": _email,
            "password": _password,
            "phoneNumber": _phoneNumber,
            "homeAddress": _homeAddress,
            // "image": base64image,
          }).then((response) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          //User user = User.fromJson(data['data']);
          Fluttertoast.showToast(
              msg: "Success", toastLength: Toast.LENGTH_SHORT);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const LoginPage()));
        } else {
          Fluttertoast.showToast(
              msg: "Failed", toastLength: Toast.LENGTH_SHORT);
        }
      });
    }
  }
}
