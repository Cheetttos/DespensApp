import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/setting/app_value_notifier.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150')),
                accountName: Text('Manuel Cerritos'),
                accountEmail: Text('2003@itcelaya.edu.mx')),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text("Práctica n+1"),
              subtitle: Text("aqui va la descripcion si hubiera una"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies app'),
              subtitle: const Text('Peliculas populares'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/movies'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Mi despensa"),
              subtitle: const Text("Relación de productos que no voy a usar"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/despensa'),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Salir"),
              subtitle: const Text("Hasta luego"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            DayNightSwitcher(
              isDarkModeEnabled: AppValueNotifier.banTheme.value,
              onStateChanged: (isDarkModeEnabled) {
                AppValueNotifier.banTheme.value = isDarkModeEnabled;
              },
            ),
          ],
        ),
      ),
    );
  }
}
