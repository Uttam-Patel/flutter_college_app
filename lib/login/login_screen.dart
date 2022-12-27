import 'package:flutter/material.dart';
import 'package:flutter_college_app/login/user_login.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Log In as',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLogIn(
                    user: 'Student',
                    idType: 'Enrollment',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.assignment_ind),
            label: const Text('Student'),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                Size(150, 50),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLogIn(
                    user: 'Teacher',
                    idType: 'TID',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person),
            label: const Text('Teacher'),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size(150, 50),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLogIn(
                    user: 'Admin',
                    idType: 'AID',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.admin_panel_settings),
            label: const Text('Admin'),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size(150, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
