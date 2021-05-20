// import 'package:app/screen/login/termsAndCondition.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:vendor/colors.dart';
import 'dart:math';

import 'package:vendor/size_config.dart';

class Login extends StatefulWidget {
  static const String routename = "/login";
  Login(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _forrmkey2 = GlobalKey();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _password = '';

  // var _isLoading = false;
  // var isLoad = false;
  // var iserror = false;
  // final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
   
    void submit() {
      final isValid = _forrmkey2.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _forrmkey2.currentState.save();
        widget.submitFn(
          _userEmail.trim(),
          _password.trim(),
          _userName.trim(),
          _isLogin,
          context,
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        print("constraints is stored in sizeconfig");
        print("Max ht: ${constraints.maxHeight}");
        print("Max width: ${constraints.maxWidth}");
        var maxh = SizeConfig.heightMultiplier * 100;
        print("Maximum ht: ${maxh}");
        var maxw = constraints.maxWidth;
        return SingleChildScrollView(
          physics: (MediaQuery.of(context).viewInsets == 0)
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _forrmkey2,
            child: Column(
              children: [
                Container(
                  height: 3.5 * maxh / 8.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: maxh * 0.04, bottom: maxh * 0.04),
                        child: Text(
                          "LOGIN",
                          style: (TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w700,
                            fontSize: 20 * maxh / 647,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 2.5 * maxh / 8.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Flexible(
                      //child:
                      Container(
                        width: maxw * 0.8,
                        height: maxh * 0.08,
                        margin: EdgeInsets.only(top:30*maxh/647),
                        padding: EdgeInsets.only(
                            right: 5 * maxw / 360,
                            left: 30 * maxw / 360,
                            top: 5 * maxh / 647,
                            bottom: 10 * maxh / 647),
                        decoration: BoxDecoration(
                            
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.circular(30 * maxh / 647)),
                        child: TextFormField(
                          key: ValueKey('email'),
                          cursorColor: primaryGreen,
                          decoration: InputDecoration(
                            //helperText: ' ',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorStyle: TextStyle(
                              color: orange,
                              fontSize: 12 * maxh / 647,
                            ),
                            hintText: 'Email Id',
                            
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Enter valid email address!';
                            }
                          },
                          onSaved: (value) {
                            _userEmail = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: maxh * 0.02,
                      ),

                      // ),

                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 5 * maxw / 360,
                              left: 30 * maxw / 360,
                              top: 5 * maxh / 647,
                              bottom: 5 * maxh / 647),
                          width: maxw * 0.8,
                          height: maxh * 0.08,
                          decoration: BoxDecoration(
                            
                              color: Colors.grey[200],
                              borderRadius:
                                   BorderRadius.circular(
                                          30 * maxh / 647)),
                          child: TextFormField(
                            cursorColor: greyDark,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              errorStyle: TextStyle(
                                color: orange,
                                fontSize: 12 * maxh / 647,
                              ),
                              
                              hintText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Password must be atleast 6 characters long!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 3 * maxh / 8.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: (widget.isLoading)
                            ? CircularProgressIndicator()
                            : Container(
                                width: maxw * 0.8,
                                height: maxh * 0.07,
                                child: RaisedButton(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 14 * maxh / 647,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => submit(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30 * maxh / 647)),
                                  color: Colors.blue[400],
                                ),
                              ),
                      ),
                      SizedBox(height: 30 * maxh / 647),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  print("tapped on create new account");
                                },
                                child: Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  print("tapped on create new account");
                                },
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(color: Colors.blueAccent,
                                  decoration: TextDecoration.underline)
                                  ,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
