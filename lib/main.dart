import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailPage extends StatefulWidget {
   DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final dio = Dio();


  Future<AnalyseImageResponse> analyseImageHttp() async {

    Response response;

    response = await dio.post('http://127.0.0.1:5005/test-extract-text-ia/us-central1/analyzeImageHttp', data: {"imageUrl": "https://firebasestorage.googleapis.com/v0/b/test-extract-text-ia.appspot.com/o/Modern%20Restaurant%20Bill.jpg?alt=media&token=59e5af32-d3f2-4c7b-88af-6141834caf60"}, options: Options(contentType: Headers.jsonContentType, responseType: ResponseType.json),onSendProgress: (i, j){
      print(i);
      print(j);

    }, onReceiveProgress: (i, j){
      print(i);
      print(j);
    });
    var body1 = response.data;

    print(body1.runtimeType);
    List<dynamic> data = body1['data'];
    print(data.runtimeType);
    print(data);
    List<Map<String, dynamic>> datas = [];
    for (var i in data) {
      Map<String, dynamic> map = {};
      print(i["Items"]);
      map["Items"] = i["Items"];
      map["Quantity"] = i["Quantity"];
      map["Price per Unit"] = i["Price per Unit"];
      map["Tax per Unit"] = i["Tax per Unit"];
      map["Amount"] = i["Amount"];
      datas.add(map);
    }
    print(datas);
    return AnalyseImageResponse.fromJson({
      "image": body1['image'],
      "data": datas,
    });
  }

   Future<Map<String, List<String>>> extractProducts(List<Map<String, dynamic>> body) async {
    print('extractProducts');
    print(body);
     /* Map<String, String> body = {"imageUrl": "https://firebasestorage.googleapis.com/v0/b/test-extract-text-ia.appspot.com/o/Modern%20Restaurant%20Bill.jpg?alt=media&token=59e5af32-d3f2-4c7b-88af-6141834caf60"};
    final res = await http.post(Uri.parse('http://127.0.0.1:5005/test-extract-text-ia/us-central1/analyzeImageHttp'), body: body);
    print(res.body.runtimeType);

    Map<String, dynamic> body1 = jsonDecode(res.body);*/
     Response response;


     response = await dio.post('http://127.0.0.1:5005/test-extract-text-ia/us-central1/extractProducts', data: {"datas":body}, options: Options(contentType: Headers.jsonContentType, responseType: ResponseType.json),onSendProgress: (i, j){
        print(i);
        print(j);
     }, onReceiveProgress: (i, j){
       print(i);
       print(j);
     });
     var body1 = jsonDecode(response.data);
    Map<String, List<String>> data = {};


     print(body1.runtimeType);
     print(body1);

     body1.forEach(( key, value) {
       print(key);
       print(key.runtimeType);
        print(value);
        print(value.runtimeType);
        data[key] = [];
        for (var i in value) {
          data[key]?.add(i);
        }
     });

     print(data);



     /*for (var i in data) {
       Map<String, dynamic> map = {};
       print(i["Items"]);
       map["items"] = i["Items"];
       map["quantity"] = i["Quantity"];
       map["price_per_unit"] = i["Price per Unit"];
       map["tax_per_unit"] = i["Tax per Unit"];
       map["amount"] = i["Amount"];
       datas.add(map);
     }*/
     return data;
   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Container(
        child:FutureBuilder<AnalyseImageResponse>(
          future: analyseImageHttp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print("Error");
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                if(!snapshot.hasData) {
                  return const Text('No data');
                }
                AnalyseImageResponse data = snapshot.data!;
                String encodedBase64Img = data.image;
                var data1 = data.data;
                // List<dynamic> to List<Map<String, dynamic>>


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
                        future: extractProducts(data1),
                        builder: (context, snapshot1) {
                          if (snapshot1.connectionState == ConnectionState.done) {
                            if (snapshot1.hasError) {
                              print("Error 1");
                              print(snapshot1.error);
                              return Text('Error: ${snapshot1.error}');
                            } else {
                              if(!snapshot1.hasData) {
                                return const Text('No data 1');
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot1.data!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(

                                    title: Text(snapshot1.data!.keys.elementAt(index)),
                                    subtitle: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot1.data!.values.elementAt(index).length,
                                      itemBuilder: (context, index1) {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0),
                                          ),

                                          child:Container(child: Text(snapshot1.data!.values.elementAt(index)[index1]), padding: const EdgeInsets.all(16), color: Theme.of(context).colorScheme.surface,  margin: const EdgeInsets.all(8), ),
                                        );
                                      },
                                    ),
                                  );
                                },
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading...'),
                  ],
                ),
              );
            }

            else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class AnalyseImageResponse {
  final String image;
  final List<Map<String, dynamic>> data;

  AnalyseImageResponse({required this.image, required this.data});

  factory AnalyseImageResponse.fromJson(Map<String, dynamic> json) {
    return AnalyseImageResponse(
      image: json['image'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "data": data,
    };
  }
}
