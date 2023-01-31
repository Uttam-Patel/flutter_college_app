import 'package:flutter/material.dart';

class LiveClass extends StatelessWidget {
  const LiveClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Icon(Icons.notifications),
          PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: ((context) {
                return [
                  PopupMenuItem(
                    child: const Text('Refresh'),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const Text('Scanner'),
                  ),
                  PopupMenuItem(
                    child: const Text('Report'),
                    onTap: () {},
                  ),
                ];
              }))
        ],
      ),
      body: Center(
        child: Text('Coming Soon...'),
      ),
    );
  }
}
