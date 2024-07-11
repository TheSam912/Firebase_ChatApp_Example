import 'package:chat_app_firebase/pages/settings_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logOut() {
    AuthService authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Center(
                      child:
                          Icon(Icons.message, size: 50, color: Colors.black))),
              ListTile(
                title: Text(
                  "H O M E",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "S E T T I N G S",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                leading: Icon(Icons.settings,
                    color: Theme.of(context).colorScheme.secondary),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const SettingsPage();
                    },
                  ));
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              leading: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.secondary),
              onTap: () {
                logOut();
              },
            ),
          )
        ],
      ),
    );
  }
}
