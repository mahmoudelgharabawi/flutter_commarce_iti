import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commarce/providers/profile_provider.dart';
import 'package:flutter_commarce/services/app_config.service.dart';
import 'package:flutter_commarce/views/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).init();

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 70,
              ),
              Positioned(
                top: 25,
                left: 7,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              Positioned.fill(
                  bottom: 7,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Profile Page',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      )))
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(.2),
                                  radius: 50,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: AppConfigService
                                              .currentUser?.imageUrl ??
                                          '',
                                      placeholder: (context, url) => const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: FittedBox(
                                              child:
                                                  CircularProgressIndicator())),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: const Color(0xffF16A26),
                                          )),
                                ),
                                Positioned(
                                    right: 5,
                                    bottom: 5,
                                    child: InkWell(
                                      onTap: () =>
                                          profileProvider.setImageToFirebase(),
                                      child: Icon(
                                        Icons.edit,
                                        color: const Color(0xffF16A26),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                controller: profileProvider.nameController,
                                decoration: const InputDecoration(
                                    label: Text('Name'),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: profileProvider.phoneController,
                                decoration: const InputDecoration(
                                    label: Text('Phone Number'),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xffF16A26)),
                                onPressed: () => profileProvider.updateData(),
                                child: const Text('Update Data')),
                          ],
                        ),
                      )),
                      ElevatedButton(
                        onPressed: () async {
                          final SimpleFontelicoProgressDialog _dialog =
                              SimpleFontelicoProgressDialog(context: context);
                          _dialog.show(
                              message: 'Loading...',
                              type: SimpleFontelicoProgressDialogType.phoenix);

                          await FirebaseAuth.instance.signOut();

                          _dialog.hide();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SplashPage()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fixedSize: const Size(double.maxFinite, 45)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Sign Out'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
