import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 100, minWidth: 100),
            margin: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 4.5,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.white,
                  blurRadius: 2,
                ),
                BoxShadow(
                  offset: Offset(-2, -2),
                  color: Colors.white,
                  blurRadius: 2,
                ),
              ],
            ),
            child: const Center(child: Text('Event Container')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: 70,
                ),
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('Seminar')),
              ),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 70,
                ),
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('Project')),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: 70,
                ),
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('Attendence')),
              ),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 70,
                ),
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('Syllabus')),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('NSS')),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Text('NCC')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
