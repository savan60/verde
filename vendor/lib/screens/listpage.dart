import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor/screens/productlist.dart';
import 'package:vendor/size_config.dart';
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var maxH=SizeConfig.heightMultiplier;
    var maxW=SizeConfig.widthMultiplier;
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('products')
                  // .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data.documents;
                final user = FirebaseAuth.instance.currentUser;
               

                return Container(
                  padding: EdgeInsets.only(top: 10),
                  child: chatDocs.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Container(
                                    width: maxW * 0.6,
                                    child: Image.asset(
                                        'assets/images/add_product.png'))),
                            Text("Add Product to your Inventory!",
                                style: TextStyle(fontSize: 16 * maxH / 647)),
                          ],
                        )
                      : ListView.builder(
                          // reverse: true,
                          itemCount: chatDocs.length,
                          itemBuilder: (ctx, index) {
                            return ProductList(
                                id: chatDocs[index].documentID,
                                image: chatDocs[index]['image1'],
                                name: chatDocs[index]['name'],
                                desc: chatDocs[index]['category']);
                            // (chatDocs[index]['productName']);
                          }

                          // MessageBubble(
                          //   chatDocs[index]['text'],
                          //   chatDocs[index]['userId'] == futureSnapshot.data.uid,
                          //   chatDocs[index]['username'],
                          //   chatDocs[index]['userImage'],
                          //   key: ValueKey(chatDocs[index]
                          //       .documentID), // key just for efficently updating the list of messages
                          // ),
                          ),
                );
              });
        },
      );
  }
}