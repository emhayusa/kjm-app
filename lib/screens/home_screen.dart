import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kjm_security/blocs/auth/auth_bloc.dart';
import 'package:kjm_security/blocs/auth/auth_state.dart';
import 'package:kjm_security/screens/dashboard/home/home_page.dart';
import 'package:kjm_security/screens/dashboard/password/passwordscreen.dart';
import 'package:kjm_security/screens/login_screen.dart';
import 'package:kjm_security/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final int _currentIndex = 0;
  int _selectedIndex = 0;

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String sessionId = prefs.getString('session_id') ?? '';
    //kirim permintaan ke API untuk logout
    //var response = await http.post(
    //  Uri.parse(API_LOGOUT),
    //  headers: {'Authorization': 'Bearer $sessionId'},
    //);

    //if (response.statusCode == 200) {
    // Hapus session dari shared preferences
    prefs.remove('user');
    //prefs.remove('session_id');

    // Pindah ke halaman login (setelah logout berhasil)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        title: 'Sukses',
        content: 'Logout berhasil..',
        color: Colors.green,
      ),
    );
    //} else {
    //  showDialog(
    //    context: context,
    //    builder: (context) => AlertDialog(
    //     title: Text('Logout gagal'),
    //     content: Text('Gagal Logout. Coba lagi.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
    //}
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    //ProfileScreen(),
    PasswordScreen(),
    PasswordScreen(),
  ];
  //final PageController _pageController = PageController();
/*
  final List<Widget> _pages = [
    const HomePage(),
    const PiringPage(),
    const KomposPage(),
    BerdikariPage(),
    EdukasiPage(),
  ];
  */
  void _onItemTapped(int index) async {
    if (index == 2) {
      logout(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  /*void _onItemTapped(int index) {
    //setState(() {
    //  _selectedIndex = index;
    // });
    //_pageController.jumpToPage(index);
    if (index == 1) {
      Navigator.pushNamed(context, "/piring");
    } else if (index == 2) {
      Navigator.pushNamed(context, "/kompos");
    } else if (index == 3) {
      Navigator.pushNamed(context, "/berdikari");
    } else if (index == 4) {
      Navigator.pushNamed(context, "/edukasi");
    }
  }*/

/*
  void _onPageChanged(int index) {
    //setState(() {
    //  _selectedIndex = index;
    // });
  }
*/

  Color get_background(selectedIndex) {
    if (selectedIndex == 0) {
      return Colors.blue.shade300;
    } else if (selectedIndex == 1) {
      return Colors.teal.shade300;
    } else {
      return Colors.deepOrange.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      */

      body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (Route<dynamic> route) => false,
              );
            }
          },
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )
          //const HomePage(),
          /*PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),*/
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: get_background(_selectedIndex),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home, color: Colors.white, size: 35),
            icon: Icon(Icons.home, color: Colors.black, size: 30),
            label: 'Home',
          ),
          /*
          BottomNavigationBarItem(
            activeIcon:
                Icon(Icons.account_circle, color: Colors.white, size: 35),
            icon: Icon(Icons.account_circle, color: Colors.black, size: 30),
            label: 'Profile',
          ),
          */
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.key, color: Colors.white, size: 35),
            icon: Icon(Icons.key, color: Colors.black, size: 30),
            label: 'Password',
            // backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.logout, color: Colors.white, size: 35),
            icon: Icon(Icons.logout, color: Colors.black, size: 30),
            label: 'Logout',
            //   backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }
}
