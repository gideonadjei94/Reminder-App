import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/screens/Home.dart';
import 'package:reminder_app/screens/Login.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/widgets/round_gradient_button.dart';
import 'package:reminder_app/widgets/round_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection("users");
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isCheck = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: media.height * 0.1),
                SizedBox(
                  width: media.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      Text(
                        "Hey there",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.01,
                      ),
                      Text(
                        "Create an Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.03,
                ),
                RoundTextField(
                  textEditingController: _firstNameController,
                  hintText: "First Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your First Name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: media.width * 0.03,
                ),
                RoundTextField(
                  textEditingController: _lastNameController,
                  hintText: "Last Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your Last Name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: media.width * 0.03,
                ),
                RoundTextField(
                  textEditingController: _emailController,
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: media.width * 0.03,
                ),
                RoundTextField(
                  textEditingController: _passwordController,
                  hintText: "Password",
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObsecureText: _isObscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                  rightIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        _isObscure
                            ? "assets/icons/show_pwd_icon.png"
                            : "assets/icons/hide_pwd_icon.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isCheck = !_isCheck;
                          });
                        },
                        icon: Icon(
                          _isCheck
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank,
                          color: AppColors.grayColor,
                        )),
                    Expanded(
                        child: Text(
                      "By clicking you accept our Privacy Policy and\nterms of Use",
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 10,
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundGradientButton(
                  title: "Create Account",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isCheck) {
                        try {
                          UserCredential userCredential =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                          String uid = userCredential.user!.uid;

                          await _users.doc(uid).set({
                            'email': _emailController.text,
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Account created")));

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    }
                  },
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "  Or  ",
                      style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.primaryColor1.withOpacity(0.5),
                                width: 1)),
                        child: Image.asset(
                          "assets/icons/google_icon.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.primaryColor1.withOpacity(0.5),
                                width: 1)),
                        child: Image.asset(
                          "assets/icons/facebook_icon.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(text: "Already have an account?  "),
                            TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: AppColors.secondaryColor1,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        )))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
