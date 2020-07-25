// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:recase/recase.dart';

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
      home: RandomWords(),
    );
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
                title: Text('❤ Saved Suggestions'),
              ),
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
