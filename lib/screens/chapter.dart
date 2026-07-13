import 'package:bible_chichewa/bible_chichewa.dart';
import 'package:chichewa_bible/classes/comment.dart';
import 'package:chichewa_bible/classes/highlight.dart';
import 'package:chichewa_bible/classes/verse.dart';
import 'package:chichewa_bible/controllers/bible.dart';
import 'package:chichewa_bible/controllers/comments.dart';
import 'package:chichewa_bible/controllers/highlights.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';

class ScreenChapter extends StatefulWidget {
  const ScreenChapter({super.key});

  @override
  State<ScreenChapter> createState() => _ScreenChapterState();
}

class _ScreenChapterState extends State<ScreenChapter> {
  final _controllerBible = Get.find<BibleController>();
  final _controllerComments = Get.find<CommentController>();
  final _controllerHighlights = Get.find<HighlightController>();

  final _txtCommentTitle = TextEditingController();
  final _verseEnd = TextEditingController();
  final _txtCommentDescription = TextEditingController();
  var _highlights = <Highlight>[];
  List<Verse> _verses = [];

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
  }

  @override
  void dispose() {
    _txtCommentTitle.dispose();
    _verseEnd.dispose();
    _txtCommentDescription.dispose();
    super.dispose();
  }

  void _onShare(int b, int chapter, int v, String verse) {
    var book = _controllerBible.bible.value.getBooks()[b];
    var reference = "$book $chapter: ${v + 1}";
    var id = "com.m2kdevelopments.biblechichewa";
    var app = "https://play.google.com/store/apps/details?id=$id";
    var subject = "Chichewa Bible - Mawu a Mulungu";
    SharePlus.instance.share(
      ShareParams(text: '$verse\n--$reference\n\n$app', subject: subject),
    );
  }

  void _onSettings() => Navigator.pushNamed(context, "/settings");

  void _onPreviousChapter(int book, int chapter) {
    if ((chapter - 1) < 1) {
      // next book
      if (book != BOOK.revelation.index) {
        Navigator.popAndPushNamed(
          context,
          "/chapter",
          arguments: [book + 1, 1],
        );
      }
    } else {
      //chapter
      Navigator.popAndPushNamed(
        context,
        "/chapter",
        arguments: [book, chapter - 1],
      );
    }
  }

  void _onNextChapter(int book, int chapter) {
    var count = _controllerBible.bible.value.getChapterCount(BOOK.values[book]);
    if ((chapter + 1) > count) {
      // next book
      if (book != BOOK.revelation.index) {
        Navigator.popAndPushNamed(
          context,
          "/chapter",
          arguments: [book + 1, 1],
        );
      }
    } else {
      //chapter
      Navigator.popAndPushNamed(
        context,
        "/chapter",
        arguments: [book, chapter + 1],
      );
    }
  }

  void _addComment(int book, int chapter, Comment? exists) {
    var title = _txtCommentTitle.text;
    var text = _txtCommentDescription.text;
    var id = exists == null ? DateTime.now().millisecondsSinceEpoch : exists.id;
    var comment = Comment(
      id: id,
      book: book,
      chapter: chapter,
      title: title,
      comment: text,
    );
    if (exists == null) {
      _controllerComments.insertComment(comment);
    } else {
      _controllerComments.updateComment(id, comment);
    }
    Toast.show("Ndemanga idawonjezedwa");
  }

  void _onComment(int book, int chapter) {
    var comments = _controllerComments.getComments(book, chapter);
    Comment? comment;
    if (comments.isNotEmpty) {
      comment = comments[0];
      _txtCommentTitle.text = comment.title;
      _txtCommentDescription.text = comment.comment;
    }

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text(
          "Ndemanga (Comment)",
          style: TextStyle(fontSize: 16, color: Colors.brown),
        ),
        content: SizedBox(
          width: 800,
          // height: 400,
          child: Column(
            children: [
              Text("${_controllerBible.bible.value.getBooks()[book]} $chapter"),
              TextFormField(
                maxLength: 300,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Mutu wa Ndemanga",
                  labelText: "Mutu wa Ndemanga",
                ),
                controller: _txtCommentTitle,
              ),
              TextFormField(
                minLines: 1,
                maxLines: 10,
                maxLength: 5000,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ndemanga",
                  labelText: "Ndemanga",
                ),
                controller: _txtCommentDescription,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.brown),
                title: const Text(
                  "Onjezani",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Onjezani Ndemanga"),
                onTap: () {
                  _addComment(book, chapter, comment);
                  Navigator.pop(c);
                },
              ),
              comment != null
                  ? ListTile(
                      leading: const Icon(Icons.delete, color: Colors.brown),
                      title: const Text(
                        "Chotsa",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("Chotsa Ndemanga"),
                      onTap: () {
                        _controllerComments.deleteComment(comment!.id);
                        Navigator.pop(c);
                        Toast.show("Ndemanga ya chotsedwa!");
                        _txtCommentTitle.text = "";
                        _txtCommentDescription.text = "";
                      },
                    )
                  : const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  void _addHighlight(int b, int c, int v, String color) async {
    var existingHighlight = _controllerHighlights.getHighlight(b, c, v);

    if (existingHighlight == null) {
      _controllerHighlights.insertHighlight(
        Highlight(
          id: DateTime.now().millisecondsSinceEpoch,
          book: b,
          chapter: c,
          verse: v,
          start: 0,
          end: 0,
          color: color,
        ),
      );
    } else {
      _controllerHighlights.updateHighlight(
        existingHighlight.id,
        Highlight(
          id: existingHighlight.id,
          book: b,
          chapter: c,
          verse: v,
          start: -1,
          end: -1,
          color: color,
        ),
      );
    }
    setState(() {
      _highlights = _controllerHighlights.getHighlights(b, c);
    });
    Toast.show('Highlighted');
  }

  void _deleteHighlight(int b, int c, int v) async {
    _controllerHighlights.removeHighlight(b, c, v);
    setState(() {
      _highlights = _controllerHighlights.getHighlights(b, c);
    });
    Toast.show('Highlight Removed');
  }

  void _onHighlight(int b, int chapter, int v) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(
          "Highlight Verse $v",
          style: TextStyle(fontSize: 16, color: Colors.brown[900]),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: "Remove Highlight",
              icon: const Icon(Icons.block, color: Colors.red),
              onPressed: () => _deleteHighlight(b, chapter, v),
            ),
            IconButton(
              tooltip: "Blue Highlight",
              icon: const Icon(Icons.circle, color: Colors.blue),
              onPressed: () {
                _addHighlight(b, chapter, v, 'blue');
                Navigator.pop(c);
              },
            ),
            IconButton(
              tooltip: "Orange Highlight",
              icon: const Icon(Icons.circle, color: Colors.orange),
              onPressed: () {
                _addHighlight(b, chapter, v, 'orange');
                Navigator.pop(c);
              },
            ),
            IconButton(
              tooltip: "Green Highlight",
              icon: const Icon(Icons.circle, color: Colors.green),
              onPressed: () {
                _addHighlight(b, chapter, v, 'green');
                Navigator.pop(c);
              },
            ),
            IconButton(
              tooltip: "Purple Highlight",
              icon: const Icon(Icons.circle, color: Colors.purple),
              onPressed: () {
                _addHighlight(b, chapter, v, 'purple');
                Navigator.pop(c);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color? _getVerseHighlight(Verse verse) {
    var h = _highlights.firstWhereOrNull((r) => r.verse == verse.verse);
    if (h == null) return null;
    if (_controllerBible.lightMode.value) {
      if (h.color == 'blue') return Colors.blue[50];
      if (h.color == 'green') return Colors.green[50];
      if (h.color == 'orange') return Colors.orange[50];
      if (h.color == 'purple') return Colors.purple[50];
    } else {
      if (h.color == 'blue') return Colors.blue[900];
      if (h.color == 'green') return Colors.green[900];
      if (h.color == 'orange') return Colors.orange[900];
      if (h.color == 'purple') return Colors.purple[900];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List<int>;
    final book = data[0];
    final chapter = data[1] + 1;
    _controllerBible.bible.value.getChapter(BOOK.values[book], chapter).then((
      verses,
    ) {
      setState(() {
        List<Verse> list = [];
        for (var i = 0; i < verses.length; i++) {
          list.add(
            Verse(
              book: _controllerBible.bible.value.getBooks()[book],
              chapter: chapter,
              verse: i + 1,
              text: verses[i],
            ),
          );
        }
        _verses = list;
      });
    });

    if (_verses.isEmpty) {
      setState(() {
        _highlights = _controllerHighlights.getHighlights(book, chapter);
      });
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "${_controllerBible.bible.value.getBooks()[book]} $chapter",
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 8.0,
          backgroundColor: Colors.brown,
          actions: [
            IconButton(
              onPressed: () => _controllerBible.toggleLightMode(),
              icon: const Icon(Icons.contrast, color: Colors.white, size: 20),
            ),
            IconButton(
              onPressed: _onSettings,
              icon: const Icon(Icons.settings, color: Colors.white, size: 20),
            ),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! < 0) {
                _onNextChapter(book, chapter - 1);
              } else {
                _onPreviousChapter(book, chapter - 1);
              }
            },
            child: Container(
              color: _controllerBible.lightMode.value
                  ? Colors.white
                  : Colors.black87,
              child: ListView.builder(
                itemCount: _verses.length,
                itemBuilder: (context, index) {
                  var verse = _verses[index];
                  return ListTile(
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context, 
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        // Critical for preventing content from overflowing and hiding the rounded corners
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        builder: (context) => Container(
                          color: _controllerBible.lightMode.value
                              ? Colors.white
                              : Colors.black87,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Zochita",
                                  style: TextStyle(
                                    color: _controllerBible.lightMode.value
                                        ? Colors.brown.shade800
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  "What do you want to do?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(
                                  8.0,
                                  3.0,
                                  8.0,
                                  3.0,
                                ),
                                child: Divider(),
                              ),
                              ListTile(
                                onTap: () => _onShare(
                                  book,
                                  chapter,
                                  verse.verse,
                                  verse.text,
                                ),
                                leading: Icon(
                                  Icons.share,
                                  color: _controllerBible.lightMode.value
                                      ? Colors.brown
                                      : Colors.brown[300],
                                ),
                                title: Text(
                                  "Gawa Mau",
                                  style: TextStyle(
                                    color: _controllerBible.lightMode.value
                                        ? Colors.brown.shade800
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  "Share Verse",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              ListTile(
                                onTap: () =>
                                    _onHighlight(book, chapter, verse.verse),
                                leading: Icon(
                                  Icons.color_lens_rounded,
                                  color: _controllerBible.lightMode.value
                                      ? Colors.brown
                                      : Colors.brown[300],
                                ),
                                title: Text(
                                  "Highlight",
                                  style: TextStyle(
                                    color: _controllerBible.lightMode.value
                                        ? Colors.brown.shade800
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  "Highlight verse",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              ListTile(
                                onTap: () => _onComment(book, chapter),
                                leading: Icon(
                                  Icons.edit_document,
                                  color: _controllerBible.lightMode.value
                                      ? Colors.brown
                                      : Colors.brown[300],
                                ),
                                title: Text(
                                  "Ndemanga",
                                  style: TextStyle(
                                    color: _controllerBible.lightMode.value
                                        ? Colors.brown.shade800
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  "Write a comment",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    leading: Text(
                      verse.verse.toString(),
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: _controllerBible.lightMode.value
                            ? Colors.brown
                            : Colors.brown[300],
                      ),
                    ),
                    title: Column(
                      children: [
                        SelectableText(
                          verse.text,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            backgroundColor: _getVerseHighlight(verse),
                            fontSize: _controllerBible.fontSize.value,
                            color: _controllerBible.lightMode.value
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                   
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
