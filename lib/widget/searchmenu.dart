import 'package:flutter/material.dart';

class WidgetSearchMenu extends SearchDelegate {
  final List<String> names;
  final Function(int) onBookSelected;

  WidgetSearchMenu({required this.names, required this.onBookSelected});

  void _onGoToBook(BuildContext context, String name) async {
    if (name == "Fufuzani Baibulo") {
      if (query.isNotEmpty && query.length >= 2) {
        Navigator.pushNamed(context, "/search", arguments: query);
      }
    } else {
      Navigator.pop(context);
      var index = names.indexOf(name);
      onBookSelected(index);
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = ["Fufuzani Baibulo"];
    for (var name in names) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(name);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => ListTile(
        leading: index == 0 ? null : Icon(Icons.book),
        title: index == 0
            ? Row(children: [const Icon(Icons.search), Text(matchQuery[index])])
            : Text(matchQuery[index]),
        onTap: () => _onGoToBook(context, matchQuery[index]),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = ["Fufuzani Baibulo"];
    for (var name in names) {
      if (name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(name);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => ListTile(
        leading: index == 0 ? null : Icon(Icons.book),
        title: index == 0
            ? Row(children: [const Icon(Icons.search), Text(matchQuery[index])])
            : Text(matchQuery[index]),
        onTap: () => _onGoToBook(context, matchQuery[index]),
      ),
    );
  }
}
