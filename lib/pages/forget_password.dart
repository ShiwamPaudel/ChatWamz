import 'package:chat_wamz/pages/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController usermailcontroller = TextEditingController();

  String email = '';
  final _formkey = GlobalKey<FormState>();
  
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content : Text('Password Reset E-mail has been sent')
      )
      );
    }
    on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content : Text('No user found for such E-mail.')
        )
        );
      }
    }
  }

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
                  Center(child: Text("Password Recovery",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,

                    ) ,
                  )
                  ),
                  Center(child: Text("Verify your E-Mail Address",
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
                          height: MediaQuery.of(context).size.height/3,
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
                                Text("Enter your E-mail", style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18

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
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail_outline, color: Colors.blue,),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40,),

                                /// Password Text and TextField

                                ///Elevated Button
                                Center(
                                  child: SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_formkey.currentState!.validate()) {
                                            setState(() {
                                              email = usermailcontroller.text;
                                            });
                                          }
                                          resetPassword();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue,
                                          elevation: 5.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                        ),
                                        child: Text('Send Code', style: TextStyle(

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


                  ///Already know your password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nevermind. I think I will ", style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                        },
                        child: Text(" Login Instead", style: TextStyle(
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
