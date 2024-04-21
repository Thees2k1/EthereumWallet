import 'home_page.dart';
import 'package:flutter/material.dart';

class DashBoadPage extends StatefulWidget {
  const DashBoadPage({super.key});

  @override
  State<DashBoadPage> createState() => _DashBoadPageState();
}

class _DashBoadPageState extends State<DashBoadPage> {
  int _currentIndex = 0;
  List<Widget> body = [
    HomePage(),
    const Text('others page'),
    const Text('others page'),
    const Text('others page'),
    const Text('others page'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: body[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Colors.blueGrey.shade900,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Noti'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Msg'),
        ],
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
