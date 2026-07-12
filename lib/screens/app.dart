import 'package:bible_chichewa/bible_chichewa.dart';
import 'package:chichewa_bible/components/dialbutton.dart';
import 'package:chichewa_bible/controllers/bible.dart';
import 'package:chichewa_bible/controllers/comments.dart';
import 'package:chichewa_bible/controllers/highlights.dart';
import 'package:chichewa_bible/services/database.dart';
import 'package:chichewa_bible/widget/searchmenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_version_plus/new_version_plus.dart';

class ScreenApp extends StatefulWidget {
  const ScreenApp({Key? key}) : super(key: key);

  @override
  State<ScreenApp> createState() => _ScreenAppState();
}

class _ScreenAppState extends State<ScreenApp> {
  final _controllerBible = Get.put(BibleController());
  final _controllerComments = Get.put(CommentController());
  final _controllerHighlights = Get.put(HighlightController());

  Map<int, int?> _mapHighlights = {};
  Map<int, int?> _mapComments = {};
  // Map<int, int> _highlights = {};

  var _loading = true;

  // Bible configuration
  var book = BOOK.genesis;
  var _chapterNumber = 0;

  @override
  void initState() {
    super.initState();

    _controllerBible.loadSettings();
    var db = loadLocalDB();
    _controllerHighlights.load(db);
    _controllerComments.load(db);

    setState(() {
      _mapComments = _controllerComments.getBibleCommentCount();
      _mapHighlights = _controllerHighlights.getBibleHighlightCount();
    });

    // Instantiate NewVersion manager object (Using GCP Console app as example)
    try {
      final newVersion = NewVersionPlus(
        //iOSId: 'com.m2kdevelopments.biblechichewa',
        androidId: 'com.m2kdevelopments.biblechichewa',
      );
      newVersion.showAlertIfNecessary(context: context);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    _controllerBible.load().then((value) => setState(() => _loading = false));
  }

  void _onChapter(int book, int chapter) {
    if (chapter > 0) {
      Navigator.pushNamed(context, "/chapter", arguments: [book, chapter - 1]);
    }
  }

  void _onBook(int bookIndex) {
    setState(() {
      _chapterNumber = 0;
    });
    var maxChapters =
        _controllerBible.bible.value.getChapterCount(BOOK.values[bookIndex]);
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateF) {
            return Obx(() => Container(
                  color: _controllerBible.lightMode.value
                      ? Colors.grey.shade50
                      : Colors.black87,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setStateF(() {
                                  _chapterNumber = 0;
                                });
                              },
                            ),
                            title: Text(
                              _controllerBible.bible.value
                                  .getBooks()[bookIndex],
                              style: TextStyle(
                                color: _controllerBible.lightMode.value
                                    ? Colors.grey
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: _controllerBible.fontSize.value,
                              ),
                            ),
                            subtitle: Text(
                              "${maxChapters.toString()} Chapters",
                              style: TextStyle(
                                color: _controllerBible.lightMode.value
                                    ? Colors.grey
                                    : Colors.white,
                                fontSize: _controllerBible.fontSize.value,
                              ),
                            ),
                            leading: const Icon(
                              Icons.book,
                              color: Color.fromARGB(255, 226, 187, 161),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _chapterNumber.toString(),
                                style: TextStyle(
                                  color: _controllerBible.lightMode.value
                                      ? Colors.grey
                                      : Colors.white,
                                  fontSize: 50,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DialButton(
                                    number: 1,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 1;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                  DialButton(
                                    number: 2,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 2;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                  DialButton(
                                    number: 3,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 3;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DialButton(
                                    number: 4,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 4;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                  DialButton(
                                    number: 5,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 5;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                  DialButton(
                                    number: 6,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 6;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DialButton(
                                    number: 7,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 7;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                  DialButton(
                                    number: 8,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 8;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                  DialButton(
                                    number: 9,
                                    onPressed: () {
                                      setStateF(() {
                                        _chapterNumber *= 10;
                                        _chapterNumber += 9;
                                        if (_chapterNumber > maxChapters) {
                                          _chapterNumber = maxChapters;
                                        }
                                      });
                                    },
                                    padding: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                ),
                                onPressed: () =>
                                    _onChapter(bookIndex, _chapterNumber),
                                child: const Text(
                                  "Werenga / Read",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          },
        );
      },
    );
    // Navigator.pushNamed(context, "/book", arguments: BOOK.values[index]);
  }

  void _onAbout() => Navigator.pushNamed(context, "/about");

  void _onSearch(BuildContext context) {
    showSearch(
        context: context,
        delegate: WidgetSearchMenu(_controllerBible.bible.value.getBooks()));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            body: Container(
              color: Colors.black87,
              child: Center(
                child: Column(children: [
                  SizedBox(
                    width: 500,
                    height: 500,
                    child: Image.asset('assets/icons/logo.png'),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset('assets/anim/loading.json'),
                  )
                ]),
              ),
            ),
          )
        : Obx(
            () => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Buku Lopatulika",
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 8.0,
                  backgroundColor: Colors.brown,
                  actions: [
                    IconButton(
                        onPressed: () => _onSearch(context),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        )),
                    IconButton(
                        onPressed: () => _controllerBible.toggleLightMode(),
                        icon: const Icon(
                          Icons.contrast,
                          color: Colors.white,
                          size: 20,
                        )),
                    IconButton(
                        onPressed: _onAbout,
                        icon:
                            const Icon(Icons.info_outline, color: Colors.white))
                  ],
                ),
                body: SafeArea(
                  child: Container(
                    color: _controllerBible.lightMode.value
                        ? Colors.white
                        : Colors.black87,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 5.0,
                              mainAxisExtent: 60.0),
                      itemCount: _controllerBible.bible.value
                          .getBooks()
                          .length, // Number of items in the grid
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Colors.brown
                                      .shade300), // Optional border styling
                              borderRadius: BorderRadius.circular(
                                  10), // Sets uniform rounded corners
                            ),
                            style: ListTileStyle.list,
                            tileColor: _controllerBible.lightMode.value
                                ? Colors.grey
                                : Colors.black12,
                            onTap: () => _onBook(index),
                            title: Text(
                              _controllerBible.bible.value.getBooks()[index],
                              style: TextStyle(
                                color: _controllerBible.lightMode.value
                                    ? Colors.grey
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: _controllerBible.fontSize.value,
                              ),
                            ),
                            subtitle: Text(
                              "${_controllerBible.bible.value.getChapterCount(BOOK.values[index]).toString()} Chapters",
                              style: TextStyle(
                                color: _controllerBible.lightMode.value
                                    ? Colors.grey
                                    : Colors.grey,
                                fontSize: _controllerBible.fontSize.value,
                              ),
                            ),
                            trailing: Badge(
                              backgroundColor: Colors.pink,
                              child: Text(
                                _mapHighlights[index]?.toString() ?? "0",
                                style: TextStyle(
                                  color: _controllerBible.lightMode.value
                                      ? Colors.grey
                                      : Colors.white,
                                ),
                              ),
                            ),
                            leading: const Icon(
                              Icons.book,
                              color: Color.fromARGB(255, 226, 187, 161),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
          );
  }
}
