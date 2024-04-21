import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/database/drift_database/database.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

Future<void> initializeDatabase() async {
  database = MyDatabase();
  final res = await database!.findAllWallets();
  if (res.isEmpty) {
    await database!.into(database!.wallets).insert(WalletsCompanion.insert(
        address: '0x2797EAe157DE9aAB22E8AB7B7bbb4aC061A94c85',
        privateKey:
            'bab86aaa751e8867a9da8c448704a2a8936e319509aee0354547bce6052ef92c',
        name: 'MagicLab',
        isSelected: true));
    await database!.into(database!.wallets).insert(WalletsCompanion.insert(
        address: '0x80e0Fbf6E74520e04aEbbAC4e9C209473A7c9d55',
        privateKey:
            '3b1f6570342a1165ebd8ccac3441cfbc45e0d1c55c688ffe468c711c864b4f5f',
        name: 'TongNguyenThe',
        isSelected: false));
  }
  selectedPKey =
      res.firstWhere((element) => element.isSelected == true).privateKey;

  final res2 = await database!.findAllWallets();
  debugPrint(res2.toString());
}

// Future<void> initializeDatabase() async {
//   database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

//   final walletDao = database!.walletDao;
//   final res = await walletDao.findAllWallets();
//   if (res.isEmpty) {
//     try {
//       for (int i = 0; i < wallets.length; i++) {
//         await walletDao.insertWallet(wallets[i]);
//         if (wallets[i].isSelected) {
//           selectedPKey = wallets[i].privateKey;
//         }
//       }
//     } catch (e) {
//       debugPrint('$e');
//     }
//   } else {
//     selectedPKey =
//         res.firstWhere((element) => element.isSelected == true).privateKey;
//   }

//   // else {
//   //   await walletDao.deleteAllWallet();
//   // }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.
//           primarySwatch: Colors.blue,
          
//           ),
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
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             MainCard(),
//             Center(
//               // Center is a layout widget. It takes a single child and positions it
//               // in the middle of the parent.
//               child: Column(
//                 // Column is also a layout widget. It takes a list of children and
//                 // arranges them vertically. By default, it sizes itself to fit its
//                 // children horizontally, and tries to be as tall as its parent.
//                 //
//                 // Invoke "debug painting" (press "p" in the console, choose the
//                 // "Toggle Debug Paint" action from the Flutter Inspector in Android
//                 // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//                 // to see the wireframe for each widget.
//                 //
//                 // Column has various properties to control how it sizes itself and
//                 // how it positions its children. Here we use mainAxisAlignment to
//                 // center the children vertically; the main axis here is the vertical
//                 // axis because Columns are vertical (the cross axis would be
//                 // horizontal).
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     'You have pushed the button this many times:',
//                   ),
//                   Text(
//                     '$_counter',
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                 ],
//               ),
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
