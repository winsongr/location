import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LocationAccessScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _checkPermission(context);
          },
          child: const Text('Check Permission'),
        ),
      ),
    );
  }
}

class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/9_Location Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 13),
                    blurRadius: 25,
                    color: const Color(0xFFD27E4A).withOpacity(0.17),
                  ),
                ],
              ),
              child: FlatButton(
                color: const Color(0xFFFF9858),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  _checkPermission(context);
                },
                child: Text(
                  "Enable".toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future _checkPermission(context) async {
  final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
  final isGpsOn = serviceStatus == ServiceStatus.enabled;
  if (!isGpsOn) {
    print('Turn on location services before requesting permission.');
    return;
  }

  final status = await Permission.locationWhenInUse.request();
  if (status == PermissionStatus.granted) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  } else if (status == PermissionStatus.denied) {
    print('Permission denied. Show a dialog and again ask for the permission');
  } else if (status == PermissionStatus.permanentlyDenied) {
    await openAppSettings();
  }
}