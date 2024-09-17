// Mengimpor paket-paket yang diperlukan untuk aplikasi Flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk pemformatan tanggal
import 'package:shared_preferences/shared_preferences.dart'; // Untuk penyimpanan lokal

// Titik masuk aplikasi
void main() {
  runApp(MyApp()); // Menjalankan aplikasi dengan widget utama MyApp
}

// Widget utama aplikasi yang mengatur tema dan halaman awal
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUGAS 1 PEMROGRAMAN PIRANTI BERGERAK',
      // Mendefinisikan tema aplikasi dengan warna kustom dan gaya
      theme: ThemeData(
        primaryColor: const Color(0xFF20B2AA), // Warna utama (teal)
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Latar belakang abu-abu lembut
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF20B2AA),
          foregroundColor: Colors.white,
        ),
        // Mengatur tema tombol dengan warna kustom
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color(0xFF20B2AA),
          ),
        ),
        // Mengatur tema teks dengan warna default
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: MainScreen(), // Menentukan halaman utama aplikasi
    );
  }
}

// Layar utama aplikasi yang menampilkan navigasi bawah
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Indeks halaman yang aktif
  // Daftar halaman yang akan ditampilkan di navigasi bawah
  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
    CartScreen(),
  ];

  // Fungsi untuk mengubah halaman yang aktif saat item navigasi ditekan
  void _menutap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APLIKASI MENU RESTORAN FRANCE'),
      ),
      body: _pages[_selectedIndex], // Menampilkan halaman yang sesuai dengan indeks
      // Membuat navigasi bawah dengan 3 item: Home, Profile, dan Cart
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF20B2AA),
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: _menutap,
      ),
    );
  }
}

// Layar beranda yang menampilkan menu restoran
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Daftar judul menu yang tersedia
  final List<String> menuTitles = [
    'BURGER',
    'PIZZA',
    'SALAD',
    'PASTA',
    'STEAK',
    'MACAROON'
  ];
  List<String> filteredMenuTitles = []; // Daftar menu yang telah difilter
  String searchQuery = ''; // Query pencarian saat ini

  @override
  void initState() {
    super.initState();
    filteredMenuTitles = List.from(menuTitles); // Inisialisasi daftar filter dengan semua menu
  }

  // Fungsi untuk memfilter menu berdasarkan pencarian
  void _filterMenu(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua menu
        filteredMenuTitles = List.from(menuTitles);
      } else {
        // Filter menu berdasarkan query (case-insensitive)
        filteredMenuTitles = menuTitles
            .where((menu) => menu.toLowerCase().contains(query.toLowerCase()))
            .toList();

        // Jika tidak ada hasil yang cocok, tambahkan pesan "Menu tidak ada"
        if (filteredMenuTitles.isEmpty) {
          filteredMenuTitles.add('Menu tidak ada');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MENU'),
      ),
      body: Column(
        children: [
          // Kotak pencarian menu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari Menu',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF20B2AA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF20B2AA), width: 2.0),
                ),
                labelStyle: TextStyle(color: Colors.black87),
              ),
              onChanged: _filterMenu, // Memanggil fungsi filter saat teks berubah
            ),
          ),
          // Menampilkan grid menu yang telah difilter
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(filteredMenuTitles.length, (index) {
                if (filteredMenuTitles[index] == 'Menu tidak ada') {
                  // Menampilkan pesan jika tidak ada menu yang cocok
                  return const Center(
                    child: Text(
                      'Menu tidak ada',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  );
                } else {
                  // Menampilkan item menu
                  return MenuItem(
                    imageUrl: 'assets/image${index + 1}.png',
                    title: filteredMenuTitles[index],
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan item menu individual
class MenuItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  MenuItem({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Menambahkan item ke keranjang saat ditekan
        CartManager().addToCart(title);
        // Menampilkan notifikasi bahwa item telah ditambahkan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title ditambahkan ke keranjang'),
            backgroundColor: const Color(0xFF20B2AA),
          ),
        );
      },
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Color(0xFF20B2AA), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13.0)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color(0xFF20B2AA),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(13.0)),
              ),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Layar profil pengguna
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  DateTime _selectedDate = DateTime.now();
  bool _isDataSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Memuat data profil saat inisialisasi
  }

  // Memuat data profil dari penyimpanan lokal
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('NAMA') ?? '';
      _address = prefs.getString('ALAMAT') ?? '';
      String? savedDate = prefs.getString('TANGGAL LAHIR');
      if (savedDate != null) {
        _selectedDate = DateTime.parse(savedDate);
      }
      _isDataSubmitted = _name.isNotEmpty; // Menandai apakah data sudah pernah disubmit
    });
  }

  // Menyimpan data profil ke penyimpanan lokal
  Future<void> _simpanprofil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NAMA', _name);
    await prefs.setString('ALAMAT', _address);
    await prefs.setString('TANGGAL LAHIR', _selectedDate.toIso8601String());
  }

  // Memilih tanggal lahir menggunakan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF20B2AA),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(primary: Color(0xFF20B2AA)).copyWith(secondary: const Color(0xFF20B2AA)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA DIRI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isDataSubmitted ? _lihatprofil() : _buildProfileForm(),
        ),
      ),
    );
  }

  // Menampilkan tampilan profil setelah data diisi
  Widget _lihatprofil() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/2209106102.png'),
          backgroundColor: Color(0xFF20B2AA),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _datadiriitem(Icons.person, 'NAMA:', _name),
                const Divider(height: 20, thickness: 1, color: Color(0xFF20B2AA)),
                _datadiriitem(Icons.home, 'ALAMAT:', _address),
                const Divider(height: 20, thickness: 1, color: Color(0xFF20B2AA)),
                _datadiriitem(Icons.calendar_today, 'TANGGAL LAHIR:', DateFormat('yyyy-MM-dd').format(_selectedDate)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          child: const Text('LIHAT MENU'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  // Membuat item profil dengan ikon dan teks
  Widget _datadiriitem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF20B2AA)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan formulir profil untuk diisi
  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'NAMA',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon masukkan nama Anda';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'ALAMAT',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon masukkan alamat Anda';
              }
              return null;
            },
            onSaved: (value) {
              _address = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              'TANGGAL LAHIR: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _simpanprofil();
                setState(() {
                  _isDataSubmitted = true;
                });
              }
            },
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}

// Kelas untuk mengelola keranjang belanja menggunakan Singleton pattern
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  List<String> _cartItems = [];

  // Menambahkan item ke keranjang
  void addToCart(String item) {
    _cartItems.add(item);
  }

  // Mendapatkan daftar item dalam keranjang
  List<String> getCartItems() {
    return _cartItems;
  }

  // Mengosongkan keranjang
  void clearCart() {
    _cartItems.clear();
  }
}

// Layar keranjang belanja
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> cartItems = CartManager().getCartItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('KERANJANG'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Keranjang Kosong',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    title: Text(
                      cartItems[index],
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF20B2AA)),
                      onPressed: () {
                        setState(() {
                          cartItems.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      // Tombol untuk mengosongkan keranjang
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            CartManager().clearCart();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Keranjang telah dikosongkan'),
              backgroundColor: Color(0xFF20B2AA),
            ),
          );
        },
        child: const Icon(Icons.delete_sweep),
        backgroundColor: const Color(0xFF20B2AA),
      ),
    );
  }
}