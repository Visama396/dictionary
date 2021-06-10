import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import 'package:dictionary/utils/string_extensions.dart';

import 'package:dictionary/word_model.dart';

class WordDetail extends StatefulWidget {
  final Word wordModel;


  const WordDetail({Key? key, 
    required this.wordModel,
  }) : super(key: key);

  @override
  _WordDetailState createState() => _WordDetailState();
}

class _WordDetailState extends State<WordDetail> {
  int activeEntry = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          color: Color.fromRGBO(246, 246, 246, 1),
          padding: EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                backButton(context),
                SizedBox(height: 20.0), 
                showWord(),
                showPhonetics(),
                SizedBox(height: 30.0),
                showEntries(),
                SizedBox(height: 30.0),
                showEtymology(),
              ],
            ),
          )),
    );
  }

  Widget backButton(BuildContext context) {
    return TextButton(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
            size: 30.0,
          ),
          Text(
            "Search",
            style: TextStyle(
                color: Colors.blue, fontSize: 18.0),
          )
        ],
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget showWord() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Text("${widget.wordModel.word}",
          style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(65, 64, 69, 1)))),
    );
  }

  Widget showPhonetics() {
    if (widget.wordModel.pronunciation == '') return Container();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () async {
          final player = AudioPlayer();
          await player.setUrl("${widget.wordModel.audioFile}");
          await player.play();
          //await player.dispose();
        },
        child: Row(
          children: <Widget>[
            Text("/${widget.wordModel.pronunciation}/",
                style: TextStyle(
                    fontSize: 26.0,
                    color: Colors.blue)
            ),
            Icon(Icons.volume_up_rounded, color: Colors.blue)
          ],
        ),
      ),
    );
  }

  Widget getEntryButton(String lexicalCategory, int index, ) {

    final firstButtonRadius = BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0));
    final lastButtonRadius = BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0));

    return TextButton(
      onPressed: null,
      child: Text(lexicalCategory, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 15.0)),
        side: MaterialStateProperty.all<BorderSide>(BorderSide(width: 2.0, color: Colors.blue)),
        backgroundColor: MaterialStateProperty.all<Color>((index == 1)? Colors.blue : Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>((index == 1)? Colors.white : Colors.blue),
        shape: (1 == widget.wordModel.lexicalEntries.length)? 
        MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: firstButtonRadius + lastButtonRadius  // It's the only button
          )
        ) : (index == 1)? 
        MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: firstButtonRadius // If it's the first button
          )
        ) : (index == widget.wordModel.lexicalEntries.length)? 
        MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: lastButtonRadius  // If it's the last button
          )
        ) : 
        MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder() // If it's a button in between
        ),
      )
    );
  }

  Widget showEntries() {

    List<Widget> lexicalEntries = [];
    int index = 1;
    for (dynamic item in widget.wordModel.lexicalEntries) {
      // The first entry is the active one, so it has a different styling
      lexicalEntries.add(getEntryButton(item['lexicalCategory']['id'], index));
      index++;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: lexicalEntries
          ),
          SizedBox(height: 30.0,),
          Row(
            children: <Widget>[
              Text("DEFINITIONS", style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(65, 64, 69, 1)
                )
              ),
              SizedBox(width: 5.0),
              (widget.wordModel.lexicalEntries[0]['entries'][0]['senses'][0]['subsenses'] != null)?
                Text("${widget.wordModel.lexicalEntries[0]['entries'][0]['senses'][0]['subsenses'].length}", style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(163, 163, 163, 1)
                )
              ) : Text("1", style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(163, 163, 163, 1)
                )
              )
            ],
          ),
          SizedBox(height: 10.0),
          showDefinition(widget.wordModel.lexicalEntries[0]['entries'][0]['senses'][0]['definitions'][0]),
          (widget.wordModel.lexicalEntries[0]['entries'][0]['senses'][0]['subsenses'] != null)?
          showSubdefinition() : Container()
        ],
      )
    );
  }

  Widget showDefinition(String definition) {
    return Container(
      child: RichText(
        text: TextSpan(
          text: '1. ',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 18.0),
          children: <TextSpan>[
            TextSpan(text: definition.capitalize(), style: TextStyle(
              color: Color.fromRGBO(65, 64, 69, 1),
              fontWeight: FontWeight.normal
              )
            )
          ]
        )
      ),
    );
  }

  Widget showSubdefinition() {
    return Container(
      child: Text("...", style: TextStyle(fontSize: 18.0, color: Colors.blue),),
    );
  }

  Widget showEtymology() {
    if (widget.wordModel.etymology == '') return Container();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("ETYMOLOGY", style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(65, 64, 69, 1)
          )),
          SizedBox(height: 15.0),
          Text("${widget.wordModel.etymology.capitalize()}", style: TextStyle(
            fontSize: 18.0,
            color: Color.fromRGBO(65, 64, 69, 1)
          ))
        ],
      ),
    );
  }
}
