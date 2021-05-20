import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/colors.dart';
import 'package:vendor/errordialouge.dart';
import 'package:vendor/size_config.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _forrmkey = GlobalKey();

  Map<String, String> _userdata = {
    'category': '',
    'name': '',
    'amount': '',
    'gst': '',
    'delivery': '',
    'offer': '',
  };
  final image = ImagePicker();
  File _pickedImage1;
  File _pickedImage2;
  File _pickedImage3;
  bool isloading = false;

  Future<void> showChoice(BuildContext context, int flag) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Product Image?"),
            content: Text("Which source you want to use Camera or Gallery?"),
            actions: [
              TextButton(
                  child: Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    getImageGallery(flag);
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    getImageCamera(flag);
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future getImageCamera(int flag) async {
    final pickedimage = await image.getImage(source: ImageSource.camera);
    try {
      // final pickedimage = await image.(
      //   source: ImageSource.camera,

      // );
      final pickedImageFile = File(pickedimage.path);
      setState(() {
        _userdata['image'] = '';
        if (flag == 1) {
          _pickedImage1 = pickedImageFile;
        } else if (flag == 2) {
          _pickedImage2 = pickedImageFile;
        } else if (flag == 3) {
          _pickedImage3 = pickedImageFile;
        }
      });
    } catch (error) {
      print("photo not uploaded");
    }

    // final pickedImage = await picker.getImage(
    //   source: ImageSource.camera,
    //   imageQuality: 50,
    //   maxWidth: 150,
    // );
  }

  void showSubmitRequestSnackBar(BuildContext context, String msg) async {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: Transform.scale(
          scale: 0.8, child: SvgPicture.asset("assets/images/right.svg")),
      messageText: Text(msg, style: TextStyle(color: Colors.green)),
      backgroundColor: Colors.grey[300],
      duration: Duration(seconds: 2),
    )..show(context).then((r) {
      print("Nothing");
        // Navigator.of(context).pop();
      });
  }

  Future getImageGallery(int flag) async {
    final pickedimage = await image.getImage(source: ImageSource.gallery);
    try {
      // final pickedimage = await image.getImage(
      //   source: ImageSource.gallery,
      // );
      final pickedImageFile = File(pickedimage.path);
      setState(() {
        if (flag == 1) {
          _pickedImage1 = pickedImageFile;
        } else if (flag == 2) {
          _pickedImage2 = pickedImageFile;
        } else if (flag == 3) {
          _pickedImage3 = pickedImageFile;
        }
      });
    } catch (error) {
      print("Photo not uploaded");
    }
  }

  void submit() async {
    final isValid = _forrmkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _forrmkey.currentState.save();

      final user = await FirebaseAuth.instance.currentUser();
      if (_pickedImage1 == null ||
          _pickedImage2 == null ||
          _pickedImage3 == null) {
        showErrorDialoug(1, "Please select all the Images!", context);
        return;
      }
      setState(() {
        isloading = true;
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(_pickedImage1.path);
      await ref.putFile(_pickedImage1).onComplete;
      final url = await ref.getDownloadURL();
      var ref2 = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(_pickedImage2.path);
      await ref2.putFile(_pickedImage2).onComplete;
      final url2 = await ref2.getDownloadURL();
      var ref3 = FirebaseStorage.instance
          .ref()
          .child('product_image')
          .child(_pickedImage3.path);
      await ref3.putFile(_pickedImage3).onComplete;
      final url3 = await ref3.getDownloadURL();
      DocumentReference docRef =
          await Firestore.instance.collection('products').add(
        {
          'category': _userdata['category'],
          'name': _userdata['name'],
          'image1': url,
          'image2': url2,
          'image3': url3,
          'amount': _userdata['amount'],
          'offer': _userdata['offer'],
        },
      );
      showSubmitRequestSnackBar(context, "Successfully added!");

      setState(() {
        isloading = false;
      });
      // print(docRef.documentID);
    }
  }

  @override
  Widget build(BuildContext context) {
    var maxW = SizeConfig.widthMultiplier * 100;
    var maxH = SizeConfig.heightMultiplier * 100;
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Add New",
                style: TextStyle(fontSize: 18 * maxH / 672),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => showChoice(context, 1),
                    child: Container(
                      width: maxW * 2.5 / 9,
                      height: 80*maxH/672,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black)),
                      child: _pickedImage1 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 6),
                                  height: 30,
                                  width: maxW * 2 / 9,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Text(
                                    "Upload",
                                    style: TextStyle(fontSize: 12),
                                  )),
                                ),
                              ],
                            )
                          : Image.file(
                              _pickedImage1,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showChoice(context, 2),
                    child: Container(
                      width: maxW * 2.5 / 9,
                      height: 80*maxH/672,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black)),
                      child: _pickedImage2 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 6),
                                  height: 30,
                                  width: maxW * 2 / 9,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Text(
                                    "Upload",
                                    style: TextStyle(fontSize: 12),
                                  )),
                                ),
                              ],
                            )
                          : Image.file(
                              _pickedImage2,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showChoice(context, 3),
                    child: Container(
                      width: maxW * 2.5 / 9,
                      height: 80*maxH/672,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black)),
                      child: _pickedImage3 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 6),
                                  height: 30,
                                  width: maxW * 2 / 9,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Text(
                                    "Upload",
                                    style: TextStyle(fontSize: 12),
                                  )),
                                ),
                              ],
                            )
                          : Image.file(
                              _pickedImage3,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  
                  
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            // height: ,
            // margin: EdgeInsets.only(top: 20 * maxH / 647),
            padding: EdgeInsets.only(
                left: 20 * maxW / 360,
                right: 20 * maxW / 360,
                top: 10 * maxH / 647),
            child: Form(
                key: _forrmkey,
                child: SingleChildScrollView(
                  physics:
                      // (MediaQuery.of(context).viewInsets.bottom) ==
                      //         0
                      AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: maxH * 0.7, maxWidth: maxW),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // deliveryOptionChosen == DeliveryOptions.Delivery

                        //  Expanded(
                        //     child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Category",
                                  style: TextStyle(
                                      fontSize: 12 * maxH / 672,
                                      color: Colors.blue),
                                  textAlign: TextAlign.right),
                            ),
                            SizedBox(
                              width: 10 * maxW / 360,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Category should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['category'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Text("Product Name",
                                  style: TextStyle(
                                      fontSize: 12 * maxH / 672,
                                      color: Colors.blue),
                                  textAlign: TextAlign.right),
                            ),
                            SizedBox(
                              width: 10 * maxW / 360,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Product name should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['name'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text("Price Amount",
                                    style: TextStyle(
                                        fontSize: 12 * maxH / 672,
                                        color: Colors.blue),
                                    textAlign: TextAlign.right)),
                            SizedBox(
                              width: 10 * maxW / 360,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Price amount should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['amount'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  "GST Amount",
                                  style: TextStyle(
                                    fontSize: 12 * maxH / 672,
                                    color: Colors.blue,
                                  ),
                                  textAlign: TextAlign.right,
                                )),
                            SizedBox(
                              width: 10 * maxW / 360,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "GST amount should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['gst'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Text("Delivery Charge",
                                      style: TextStyle(
                                          fontSize: 12 * maxH / 672,
                                          color: Colors.blue),
                                      textAlign: TextAlign.right),
                                )),
                            SizedBox(
                              width: 10 * maxW / 360,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Delivery Charge should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['delivery'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text("Offer(%)",
                                    style: TextStyle(
                                        fontSize: 12 * maxH / 672,
                                        color: Colors.blue),
                                    textAlign: TextAlign.right)),
                            SizedBox(
                              width: 10 * maxW / 360,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    top: 5 * maxH / 647,
                                    bottom: 5 * maxH / 647),
                                padding: EdgeInsets.fromLTRB(
                                    15 * maxW / 360, 0, 5 * maxW / 360, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(3 * maxH / 647),
                                  color: white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 15 * maxH / 647),
                                  //  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Offer should not be empty";
                                    }
                                  },
                                  onSaved: (value) {
                                    //_userdata['address'] = value;
                                    _userdata['offer'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20 * maxH / 672,
                        ),
                        Center(
                          child: Container(
                            height: 40 * maxH / 672,
                            child: isloading
                                ? CircularProgressIndicator()
                                : Container(
                                    width: maxW * 0.8,
                                    height: maxH * 0.07,
                                    child: RaisedButton(
                                      child: Text(
                                        'Upload',
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 16 * maxH / 647,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () => submit(),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30 * maxH / 647)),
                                      color: Colors.blue[400],
                                    ),
                                  ),
                          ),
                        ),

                        // )

                        // ),

                        // Expanded(
                        //     child:

                        // )

                        //  Expanded(
                        //     child:

                        // ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
