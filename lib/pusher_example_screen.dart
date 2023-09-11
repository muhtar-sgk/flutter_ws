import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherExampleScreen extends StatefulWidget {
  const PusherExampleScreen({Key? key}) : super(key: key);

  @override
  State<PusherExampleScreen> createState() => _PusherExampleScreenState();
}

class _PusherExampleScreenState extends State<PusherExampleScreen> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _log = '';
  final _listViewController = ScrollController();
  List<String> nameList = [];

  void log(String text) {
    print("LOG: $text");

    // setState(() {
    //   _log += text + "\n";
    //   Timer(
    //       const Duration(milliseconds: 100),
    //       () => _listViewController
    //           .jumpTo(_listViewController.position.maxScrollExtent));
    // });
  }

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    onConnectPressed();
  }

  void onConnectPressed() async {
    try {
      await pusher.init(
        apiKey: '233bb987a2283185a9d4',
        cluster: 'ap1',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: "<Your Authendpoint Url>",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: 'my-channel');
      await pusher.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  // void onEvent(PusherEvent event) {
  //   log("onEvent: $event");
    
  //   Map<String, dynamic> jsonObject = json.decode(event.data);
  //   print('test name ${jsonObject.containsKey("name")}');
  //   print('test age ${jsonObject.containsKey("age")}');

  //   List<String> names = List<String>.from(jsonObject['name']);    
  //       setState(() {
  //         nameList = names;
  //       }); 
  //   _showAlertDialog(jsonObject.toString());
  // }

  void onEvent(PusherEvent event) {
  log("onEvent: $event");

  try {
    final Map<String, dynamic> jsonObject = json.decode(event.data);

    // Periksa apakah data adalah objek JSON dengan properti "name"
    if (jsonObject.containsKey("name")) {
      final dynamic nameData = jsonObject["name"];
      
      if (nameData is List<dynamic>) {
        // Data adalah dalam bentuk list, kita tambahkan semua nama ke dalam list
        setState(() {
          nameList.addAll(nameData.cast<String>());
        });
      } else if (nameData is String) {
        // Data adalah dalam bentuk string, tambahkan satu nama ke dalam list
        setState(() {
          nameList.add(nameData);
        });
      }
    }
  } catch (e) {
    log("Error parsing JSON: $e");
  }

  _showAlertDialog(event.data);
}


  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    return {
      "auth": "foo:bar",
      "channel_data": '{"user_id": 1}',
      "shared_secret": "foobar"
    };
  }

  void _showAlertDialog(String message) async {
    await _audioPlayer.play(AssetSource('sounds/alert_dialog.wav'));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // _isAlertDialogShown = false;
                _audioPlayer.stop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pusher Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: nameList.length,
            itemBuilder: (context, index) {
            return ListTile(
              title: Text(nameList[index]),
            );
            },
          ),
          // child: ListView(
          //     controller: _listViewController,
          //     scrollDirection: Axis.vertical,
          //     shrinkWrap: true,
          //     children: <Widget>[
          //       // if (pusher.connectionState != 'CONNECTED')
          //       //   Form(
          //       //       key: _channelFormKey,
          //       //       child: Column(children: <Widget>[
          //       //         TextFormField(
          //       //           controller: _apiKey,
          //       //           validator: (String? value) {
          //       //             return (value != null && value.isEmpty)
          //       //                 ? 'Please enter your API key.'
          //       //                 : null;
          //       //           },
          //       //           decoration:
          //       //               const InputDecoration(labelText: 'API Key'),
          //       //         ),
          //       //         TextFormField(
          //       //           controller: _cluster,
          //       //           validator: (String? value) {
          //       //             return (value != null && value.isEmpty)
          //       //                 ? 'Please enter your cluster.'
          //       //                 : null;
          //       //           },
          //       //           decoration: const InputDecoration(
          //       //             labelText: 'Cluster',
          //       //           ),
          //       //         ),
          //       //         TextFormField(
          //       //           controller: _channelName,
          //       //           validator: (String? value) {
          //       //             return (value != null && value.isEmpty)
          //       //                 ? 'Please enter your channel name.'
          //       //                 : null;
          //       //           },
          //       //           decoration: const InputDecoration(
          //       //             labelText: 'Channel',
          //       //           ),
          //       //         ),
          //       //         ElevatedButton(
          //       //           onPressed: onConnectPressed,
          //       //           child: const Text('Connect'),
          //       //         )
          //       //       ]))
          //       // else
          //       //   Form(
          //       //     key: _eventFormKey,
          //       //     child: Column(children: <Widget>[
          //       //       ListView.builder(
          //       //           scrollDirection: Axis.vertical,
          //       //           shrinkWrap: true,
          //       //           itemCount: pusher
          //       //               .channels[_channelName.text]?.members.length,
          //       //           itemBuilder: (context, index) {
          //       //             final member = pusher
          //       //                 .channels[_channelName.text]!.members.values
          //       //                 .elementAt(index);

          //       //             return ListTile(
          //       //                 title: Text(member.userInfo.toString()),
          //       //                 subtitle: Text(member.userId));
          //       //           }),
          //       //       TextFormField(
          //       //         controller: _eventName,
          //       //         validator: (String? value) {
          //       //           return (value != null && value.isEmpty)
          //       //               ? 'Please enter your event name.'
          //       //               : null;
          //       //         },
          //       //         decoration: const InputDecoration(
          //       //           labelText: 'Event',
          //       //         ),
          //       //       ),
          //       //       TextFormField(
          //       //         controller: _data,
          //       //         decoration: const InputDecoration(
          //       //           labelText: 'Data',
          //       //         ),
          //       //       ),
          //       //       ElevatedButton(
          //       //         onPressed: onTriggerEventPressed,
          //       //         child: const Text('Trigger Event'),
          //       //       ),
          //       //     ]),
          //       //   ),
          //       SingleChildScrollView(
          //           scrollDirection: Axis.vertical, child: Text(_log)),
          //     ]),
        ),
    );
  }
}