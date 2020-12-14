import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import 'package:flip_app/services.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:async';

class GameDashboard extends StatefulWidget {
  @override
  _GameDashboardState createState() => _GameDashboardState();
}

class _GameDashboardState extends State<GameDashboard> {
  List keys = new List();
  var rng = new Random();
  var randomColors = new Map();

  static int MAX_FLIP = 2;
  Mode selectedMode;
  Category selectedCategory;
  bool inGame = false;
  AppService _service = new AppService();
  List<Category> categories;
  List<CategoryItem> categoryItems;
  List<Mode> modes;
  bool loaded = false;
  String options = 'mode';
  List<CategoryItem> categoryItemsUsed;
  static int currentFlipped = 0;
  List<CategoryItem> currentFlippedCards = new List<CategoryItem>();
  int _start = 10;
  int matchedCards = 0;

  void initState() {
    super.initState();
    setState(() {
      _service.getCategoryList().then((value) {
        this.categories = value;
        this.selectedCategory = categories[0];
      });
      _service.getModeList().then((value) {
        this.modes = value;
        this.selectedMode = modes[0];
      }).whenComplete(() {
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            this.loaded = true;
          });
        });
      });
    });
  }

  _renderFlatButton(context, color, background, text, fontSize, route) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: background,
      ),
      child: FlatButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          '$text',
          style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize)),
        ),
      ),
    );
  }

  void _matchCard(context) {
    Future.delayed(new Duration(milliseconds: 500), () {
      setState(() {
        if (currentFlippedCards[0].id == currentFlippedCards[1].id) {
          for (CategoryItem c in categoryItemsUsed) {
            if (c.id == currentFlippedCards[0].id) {
              matchedCards += 1;
              c.flipped = true;
              if (matchedCards == selectedMode.count) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Center(
                          child: Text(
                            "Congrats !",
                            style: GoogleFonts.kaushanScript(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 40,
                                  letterSpacing: 2.5),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.grey[300],
                        content: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${selectedMode.name} Mode was piece of cake ? \nTry another mode now !',
                                style: GoogleFonts.kaushanScript(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 26)),
                              ),
                              _renderFlatButton(
                                  context,
                                  Colors.white,
                                  Colors.blueAccent,
                                  'Play again',
                                  28.0,
                                  '/game'),
                              _renderFlatButton(context, Colors.white,
                                  Colors.blueAccent, 'Go to menu', 28.0, '/'),
                            ],
                          ),
                        )));
              }
            }
          }
        }
      });
      currentFlippedCards = new List<CategoryItem>();
    });
    _resetAll(1000);
  }

  void _startTimer() {
    Timer _timer;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  _showAll() {
    keys.forEach((element) => element.currentState.toggleCard());
    currentFlipped = 10;
  }

  _resetAll(int time) {
    Future.delayed(new Duration(milliseconds: time.toInt()), () {
      keys.forEach((element) => element.currentState.resetCard());
      currentFlipped = 0;
    });
  }

  _renderContent(context, index) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(10),
      color: Color(0x00000000),
      child: FlipCard(
        key: keys[index],
        direction: FlipDirection.HORIZONTAL,
        speed: 500,
        flipOnTouch: false,
        onFlipDone: (status) {
          print(status);
        },
        front: Container(
          decoration: BoxDecoration(
            color: categoryItemsUsed[index].flipped
                ? Colors.greenAccent
                : Colors.grey[600],
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: categoryItemsUsed[index].flipped
              ? Column()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Center(
                        child: Icon(
                          categoryItemsUsed[index].flipped
                              ? Icons.check_box
                              : FontAwesome.question,
                          size: selectedMode.size,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (currentFlipped < 2 &&
                            categoryItemsUsed[index].flipped == false) {
                          currentFlipped += 1;
                          currentFlippedCards.add(categoryItemsUsed[index]);
                          print(currentFlippedCards);
                          keys[index].currentState.toggleCard();
                          if (currentFlipped == 2) {
                            _matchCard(context);
                          }
                        }
                      },
                    )
                  ],
                ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: randomColors['${categoryItemsUsed[index].id}'],
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SvgPicture.network(
                categoryItemsUsed[index].image,
                color: Colors.white,
                height: selectedMode.size,
                width: selectedMode.size,
              )
            ],
          ),
        ),
      ),
    );
  }

  _initKeys() {
    for (int i = 0; i < selectedMode.count; i++) {
      keys.add(GlobalKey<FlipCardState>());
    }
  }

  _setMode(name) {
    setState(() {
      this.selectedMode = this.modes.where((i) => i.name == name).toList()[0];
      MAX_FLIP = this.selectedMode.max_flip;
    });
  }

  _setCategory(name) {
    setState(() {
      this.selectedCategory =
          this.categories.where((i) => i.name == name).toList()[0];
    });
  }

  _startGame() {
    setState(() {
      inGame = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _showAll();
        _startTimer();
        _resetAll(10000);
      });
    });
  }

  _renderRaisedButton(context, color, background, text, fontSize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: text == selectedMode.name
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.8),
                  spreadRadius: 6,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
        color: background,
      ),
      child: FlatButton(
        onPressed: () {
          text == 'Play !' ? _startGame() : _setMode(text);
        },
        child: Text(
          '$text',
          style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize)),
        ),
      ),
    );
  }

  _renderRaisedButtonCategory(context, color, background, text, fontSize) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: text == selectedCategory.name
            ? [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.8),
                  spreadRadius: 6,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
        color: background,
      ),
      child: FlatButton(
        onPressed: () {
          _setCategory(text);
        },
        child: Text(
          '$text',
          style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize)),
        ),
      ),
    );
  }

  _createListImages(l1) {
    this.categoryItemsUsed = l1 + l1;
    for (CategoryItem c in l1) {
      randomColors['${c.id}'] = accents[rng.nextInt(accents.length)];
    }
    this.categoryItemsUsed.shuffle();
  }

  _categoryAndModeSelection(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          options == 'mode' ? 'Choose Mode' : 'Choose Category',
          style: GoogleFonts.kaushanScript(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 34)),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: this.options == 'mode'
            ? Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            : Icon(
                Icons.videogame_asset,
                color: Colors.white,
              ),
        backgroundColor: Colors.green,
        onPressed: () {
          if (this.options == 'mode') {
            _initKeys();
            setState(() {
              this.options = 'category';
            });
          } else {
            _service.getCategoryItemList(selectedCategory.id).then((value) {
              this.categoryItems = value;
              _createListImages(
                  categoryItems.sublist(0, selectedMode.count ~/ 2));
            }).whenComplete(() => _startGame());
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              this.options == 'mode'
                  ? SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: modes
                              .map((mode) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 12.0),
                                    child: _renderRaisedButton(
                                        context,
                                        Colors.white,
                                        COLORS[mode.color],
                                        mode.name,
                                        30.0),
                                  ))
                              .toList()),
                    )
                  : SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: categories
                              .map(
                                (category) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 12.0),
                                  child: _renderRaisedButtonCategory(
                                      context,
                                      Colors.white,
                                      Colors.blueAccent,
                                      category.name,
                                      30.0),
                                ),
                              )
                              .toList()),
                    ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Scaffold(
            appBar: inGame && _start <= 0
                ? AppBar(
                    toolbarHeight: 45,
                    leading: IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/'),
                      icon: Icon(Icons.arrow_back),
                    ),
                    title: Text(
                      'Flippo',
                      style: GoogleFonts.kaushanScript(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 34)),
                    ),
                    centerTitle: true,
                  )
                : null,
            body: inGame
                ? Container(
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                    decoration: BoxDecoration(color: Colors.grey[400]),
                    child: Column(
                      children: <Widget>[
                        _start <= 0
                            ? Container()
                            : Expanded(
                                flex: MediaQuery.of(context).orientation ==
                                    Orientation.landscape? 2 :1,
                                child: Container(
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '$_start',
                                      style: GoogleFonts.kaushanScript(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30)),
                                    ),
                                  ),
                                ),
                              ),
                        Expanded(
                          flex: 10,
                          child: GridView.count(
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? selectedMode.horizontalState
                                    : selectedMode.verticalState,
                            children:
                                List.generate(selectedMode.count, (index) {
                              return Center(
                                child: _renderContent(context, index),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  )
                : _categoryAndModeSelection(context),
          )
        : Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/loading.gif',
                    ),
                    fit: BoxFit.fitHeight),
              ),
            ),
          );
  }
}
