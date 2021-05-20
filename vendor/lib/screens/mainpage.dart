import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vendor/colors.dart';
import 'package:vendor/screens/addproduct.dart';
import 'package:vendor/screens/listpage.dart';

//Content:      Title, Tab
//Child files:  widgets/new ui/MainPage/*
//Description:  Screen after YourOrder => Displaying details of order

class MainPage extends StatefulWidget {
  static final String routename = '/order-track-page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //variables
  int _selectedpage = 0;
  PageController _pageController;
  void _changepage(int pagenumber) {
    setState(() {
      _selectedpage = pagenumber;
      _pageController.animateToPage(pagenumber,
          duration: Duration(microseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          var maxH = constraints.maxHeight;
          var maxW = constraints.maxWidth;
          print(
              "MainPage h is ${constraints.maxHeight} w is ${constraints.maxWidth}");
          return Column(
            children: [
              Container(
                height: maxH * 0.07,
                padding: EdgeInsets.only(left: 8 * maxW / 360),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(child: Container()),
                    Expanded(
                      flex: 10,
                      child: OrderTrackTitle(),
                    ),
                    Flexible(
                      child: Container(),
                    )
                  ],
                ),
              ),

              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     padding: EdgeInsets.only(top: maxW * 6 / 360),
              //     child: OrderTrackTitle(),
              //   ),
              // ),
              Expanded(
                flex: 11,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * maxW / 360,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TabButton(
                                text: "All Items",
                                onpressed: () {
                                  _changepage(0);
                                },
                                pagenumber: 0,
                                selectedpage: _selectedpage,
                              ),
                            ),
                            SizedBox(
                              width: 16 * maxW / 360,
                            ),
                            Expanded(
                              child: TabButton(
                                text: "Out of stock",
                                onpressed: () {
                                  _changepage(1);
                                },
                                pagenumber: 1,
                                selectedpage: _selectedpage,
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: PageView(
                        onPageChanged: (int page) {
                          setState(() {
                            _selectedpage = page;
                          });
                        },
                        controller: _pageController,
                        children: [
                          ListPage(),
                          AddProductScreen(),
                        ],
                      ),
                      flex: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          decoration: BoxDecoration(color: white, boxShadow: [
                            BoxShadow(
                                color: Colors.grey[350],
                                offset: Offset(0, -2),
                                blurRadius: 0.0046 * constraints.maxHeight)
                          ]),
                          padding: EdgeInsets.fromLTRB(
                              0, 0, 0, 0.00309 * constraints.maxHeight),
                          child: BottomNavigationBar(
                            s: _selectedPageIndex,
                            changeselected: _selectPage,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}

// Contains Heading of page i.e. "Order Track" with icon
class OrderTrackTitle extends StatelessWidget {
  const OrderTrackTitle({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(
            "MainPage ordertracktitle h is ${constraints.maxHeight} w is ${constraints.maxWidth}");
        var maxH = constraints.maxHeight;
        var maxW = constraints.maxWidth;

        return Container(
          height: maxH * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 4 * maxW / 360),
              Container(
                padding: EdgeInsets.only(bottom: 1 * maxH / 44.1425),
                child: Text(
                  "Welcome Vendor",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 20 * maxH / 44.1425,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//For Styling the Tab
class TabButton extends StatelessWidget {
  final String text;
  final int selectedpage;
  final int pagenumber;
  final Function onpressed;
  TabButton({this.text, this.selectedpage, this.pagenumber, this.onpressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxH = constraints.maxHeight;
        var maxW = constraints.maxWidth;
        print(
            "MainPage tabbutton h is ${constraints.maxHeight} w is ${constraints.maxWidth}");
        return GestureDetector(
          onTap: onpressed,
          child: Container(
            width: maxW * 0.6,
            height: selectedpage == pagenumber
                ? constraints.maxHeight * 0.55
                : constraints.maxHeight * 0.5,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10.0 * maxH / 43.807, // soften the shadow
                    // offset: Offset(-2, 1),
                  ),
                ],
                border: Border.all(
                    color: selectedpage == pagenumber
                        ? Colors.blueAccent
                        : Colors.grey),
                borderRadius: BorderRadius.circular(2 * maxH / 43.807)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: selectedpage == pagenumber
                              ? 10 * maxH / 43.807
                              : 9 * maxH / 43.807,
                          fontWeight: selectedpage == pagenumber
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BottomNavigationBar extends StatelessWidget {
  final Function changeselected;
  final int s;
  const BottomNavigationBar({
    Key key,
    this.s,
    this.changeselected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print("Bottom navigation ");
        print("height is ${constraints.maxHeight}");
        print("width is ${constraints.maxWidth}");
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => this.changeselected(0),
                child: Column(
                  children: [
                    Container(
                      width: 0.2 * constraints.maxWidth,
                      // padding: EdgeInsets.only(bottom: 1 * max / 44.1425),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      this.s == 0 ? Colors.blue : Colors.white,
                                  width: 0.01 * constraints.maxWidth))),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Menu",
                          style: TextStyle(
                              color: this.s == 0 ? Colors.black : Colors.grey,
                              fontSize: 0.4 * constraints.maxHeight,
                              fontWeight: this.s == 0
                                  ? FontWeight.bold
                                  : FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => this.changeselected(1),
                child: Column(
                  children: [
                    Container(
                      width: 0.2 * constraints.maxWidth,
                      // padding: EdgeInsets.only(bottom: 1 * max / 44.1425),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      this.s == 1 ? Colors.blue : Colors.white,
                                  width: 0.01 * constraints.maxWidth))),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Order",
                          style: TextStyle(
                              color: this.s == 1 ? Colors.black : Colors.grey,
                              fontSize: 0.4 * constraints.maxHeight,
                              fontWeight: this.s == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => this.changeselected(2),
                child: Column(
                  children: [
                    Container(
                      width: 0.2 * constraints.maxWidth,
                      // padding: EdgeInsets.only(bottom: 1 * max / 44.1425),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      this.s == 2 ? Colors.blue : Colors.white,
                                  width: 0.01 * constraints.maxWidth))),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Pay-In",
                          style: TextStyle(
                              color: this.s == 2 ? Colors.black : Colors.grey,
                              fontSize: 0.4 * constraints.maxHeight,
                              fontWeight: this.s == 2
                                  ? FontWeight.bold
                                  : FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => this.changeselected(3),
                child: Column(
                  children: [
                    Container(
                      width: 0.2 * constraints.maxWidth,
                      // padding: EdgeInsets.only(bottom: 1 * max / 44.1425),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:
                                      this.s == 3 ? Colors.blue : Colors.white,
                                  width: 0.01 * constraints.maxWidth))),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              color: this.s == 3 ? Colors.black : Colors.grey,
                              fontSize: 0.4 * constraints.maxHeight,
                              fontWeight: this.s == 3
                                  ? FontWeight.bold
                                  : FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
