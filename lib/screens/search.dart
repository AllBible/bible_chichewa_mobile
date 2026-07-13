import 'package:chichewa_bible/classes/verse.dart';
import 'package:chichewa_bible/controllers/bible.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final _controllerBible = Get.put(BibleController());
  var _loading = true;
  var _verses = <Verse>[];
  var _selectedBook = "Genesis";

  void _onSettings() => Navigator.pushNamed(context, "/settings");

  @override
  Widget build(BuildContext context) {
    var search = ModalRoute.of(context)!.settings.arguments as String;

    _controllerBible.searchText(search).then((v) {
      if (_loading) {
        setState(() {
          _loading = false;
          _verses = v;
        });
      }
    });

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text("Fufuzani", style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () => _controllerBible.toggleLightMode(),
              icon: const Icon(Icons.contrast, color: Colors.white),
            ),
            IconButton(
              onPressed: _onSettings,
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
        body: _loading
            ? Container(
                color: _controllerBible.lightMode.value
                    ? Colors.white
                    : Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: _controllerBible.lightMode.value
                            ? Colors.white
                            : Colors.brown,
                      ),
                      Text(
                        "Ku Fufuza...",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: _controllerBible.lightMode.value
                              ? Colors.brown
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                color: _controllerBible.lightMode.value
                    ? Colors.white
                    : Colors.black87,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DropdownButton(
                        value: _selectedBook,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.brown,
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _controllerBible.bible.value.getBooks().map((
                          String name,
                        ) {
                          var count = _verses
                              .where((verse) => verse.book == name)
                              .length;

                          return DropdownMenuItem(
                            value: name,
                            child: Text("$name ($count)"),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (value) =>
                            setState(() => _selectedBook = value!),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _verses
                            .where((verse) => verse.book == _selectedBook)
                            .length,
                        itemBuilder: (context, index) {
                          var verse = _verses
                              .where((verse) => verse.book == _selectedBook)
                              .toList()[index];
                          return ListTile(
                            leading: Text(
                              verse.getRef(),
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            title: Text(
                              verse.text,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: _controllerBible.fontSize.value,
                                color: _controllerBible.lightMode.value
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
