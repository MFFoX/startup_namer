// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:english_words/english_words.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recase/recase.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          // Add the 3 lines from here...
          primaryColor: Color.fromRGBO(109, 126, 255, 1),
        ),
        home: Scaffold(body: InitialScreen())
        //home: RandomWords(),
        );
  }
}

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _h1Style = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 34,
      height: 1.4,
      color: Colors.white,
    );
    final _pStyle = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 16,
      height: 1.4,
      letterSpacing: 0.5,
      color: Colors.white,
    );

    return Container(
        color: Color.fromRGBO(21, 21, 34, 1),
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 80),
                child: SvgPicture.asset('graphics/logo.svg',
                    semanticsLabel: 'Logo')),
            Container(
                padding: const EdgeInsets.only(top: 59, left: 70, right: 70),
                child: Center(
                    child: Text("Get paid to give referrals",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(textStyle: _h1Style)))),
            Container(
                padding: const EdgeInsets.only(top: 18, left: 42, right: 42),
                child: Center(
                    child: Text(
                        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(textStyle: _pStyle)))),
            Container(
                padding: const EdgeInsets.only(top: 22, left: 160, right: 160),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8)
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.circle, color: Color.fromRGBO(109, 126, 255, 1), size: 8)
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8)
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8)
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8)
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8)
                        ],
                      ),
                    ])),
            Row(children: [
              Expanded(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 87, bottom: 10.0),
                        child: SvgPicture.asset('graphics/device-white.svg',
                            semanticsLabel: 'device'))),
              )
            ]),
          ],
        ));
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _headerFont = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase.titleCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.black38 : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = <ListTile>[];
          // for the first list item, show a count of how many have been added
          if (_saved.length > 0) {
            tiles.add(new ListTile(
                title: Center(
                    child: Text(
              "You have saved ${_saved.length} startup names",
              style: _headerFont,
              textAlign: TextAlign.center,
            ))));
          }

          //now add all the favorites
          tiles.addAll(_saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase.titleCase,
                  style: _biggerFont,
                ),
              );
            },
          ));

          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          final savedList = ListView(children: divided);

          final noneSavedText = Center(
            child: Text(
              'You haven\'t saved anything yet!',
              textAlign: TextAlign.center,
              style: _biggerFont,
            ),
          );

          return Scaffold(
              appBar: AppBar(
                  title: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
                Text(" Saved Suggestions")
              ])),
              body: _saved.length > 0 ? savedList : noneSavedText);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
              icon: Icon(Icons.format_list_bulleted), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
