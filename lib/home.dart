import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:dictionary/utils/string_extensions.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:dictionary/word.dart';
import 'package:dictionary/word_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final myController = TextEditingController();

  List<String> recentSearches = ['quixotic', 'esoteric', 'godspeed', 'numinous', 'loquacious'];

  @override
  void initState() { 
    super.initState();
    
    myController.addListener(() { 
      //_printLatestValue();
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.20),
            Text("Dictionary",
                style: GoogleFonts.playfairDisplay(
                    textStyle: TextStyle(
                        fontSize: 55.0, fontWeight: FontWeight.w900))),
            SizedBox(height: 20.0),
            getSearchInputField(context),
            SizedBox(height: 25.0),
            Text("Recent",
                style: GoogleFonts.playfairDisplay(
                    textStyle: TextStyle(
                        fontSize: 35.0, fontWeight: FontWeight.w900))),
            Expanded(
              child: getRecentSearches(context),
            ),
          ],
        ),
      ),
    ));
  }

  Future<http.Response> fetchWordOxford(String word) async {
    final uri = Uri.parse(
      'https://od-api.oxforddictionaries.com/api/v2/entries/en-gb/${word.toLowerCase()}?fields=definitions,pronunciations,etymologies&strictMatch=false'
    );

    return http.get(
      uri,
      headers: {
        "app_id": "b0023b98",
        "app_key":"2859882c111a2ae297987395f32ce2be",
      }
    );
  }

  void searchTerm(BuildContext context, String word) async {

    if (word == null || word == "") {
      return;
    }

    addWordToRecentSearches(word);

    setState(() {
      myController.text == "";
    });

    final response = await fetchWordOxford(word);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response.
      // parse the JSON
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WordDetail(wordModel: Word.fromJson(jsonDecode(response.body)))),
      );
    } else {
      // TODO: Show snackbar for not found word
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${word} not found")));
    }
  }

  void addWordToRecentSearches(String word) {
    setState(() {
        if (recentSearches.length == 5) {
          recentSearches.removeLast();
        }
        recentSearches.insert(0, word);
    });
    
  }

  Widget getRecentSearches(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      itemCount: recentSearches.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            searchTerm(context, recentSearches[index]);
          },
          child: Text("${recentSearches[index].capitalize()}", style: GoogleFonts.prompt(textStyle: TextStyle(fontSize: 24.0, height: 1.5, fontWeight: FontWeight.w300)),),
        );
      },
    );
  }

  Widget getSearchInputField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(234, 234, 234, 1),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none
        ),
        hintText: 'search here',
        hintStyle: TextStyle(color: Color.fromRGBO(193, 193, 193, 1), fontSize: 18.0)
      ),
      controller: myController,
      onEditingComplete: () {
        searchTerm(context, myController.text);
      },
    );
  }

  void _printLatestValue() => (myController.text.length > 0)? print('Text field value: ${myController.text}') : null;
}