import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future <String> fetchData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/test'));

  if(response.statusCode == 200) {
    var data = response.body;
    return data;
  } else {
    throw Exception('Failed to load data');
  }
}

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoutePage(),
    );
  }
}

class RoutePage extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: Icon(CupertinoIcons.home),
      //   title: Text("LokaMotive"),
      // ),

      body: Stack(
        clipBehavior: Clip.none, // mencegah widget biar ga kepotong
          children: [
          Container(
            width: 413,
            height: 364,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
                topLeft: Radius.zero,
                topRight: Radius.zero,
              ),
              
              image: DecorationImage(
                image: AssetImage('assets/test.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned( 
            top: 39,
            left: 27,
            
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF102E48),
                shape: BoxShape.circle,
              ),
              
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
              ),
            ),

            
          ),

          Positioned(
            top: 206.4,
            left: 31,
            child: Container(
              width: 351,
              height: 217,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFF225477),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                
              ),

              // BUAT INTERACTIVE MAP (BISA DIPENCET) & BUAT SEARCH BAR
              child: Column(
                children: [

                  Container(
                    width: 287,
                    height: 122,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),

                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: 287,
                    height: 38,
                    
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Search Location",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 13,
                          
                        ),
                        prefixIcon: Icon(Icons.location_on_rounded, color: Color(0xFFF28A33)),
                        suffixIcon: Icon(Icons.search_rounded, color: Colors.black.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,

                        )
                        
                      ),
                    )
                  ),

                ],

              )

            )
          ),

          
          Positioned(
            top: 432, // Sesuaikan posisinya
            left: 31,
            child: Container(
              width: 351,
              height: 501,
              decoration: const BoxDecoration(
                color: Color(0xFF225477),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )
              ),
              padding: const EdgeInsets.all(18),
              child: ExpandableCard()
                
              
            ),
          ),
        ],
        ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },

      child: Column(
          children: [
          // tampilin bagian yg di klik
            Container(
              width: 287,
              height: 69,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(15),
              ),
    
              child: Row(
                children: [
                  Icon(Icons.history, color: Colors.black),
                  SizedBox(width: 20),
    
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rumah Talenta BCA",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
    
                      Text(
                        "Jl. Pakuan No. 3, Sumur Batu",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ) 
                ],
              ),
            ),
          

            Positioned(
              top: 800,
              child: AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOut,
              height: _isExpanded ? null : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [Text("Halo aku data ke 1")],
                  // ),
                  // Row(
                  //   children: [Text("Halo aku data 2")],
                  // )
                  Container(
                    width: 400,
                    height: 200,
                    color: Colors.red,
                  )
                ],
              ),
            ),
            )

          ],
        ),
        
        
      );
  }
}



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }