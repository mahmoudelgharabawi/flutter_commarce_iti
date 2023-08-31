import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/src/providers/email_auth_provider.dart'
    as flutterUi;
import 'package:flutter_commarce/services/app_config.service.dart';
import 'package:flutter_commarce/views/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 1));
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => SignInScreen(
                providers: [flutterUi.EmailAuthProvider()],
                actions: [
                  AuthStateChangeAction<SigningUp>((contextEx, stateEx) async {
                    ScaffoldMessenger.of(contextEx).showSnackBar(const SnackBar(
                        content: Text('You Sign up Successfully')));

                    Navigator.pushAndRemoveUntil(
                        contextEx,
                        MaterialPageRoute(
                            builder: (_) => SignInScreen(
                                  providers: [flutterUi.EmailAuthProvider()],
                                  actions: [
                                    AuthStateChangeAction<SignedIn>(
                                        (contextEx, state) async {
                                      await saveUserData(state);
                                      Navigator.pushAndRemoveUntil(
                                          contextEx,
                                          MaterialPageRoute(
                                              builder: (_) => const HomePage()),
                                          (route) => false);
                                    }),
                                  ],
                                )),
                        (_) => false);
                  }),
                  AuthStateChangeAction<SignedIn>((contextEx, state) async {
                    await saveUserData(state);
                    Navigator.pushAndRemoveUntil(
                        contextEx,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false);
                  }),
                ],
              ),
            ),
            (route) => false);
      } else {
        if (!mounted) return;
        await AppConfigService.refreshUserData();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false);
      }
    });
  }

  Future<void> saveUserData(SignedIn userState) async {
    if (userState.user == null) return;

    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userState.user?.uid)
          .get();

      await AppConfigService.refreshUserData(dataFromFirebase: userData);

      if (!userData.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userState.user?.uid)
            .set({
          "createdAt": DateTime.now(),
          "email": userState.user?.email,
          "name": userState.user?.displayName,
          "imageUrl": "",
          "phoneNumber": userState.user?.phoneNumber,
        });
      }
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>> error in save user Data ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
