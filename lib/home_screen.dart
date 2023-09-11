import 'package:flutter/material.dart';
import 'package:getz_pos/pusher_example_screen.dart';
import 'package:getz_pos/ws_example_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Socket Research')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const WSExampleScreen()
                    )
                  );
                }, 
                child: Text('Web Socket')
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const PusherExampleScreen()
                    )
                  );
                }, 
                child: Text('Pusher')
              ),
            )
          ],
        ),
      ),
    );
  }
}