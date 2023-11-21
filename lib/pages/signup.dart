import 'package:chat_wamz/pages/home.dart';
import 'package:chat_wamz/pages/signin.dart';
import 'package:chat_wamz/service/database.dart';
import 'package:chat_wamz/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String password = '';
  String name = '';
  String confirmPassword = '';

  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String Id = randomAlphaNumeric(10);
        String user = mailcontroller.text.replaceAll('@gmail.com', '');
        String updateusername = user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter = user.substring(0,1).toUpperCase();

        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "E-mail": mailcontroller.text,
          "Username": updateusername.toUpperCase(),
          "SearchKey": firstletter,
          "Photo":
              'https://t4.ftcdn.net/jpg/01/13/99/57/360_F_113995750_dAEGvjqxnsYD6asKjeDWJoVoSqjFvdGO.jpg',
          "Id": Id,
        };

        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(mailcontroller.text.replaceAll('@gmail.com','').toUpperCase());
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserDisplayName(namecontroller.text);
        await SharedPreferenceHelper().saveUserPic('https://t4.ftcdn.net/jpg/01/13/99/57/360_F_113995750_dAEGvjqxnsYD6asKjeDWJoVoSqjFvdGO.jpg');


        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Register Success')
        )
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password is Weak'),
          ));
        }
        else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text('Email Already Exists. Login Instead.'),
          ));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
        }
      }
    }
  }

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105.0))),
            ),

            ///upper texts
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  Center(
                      child: Text(
                    "SignUp",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  )),
                  Center(
                      child: Text(
                    "Create a new Account",
                    style: TextStyle(
                      color: Color(0xFFbbb0ff),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  )),
                  SizedBox(
                    height: 15,
                  ),

                  ///ContainerBox for signup
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20.0),
                        height: MediaQuery.of(context).size.height / 1.75,
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Form(
                          key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Name Text and TextField
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black38,
                                      )),
                                  child: TextFormField(
                                    controller: namecontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your Name';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Shiwam Paudel',
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///Email Text and TextField
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black38,
                                      )),
                                  child: TextFormField(
                                    controller: mailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'JohnDoe@gmail.com',
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                /// Password Text and TextField
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black38,
                                      )),
                                  child: TextFormField(
                                    controller: passwordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your Password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: '**********',
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.blue,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isObscure = !isObscure;
                                          });
                                        },
                                        child: Icon(isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                      ),
                                    ),
                                    obscureText: isObscure,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                /// Confirm Password Text and TextField
                                Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.black38,
                                      )),
                                  child: TextFormField(
                                    controller: confirmPasswordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Confirm Your Password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: '**********',
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock_outline_sharp,
                                        color: Colors.blue,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isObscure = !isObscure;
                                          });
                                        },
                                          child: Icon(
                                              isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                                      ),
                                    ),
                                    obscureText: isObscure,
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                ///already have an account text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                                      },
                                      child: Text(
                                        " Login Now",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  ///Button and its length
                  Center(
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  email = mailcontroller.text;
                                  password = passwordcontroller.text;
                                  name = namecontroller.text;
                                  confirmPassword = confirmPasswordcontroller.text;
                                });
                              }
                              registration();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.5),
                            )),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
