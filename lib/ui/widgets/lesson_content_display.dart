import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class LessonContentDisplay extends StatelessWidget {
  final List<Map<dynamic, dynamic>> data;

  const LessonContentDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.map((element) {
          switch (element['type']) {
            case 'h1':
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  element['content'],
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );

            case 'h2':
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  element['content'],
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              );

            case 'h3':
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  element['content'],
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              );

            case 'h4':
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  element['content'],
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );

            case 'h5':
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  element['content'],
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              );

            case 'h6':
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  element['content'],
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              );

            case 'p':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  element['content']!,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            case 'img':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(element['content']!),
              );
            case 'pre':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: HighlightView(
                  element['content']!,
                  theme: githubTheme,
                  language: 'python',
                  padding: const EdgeInsets.all(4.0),
                  textStyle: const TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 16.0,
                  ),
                ),
              );
            case "":
              return const SizedBox(
                height: 16.0,
                child: Divider(
                  color: Colors.black,
                  height: 1.0,
                ),
              );
            case 'li':
              return Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\u2022',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(element['content'])),
                  ],
                ),
              );
            case 'div':
              return Text(
                String.fromCharCode(160),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black,
                ),
              );
            case 'table':
              return JsonTableWidget(jsonData: element['content']!);
            default:
              log('Unknown element type: ${element['type']}');
              return const SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }
}

class JsonTableWidget extends StatelessWidget {
  final List<dynamic> jsonData;

  const JsonTableWidget({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    final List<List<dynamic>> data = jsonData.map((e) => e as List<dynamic>).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(data.length, (int rowIndex) {
            final List<dynamic> row = data[rowIndex];

            return Row(
              children: List.generate(row.length, (int cellIndex) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      row[cellIndex].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}
