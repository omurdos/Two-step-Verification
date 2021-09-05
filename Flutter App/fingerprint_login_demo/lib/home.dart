import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:signalr_core/signalr_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final localAuth = LocalAuthentication();
  bool isChecking = true;
  bool canCheckBiometrics = false;
  final connection = HubConnectionBuilder()
      .withUrl(
          'http://192.168.0.24:8090/loginHub',
          HttpConnectionOptions(
            logging: (level, message) => print(message),
          ))
      .build();

  @override
  void initState() {
    checkFingerPrintSensorAvailability();
    setupConnection();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isChecking == true
              ? CircularProgressIndicator()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    canCheckBiometrics == false
                        ? Text(
                            "Your device don't support fingerprint capabilities")
                        : Text(
                            "Place your finger on fingerprint reader to continue")
                  ],
                ),
        ),
      ),
    );
  }

  checkFingerPrintSensorAvailability() async {
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    setState(() {
      this.isChecking = false;
    });
  }

  setupConnection() async {
    try {
      connection.on('ReceiveMessage', (message) {
        print(message.toString());
      });
      connection.on('NewLoginRequest', (message) async {
        final result = await localAuth.authenticate(
            localizedReason: "To get access to your dashboard",
            biometricOnly: true);
        if (result) {
         await connection.invoke("GrantLogin", args: [result.toString(), message?[0]]);
        }
      });
      await connection.start();
    } catch (e, stackTrace) {
      print(e.toString() + stackTrace.toString());
    }
  }
}
