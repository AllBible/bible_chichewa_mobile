import 'package:chichewa_bible/controllers/bible.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  final _controllerBible = Get.put(BibleController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          elevation: 16.0,
          shadowColor: _controllerBible.lightMode.value
              ? Colors.black
              : Colors.brown.shade400, // Required to show shadow in M3
          surfaceTintColor: Colors.transparent, // Suppresses M3 tint
          title: const Text("Settings", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: _controllerBible.lightMode.value
              ? Colors.white
              : Colors.black87,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Font Size: ${_controllerBible.fontSize.value}",
                    style: TextStyle(
                      color: _controllerBible.lightMode.value
                          ? Colors.grey
                          : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: _controllerBible.fontSize.value,
                    min: 10,
                    max: 40,
                    divisions: 30,
                    activeColor: Colors.brown,
                    label: _controllerBible.fontSize.value.round().toString(),
                    onChanged: (double value) =>
                        _controllerBible.updateFontSize(value),
                  ),
                  Text(
                    "Khalani Wodalitsidwa ndi Mawu a Mulungu",
                    style: TextStyle(
                      fontSize: _controllerBible.fontSize.value,
                      color: _controllerBible.lightMode.value
                          ? Colors.grey
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
