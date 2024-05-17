import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final String _imageUrl = 'https://firebasestorage.googleapis.com/v0/b/test-extract-text-ia.appspot.com/o/Modern%20Restaurant%20Bill.jpg?alt=media&token=59e5af32-d3f2-4c7b-88af-6141834caf60';

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Image.network(_imageUrl),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  Future<Map<String, dynamic>> analyseImageHttp() async {
    Map<String, String> body = {"imageUrl": "https://firebasestorage.googleapis.com/v0/b/test-extract-text-ia.appspot.com/o/Modern%20Restaurant%20Bill.jpg?alt=media&token=59e5af32-d3f2-4c7b-88af-6141834caf60"};
    final res = await http.post(Uri.parse('http://127.0.0.1:5005/test-extract-text-ia/us-central1/analyzeImageHttp'), body: body);
    Map<String, dynamic> body1 = jsonDecode(res.body);
    return body1;
  }

  Future<Map<String, dynamic>?> labelProduct(var rows) async {
    try {
      Map<String, dynamic> body = {
        "rows": [
          {"Items": "Apple normal", "Quantity": "5 KG", "Price per Unit": "Rs . 100.00", "Tax per Unit": "Rs . 5.00 ( 5 % )", "Amount": "Rs . 525.00"},
          {"Items": "Orange", "Quantity": "10 KG", "Price per Unit": "Rs . 40.00", "Tax per Unit": "Rs . 2.00 ( 5 % )", "Amount": "Rs . 420.00"},
          {"Items": "Banana", "Quantity": "5 KG", "Price per Unit": "Rs . 40", "Tax per Unit": "Rs . 2.00 ( 5 % )", "Amount": "Rs.210.00"}
        ]
      };
      var res = await http.post(Uri.parse('http://127.0.0.1:5005/test-extract-text-ia/us-central1/extractProducts'), body: jsonDecode(jsonEncode(body)));
      print(res.body.runtimeType);
      Map<String, dynamic> body1 = jsonDecode(res.body);

      return body1;
    } catch (e) {
      print('Error from labelProduct');
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Container(
        child: FutureBuilder<Map<String, dynamic>>(
          future: analyseImageHttp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print("Error");
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                String encodedBase64Img = snapshot.data!['image'];
                List<Map<String, dynamic>> data1 = [];
                for (var i in snapshot.data!['data']) {
                  data1.add(jsonDecode(jsonEncode(i)));
                }
                print(data1.runtimeType);
                print(data1);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.memory(base64Decode(encodedBase64Img)),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: data1.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(data1[index].toString()),
                          );
                        },
                      ),
                      FutureBuilder(
                        future: labelProduct([]),
                        builder: (context, snapshot1) {
                          if (snapshot1.connectionState == ConnectionState.done) {
                            if (snapshot1.hasError) {
                              print("Error 1");
                              print(snapshot1.error);
                              return Text('Error: ${snapshot1.error}');
                            } else {
                              return Column(
                                children: [],
                              );
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
