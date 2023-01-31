import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/constants.dart';
import '../util/events_util.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List eventTitle = [];
  List eventDetails = [];
  List eventCoverPhoto = [];
  List timestamp = [];
  List eventJoinLink = [];
  @override
  void initState() {
    // TODO: implement initState
    getEvents();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventJoinLink.clear();
    timestamp.clear();
    eventCoverPhoto.clear();
    eventDetails.clear();
    eventTitle.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (eventTitle.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: eventTitle.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: InkWell(
                onTap: () {
                  clicked_event_title = eventTitle[index];
                  clicked_event_about = eventDetails[index];
                  clicked_event_link = eventCoverPhoto[index];
                  clicked_event_duedate = timestamp[index].toDate();
                  print(clicked_event_duedate);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventPage()));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(eventCoverPhoto[index]),
                            fit: BoxFit.cover),
                        color: Colors.lightBlueAccent[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                eventTitle[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ));
        },
      );
    }
  }

  Future getEvents() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .orderBy('createdLink', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        setState(() {
          eventTitle.add(doc["Title"]);
          eventDetails.add(doc["About"]);
          eventCoverPhoto.add(doc["Link"]);
          timestamp.add(doc["Due Date"]);
          eventJoinLink.add(doc["joinLink"]);
        });
      });
    });
  }
}
