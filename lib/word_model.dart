class Word {
  final String word;
  final String pronunciation;
  final String audioFile;
  final String etymology;
  final List<dynamic> lexicalEntries;

  Word({
    required this.word,
    required this.pronunciation,
    required this.audioFile,
    required this.etymology,
    required this.lexicalEntries
  });

  factory Word.fromJson(Map<String, dynamic> json) {

    //print(json['results'][0]['lexicalEntries'][0]['entries'][0]['pronunciations'][0]['phoneticSpelling']);

    List<dynamic> entries = [];

    for (dynamic item in json['results'][0]['lexicalEntries']) {
      entries.add(item);
    }

    return Word(
      word: json['word'],
      pronunciation: (json['results'][0]['lexicalEntries'][0]['entries'][0]['pronunciations'] != null)? json['results'][0]['lexicalEntries'][0]['entries'][0]['pronunciations'][0]['phoneticSpelling'] : '',
      audioFile: (json['results'][0]['lexicalEntries'][0]['entries'][0]['pronunciations'] != null)? json['results'][0]['lexicalEntries'][0]['entries'][0]['pronunciations'][0]['audioFile'] : '',
      etymology: (json['results'][0]['lexicalEntries'][0]['entries'][0]['etymologies'] != null)? json['results'][0]['lexicalEntries'][0]['entries'][0]['etymologies'][0] : '',
      lexicalEntries: entries
    );
  }
}