import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeechToText speechToText = SpeechToText();

  var kata = "Tekan dan tahan Tombol untuk Memulai";
  var tekan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Utama"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 150),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              kata,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      floatingActionButton: AvatarGlow(
        //pakek ini biar ga hambar animasi button nya  ya dit
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
                speechToText.listen(onResult: (hasil) {
                  setState(() {
                    kata = hasil.recognizedWords;
                  });
                });
              } else {
                print(
                    "Programnya rusak bukan programmernya. Orang udah di masukin masa gaada Speechnya"); // Inform the user
              }
            }
          },
          onTapUp: (details) {
            speechToText.stop();
            setState(() {
              tekan = false;
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
