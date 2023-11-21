import 'package:chat_wamz/pages/forget_password.dart';
import 'package:chat_wamz/pages/home.dart';
import 'package:chat_wamz/pages/signup.dart';
import 'package:chat_wamz/service/database.dart';
import 'package:chat_wamz/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = '';
  String password = '';
  String name = '', pic = '', username = '', id = '';
  TextEditingController usermailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  
  UserLogin () async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot querySnapshot = await DatabaseMethods().getUserbyemail(email);
      name = "${querySnapshot.docs[0]['Name']}";
      username = "${querySnapshot.docs[0]['Username']}";
      pic = "${querySnapshot.docs[0]['Photo']}";
      id = querySnapshot.docs[0].id;
 
      await SharedPreferenceHelper().saveUserDisplayName(name);
      await SharedPreferenceHelper().saveUserName(username);
      await SharedPreferenceHelper().saveUserId(id);
      await SharedPreferenceHelper().saveUserPic(pic);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    }
    on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueGrey,
            content: Text('User not Found', style: TextStyle(
            color: Colors.black, fontSize: 18.0),
        )
        )
        );
      }
      else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text('Wrong Password Provided', style: TextStyle(
                color: Colors.black, fontSize: 18.0),
            )
        )
        );
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
              height: MediaQuery.of(context).size.height/3.0,
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0)
                )
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  Center(child: Text("SignIn",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,

                    ) ,
                  )
                  ),
                  Center(child: Text("Login to your account",
                    style: TextStyle(
                      color: Color(0xFFbbb0ff),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ) ,
                  )
                  ),
                  SizedBox(height: 15,),

                  ///ContainerBox for Login
                  ClipRRect(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                          height: MediaQuery.of(context).size.height/1.8,
                          width: MediaQuery.of(context).size.width/1.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Email Text and TextField
                                Text("Email", style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20

                                ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:  Border.all(
                                      width: 1.0,
                                      color: Colors.black38,
                                    )
                                  ),
                                  child: TextFormField(
                                    controller: usermailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter your Email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail_outline, color: Colors.blue,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),

                                /// Password Text and TextField
                                Text("Password", style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.only(left: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:  Border.all(
                                        width: 1.0,
                                        color: Colors.black38,
                                      )
                                  ),
                                  child: TextFormField(
                                    controller: userpasswordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter your Password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(

                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.lock_outline, color: Colors.blue,),
                                      suffixIcon: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isObscure = !isObscure;
                                          });
                                        },
                                          child: Icon( isObscure ? Icons.visibility : Icons.visibility_off,)
                                      ),
                                    ),
                                    obscureText: isObscure,
                                  ),
                                ),
                                SizedBox(height: 5,),

                                ///Forgot Password Section
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                                    },
                                    child: Text("Forgot Password?", style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15
                                    ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50,),
                                
                                ///Elevated Button
                                Center(
                                  child: SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_formkey.currentState!.validate()) {
                                            setState(() {
                                              email = usermailcontroller.text;
                                              password = userpasswordcontroller.text;
                                            });
                                          }
                                          UserLogin();
                                        },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue,
                                        elevation: 5.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)
                                        ),
                                      ),
                                        child: Text('SignIn', style: TextStyle(

                                        ),
                                        )

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),


                  ///Don't have an account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: Text(" Sign Up Now", style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16
                        ),
                        ),
                      ),
                    ],
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

