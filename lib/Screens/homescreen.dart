import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sttapk/Screens/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeechToText speechToText = SpeechToText();
  String kata = "Tekan Tombol untuk Memulai";
  bool tekan = false;
  List<String> history = []; // List to store history

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Utama"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
              ),
              child: Text(
                'Menu Navigasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Lihat Histori'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer saat item diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(history: history),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 150),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              kata,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate: tekan,
        duration: Duration(seconds: 2),
        glowColor: Color.fromARGB(97, 14, 77, 55),
        repeat: true,
        startDelay: Duration(milliseconds: 15),
        child: GestureDetector(
          onTapDown: (details) async {
            if (!tekan) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  tekan = true;
                });
                speechToText.listen(onResult: (result) {
                  setState(() {
                    kata = result.recognizedWords;
                  });
                });
              } else {
                print(
                    "Programnya rusak bukan programmernya orang udah di masukin masa gaada Speechnya");

              }
            }
          },
          onTapUp: (details) {
            speechToText.stop();
            setState(() {
              tekan = false;
              history.add(kata); // Add current text to history
              kata = "Tekan dan tahan Tombol untuk Memulai"; // Reset text
            });
          },
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green,
            child: Icon(
              tekan ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
