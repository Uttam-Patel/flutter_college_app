import 'package:flutter/material.dart';

import 'constants.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clicked_event_title),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(clicked_event_link!),
                    fit: BoxFit.cover),
                color: Colors.lightBlueAccent[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Last Date of Registration :- " +
                    clicked_event_duedate.toString().substring(0, 10)),
                Divider(),
                Text(
                  "          " + clicked_event_about,
                  style: (TextStyle(fontSize: 16)),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
