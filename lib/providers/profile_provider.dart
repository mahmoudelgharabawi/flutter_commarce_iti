import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_commarce/main.dart';
import 'package:flutter_commarce/models/user_data.model.dart';
import 'package:flutter_commarce/services/app_config.service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController? nameController;
  TextEditingController? phoneController;
  UserData? oldUserData;
  final SimpleFontelicoProgressDialog _dialog =
      SimpleFontelicoProgressDialog(context: navigatorKey.currentContext!);

  void init() {
    oldUserData = AppConfigService.currentUser;
    nameController =
        TextEditingController(text: AppConfigService.currentUser?.name);
    phoneController =
        TextEditingController(text: AppConfigService.currentUser?.phoneNumber);
  }

  @override
  void dispose() {
    nameController?.dispose();
    phoneController?.dispose();
    super.dispose();
  }

  void setImageToFirebase() async {
    try {
      var result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg'],
          withData: true);

      if (result?.files.first.bytes != null) {
        _dialog.show(
            message: 'Loading...',
            type: SimpleFontelicoProgressDialogType.phoenix);

        var uplaodResult = await FirebaseStorage.instance
            .ref(
                'image/${result?.files.first.name}-${DateTime.now().millisecondsSinceEpoch}')
            .putData(result!.files.first.bytes!);

        var link = await uplaodResult.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(AppConfigService.currentUser?.docId)
            .update({"imageUrl": link});
        await AppConfigService.refreshUserData();

        _dialog.hide();

        Alert(
            context: navigatorKey.currentContext!,
            title: "Image Updated Successfully",
            type: AlertType.success,
            buttons: [
              DialogButton(
                  onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                  child: const Text('Ok'))
            ]).show();
      }

      notifyListeners();
    } catch (e) {
      _dialog.hide();

      Alert(
          context: navigatorKey.currentContext!,
          title: "Error In Creating Order",
          desc: 'error : ${e.toString()}',
          type: AlertType.error,
          buttons: [
            DialogButton(
                onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                child: const Text('Ok'))
          ]).show();
    }
  }

  void updateData() async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);

    try {
      var newUserData = UserData();
      newUserData.name = nameController?.text;
      newUserData.phoneNumber = phoneController?.text;
      if (newUserData == oldUserData) {
        _dialog.hide();

        Alert(
            context: navigatorKey.currentContext!,
            title: "No Data Changes",
            type: AlertType.info,
            buttons: [
              DialogButton(
                  onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                  child: const Text('Ok'))
            ]).show();
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(AppConfigService.currentUser!.docId)
          .update({
        "name": nameController?.text,
        "phoneNumber": phoneController?.text,
      });

      await AppConfigService.refreshUserData();
      _dialog.hide();

      Alert(
          context: navigatorKey.currentContext!,
          title: "Data Updated Successfully",
          type: AlertType.success,
          buttons: [
            DialogButton(
                onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                child: const Text('Ok'))
          ]).show();
    } catch (e) {
      _dialog.hide();

      Alert(
          context: navigatorKey.currentContext!,
          title: "Error In Creating Order",
          desc: 'error : ${e.toString()}',
          type: AlertType.error,
          buttons: [
            DialogButton(
                onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                child: const Text('Ok'))
          ]).show();
    }
  }
}
