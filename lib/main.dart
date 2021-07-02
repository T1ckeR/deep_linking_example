import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

bool _initialUriIsHandled = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  // EXAMPLE CODE BEGIN
  String data = 'No data';
  // EXAMPLE CODE END

  _handleIncomingLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      // EXAMPLE CODE BEGIN
      var parsedUri = Uri.parse(uri.toString());

      parsedUri.queryParameters.forEach((key, value) async {
        if (key == 'data') {
          setState(() {
            data = value;
          });
        }
      });
      // EXAMPLE CODE END
    }, onError: (Object err) {
      if (!mounted) return;
    });
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri != null) {
          // EXAMPLE CODE BEGIN
          var parsedUri = Uri.parse(uri.toString());

          parsedUri.queryParameters.forEach((key, value) async {
            if (key == 'data') {
              setState(() {
                data = value;
              });
            }
          });
          // EXAMPLE CODE END
        }
        if (!mounted) return;
      } on PlatformException {
        // failed to get initial uri
      } on FormatException {
        if (!mounted) return;
        // malformed initial uri
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: 500,
          child: Center(
            child: Text(
              data,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }
}