import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSExampleScreen extends StatefulWidget {
  const WSExampleScreen({super.key});

  @override
  State<WSExampleScreen> createState() => _WSExampleScreenState();
}

class _WSExampleScreenState extends State<WSExampleScreen> {
  final List<String> _websocketMessages = [];
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://socketsbay.com/wss/v2/1/demo/'),
  );
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAlertDialogShown = false;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
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
                _isAlertDialogShown = false;
                _audioPlayer
                    .stop();
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
      appBar: AppBar(title: Text('Web Socket Example')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form(
            //   child: TextFormField(
            //     controller: _controller,
            //     decoration: const InputDecoration(labelText: 'Send a message'),
            //   ),
            // ),
            // const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final receivedData = snapshot.data as String;
                  print('receivedData ' + receivedData);
                  _websocketMessages.add(receivedData);
                  if (receivedData.contains('muhtar') && !_isAlertDialogShown) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _showAlertDialog(snapshot.data);
                        _isAlertDialogShown =
                            true;
                      });
                    });
                  }
                }
                // return Text(snapshot.hasData ? '${snapshot.data}' : '');
                return Expanded(
                  child: ListView.builder(
                    itemCount: _websocketMessages.length,
                    itemBuilder: (context, index) {
                      return Text(snapshot.hasData ? _websocketMessages[index] : '');
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      //   tooltip: 'Send message',
      //   child: const Icon(Icons.send),
      // ),
    );
  }
}
