import 'package:flutter/material.dart';
import 'modeller.dart';

// ------------------------------------------
// 1. EKRAN: ANA SAYFA
// ------------------------------------------
class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold kullandım çünkü bu bir sayfanın ana iskeletini oluşturuyor. 
    // AppBar ve gövde (body) kısımlarını yönetmek çok kolay.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moto Rehber'),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),

      // Container'ı hem arka plan resmi koymak hem de sayfanın tamamını kaplaması için kullandım.
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/toprak.jpg'),
            fit: BoxFit.cover,
            // Resim çok parlak olunca yazılar okunmuyor, o yüzden karartma (colorFilter) ekledim.
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.6),
              BlendMode.darken,
            ),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_motorsports,
              size: 90,
              color: Colors.red.shade900,
            ),
            const SizedBox(height: 20),
            const Text(
              'Motosiklet Dünyasına\nHoş Geldiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Yeni başlayanlar için en uygun motorları keşfedin, teknik özelliklerini ve kullanıcı yorumlarını inceleyin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Burada Navigator.push kullanarak ikinci sayfaya geçiş yapıyoruz.
                // PageRouteBuilder kullanarak basit bir fade (solma) efekti ekledim ki 
                // geçişler daha profesyonel ve göze hoş gelsin.
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const KategoriSayfasi(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },

              child: const Text('Motorları Keşfet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// 2. EKRAN: KATEGORİ SAYFASI
// ------------------------------------------
class KategoriSayfasi extends StatelessWidget {
  const KategoriSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Kategori bilgileri
    final List<Map<String, dynamic>> kategoriler = [
      {'isim': 'Racing', 'ikon': Icons.speed, 'renk': Colors.red.shade700, 'aciklama': 'Hız ve performans odaklı sport motorlar'},
      {'isim': 'Naked', 'ikon': Icons.flash_on, 'renk': Colors.orange.shade800, 'aciklama': 'Grenajsız, şehir içi agresif motorlar'},
      {'isim': 'Enduro', 'ikon': Icons.terrain, 'renk': Colors.green.shade700, 'aciklama': 'Hem asfalt hem arazi için dual-sport'},
      {'isim': 'Cross', 'ikon': Icons.landscape, 'renk': Colors.brown.shade700, 'aciklama': 'Motokros pistleri için yarış motorları'},
      {'isim': 'Chopper', 'ikon': Icons.airline_seat_recline_extra, 'renk': Colors.grey.shade800, 'aciklama': 'Rahat oturuşlu cruiser motorlar'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motosiklet Çeşitleri'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      // Column widget'ı ile kategorileri üst üste diziyorum.
      // Her kategoriye tıklandığında ilgili motorları filtreleyip diğer sayfaya gönderiyorum.
      body: Column(

        children: kategoriler.map((kat) {
          return Expanded(
            child: InkWell(
              onTap: () {
                // where metodu ile tüm motorlar arasından sadece seçilen kategoriye ait olanları buluyorum.
                final kategoriMotorlar = motorlar.where((m) => m.kategori == kat['isim']).toList();
                
                // Burada da Navigator.push var ama bu sefer sağdan sola kayma efekti (SlideTransition) verdim.
                // Sayfadan sayfaya geçerken verileri (motorListesi) constructor üzerinden aktarıyorum.
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => KategoriMotorlarSayfasi(
                      kategoriIsim: kat['isim'],
                      kategoriRenk: kat['renk'],
                      motorListesi: kategoriMotorlar,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },

              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (kat['renk'] as Color).withValues(alpha: 0.95),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    Icon(kat['ikon'], color: Colors.white, size: 50),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kat['isim'],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            kat['aciklama'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 24),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ------------------------------------------
// 3. EKRAN: KATEGORİ MOTORLARI SAYFASI
// ------------------------------------------
class KategoriMotorlarSayfasi extends StatelessWidget {
  final String kategoriIsim;
  final Color kategoriRenk;
  final List<Motosiklet> motorListesi;

  const KategoriMotorlarSayfasi({
    super.key,
    required this.kategoriIsim,
    required this.kategoriRenk,
    required this.motorListesi,
  });

  Widget _ozellikSatiri(IconData icon, String baslik, String deger, Color renk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: renk, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 12, height: 1.3),
                children: [
                  TextSpan(text: '$baslik ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: deger),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _motorKarti(Motosiklet motor) {
    final bgColor = Color.lerp(motor.temaRengi, Colors.white, 0.8) ?? Colors.white;
    // Her bir motor için bir 'Kart' tasarımı oluşturdum.
    // Container ve BoxDecoration kullanarak gölge ve yuvarlak köşeler verdim.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: motor.temaRengi.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: motor.temaRengi,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Text(
              motor.isim,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Üst Kısım: Fotoğraf (sol) + Teknik Veriler (sağ)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol: Fotoğraf
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white, // Fotoğraf alanı beyaz kalsın ki motor net gözüksün
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: motor.temaRengi.withValues(alpha: 0.3)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Transform.scale(
                        scale: motor.isim == 'Yamaha MT-25' ? 1.4 : 1.0,
                        child: Image.asset(
                          motor.resimUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.two_wheeler, size: 60, color: motor.temaRengi),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Sağ: Teknik Veriler
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.build, color: motor.temaRengi, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                "Teknik Veriler",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: motor.temaRengi),
                              ),
                            ],
                          ),
                          Divider(color: motor.temaRengi.withValues(alpha: 0.3)),
                          _ozellikSatiri(Icons.settings, 'Motor:', motor.ozellikler, motor.temaRengi),
                          _ozellikSatiri(Icons.speed, 'Son Hız:', motor.topSpeed, motor.temaRengi),
                          _ozellikSatiri(Icons.timer, '0-100:', motor.hizlanma, motor.temaRengi),
                          _ozellikSatiri(Icons.local_gas_station, 'Yakıt:', motor.yakitTuketimi, motor.temaRengi),
                          _ozellikSatiri(Icons.tire_repair, 'Lastik:', motor.lastikEbatlari, motor.temaRengi),
                          _ozellikSatiri(Icons.security, 'Fren:', motor.frenMarkasi, motor.temaRengi),
                          _ozellikSatiri(Icons.public, 'Menşei:', motor.mensei, motor.temaRengi),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Motor Hakkında
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.lerp(motor.temaRengi, Colors.white, 0.9), // Biraz daha açık bir ton
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: motor.temaRengi.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: motor.temaRengi, size: 18),
                    const SizedBox(width: 6),
                    Text("Motor Hakkında", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: motor.temaRengi)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(motor.aciklama, style: const TextStyle(fontSize: 13, height: 1.5), textAlign: TextAlign.justify),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Kullanıcı Görüşleri
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.lerp(motor.temaRengi, Colors.white, 0.9), // Motor Hakkında ile aynı
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: motor.temaRengi.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.format_quote, color: motor.temaRengi, size: 18),
                    const SizedBox(width: 6),
                    Text("Kullanıcı Görüşleri", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: motor.temaRengi)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  motor.kullaniciGorusleri,
                  style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, height: 1.5, color: Colors.black87),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900, // Koyu mod rengi
      appBar: AppBar(
        title: Text('$kategoriIsim Motorları'),
        backgroundColor: kategoriRenk,
        foregroundColor: Colors.white,
      ),
      // ListView.builder kullandım çünkü listede kaç tane motor olacağını bilmiyoruz, 
      // builder özelliği sadece ekranda görünenleri çizdiği için uygulama çok daha hızlı çalışıyor.
      body: ListView.builder(
        itemCount: motorListesi.length,
        itemBuilder: (context, index) {
          return _motorKarti(motorListesi[index]);
        },
      ),

    );
  }
}
