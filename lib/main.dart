import 'package:flutter/material.dart';
import 'ekranlar.dart';

// Uygulamanın giriş noktası burası. main fonksiyonu ile uygulamayı başlatıyoruz.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp kullandım çünkü bu widget uygulamanın temel ayarlarını (tema, başlık, ana sayfa) 
    // toplu bir şekilde yönetmemi sağlıyor. Navigasyon yapısı için de bu şart.
    return MaterialApp(
      title: 'Başlangıç Motoru Rehberi',
      debugShowCheckedModeBanner: false, // Sağ üstteki çirkin "debug" yazısını bu şekilde kaldırdım.
      
      // Uygulamanın genel görsel kimliğini burada tanımladım.
      // Motor dünyasına en çok yakışan agresif ve dikkat çekici renk olan turuncuyu ana tema seçtim.
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
        // Arka planın çok bembeyaz olup göz yormaması için hafif bir gri tonu verdim.
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      
      // Uygulama açıldığında ilk hangi ekranın geleceğini burada belirliyoruz.
      home: const AnaSayfa(),
    );
  }
}

