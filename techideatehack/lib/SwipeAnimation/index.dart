import 'dart:async';
import 'package:techideatehack/SwipeAnimation/data.dart';
import 'package:techideatehack/SwipeAnimation/dummyCard.dart';
import 'package:techideatehack/SwipeAnimation/activeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class CardDemo extends StatefulWidget {
  @override
  CardDemoState createState() => new CardDemoState();
}

class CardDemoState extends State<CardDemo> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  List data = imageData;
  List dataQ= QData;
  List dataA= AData;
  List selectedData = [];
  void initState() {
    super.initState();

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = dataQ.removeLast();
          dataQ.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  /*dismissImg(DecorationImage img) {
    setState(() {
      data.remove(img);
    });
  }*/

  dismissQ(Text Q) {
    setState(() {
      dataQ.remove(Q);
    });
  }


  /*addImg(DecorationImage img) {
    setState(() {
      data.remove(img);
      selectedData.add(img);
    });
  }*/

  addQ(Text Q) {
    setState(() {
      dataQ.remove(Q);
      selectedData.add(Q);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    double initialBottom = 15.0;
    var dataQLength = dataQ.length;
    double backCardPosition = initialBottom + (dataQLength - 1) * 10 + 10;
    double backCardWidth = -10.0;
    return (new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: new Color.fromRGBO(106, 94, 175, 1.0),
          centerTitle: true,

          /*leading: new Container(
            margin: const EdgeInsets.all(15.0),
            child: new Icon(
              Icons.equalizer,
              color: Colors.cyan,
              size: 30.0,
            ),
          ),*/
          /*actions: <Widget>[
            new GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => new PageMain()));
              },
              child: new Container(
                  margin: const EdgeInsets.all(15.0),
                  child: new Icon(
                    Icons.search,
                    color: Colors.cyan,
                    size: 30.0,
                  )),
            ),
          ],*/
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Recent Question",
                style: new TextStyle(
                    fontSize: 25.0,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.bold),
              ),
              new Container(
                width: 15.0,
                height: 15.0,
                margin: new EdgeInsets.only(bottom: 20.0),
                alignment: Alignment.center,
                child: new Text(
                  dataQLength.toString(),
                  style: new TextStyle(fontSize: 10.0),
                ),
                decoration: new BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
              )
            ],
          ),
        ),
        body: new Container(
          color: new Color.fromRGBO(106, 94, 175, 1.0),
          alignment: Alignment.center,
          child: dataQLength > 0
              ? new Stack(
                  alignment: AlignmentDirectional.center,
                  children: dataQ.map((question) {
                    if (dataQ.indexOf(question) == dataQLength - 1) {
                      return cardDemo(
                          question,
                          bottom.value,
                          right.value,
                          0.0,
                          backCardWidth + 10,
                          rotate.value,
                          rotate.value < -10 ? 0.1 : 0.0,
                          context,
                          dismissQ,
                          flag,
                          addQ,
                          swipeRight,
                          swipeLeft);
                    } else {
                      backCardPosition = backCardPosition - 10;
                      backCardWidth = backCardWidth + 10;

                      return cardDemoDummy(
                          Text(
                              QData[0],style: TextStyle(fontSize: 30.0),
                          )
                          ,backCardPosition, 0.0, 0.0,
                          backCardWidth, 0.0, 0.0, context);
                      
                    }
                  }).toList())
              : new Text("No Event Left",
                  style: new TextStyle(color: Colors.white, fontSize: 50.0)),
        )));
  }
}
