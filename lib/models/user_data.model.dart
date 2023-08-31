import 'package:equatable/equatable.dart';

class UserData with EquatableMixin {
  String? name;
  String? email;
  String? imageUrl;
  String? phoneNumber;
  DateTime? createdAt;
  String? docId;

  UserData();

  UserData.fromJson(Map<String, dynamic> data, String id) {
    docId = id;
    name = data['name'];
    imageUrl = data['imageUrl'];
    phoneNumber = data['phoneNumber'];
    email = data['email'];
    createdAt = (data['createdAt'].runtimeType.toString() == 'Timestamp')
        ? data['createdAt'].toDate()
        : data['createdAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "phoneNumber": phoneNumber,
      "email": email,
      "createdAt": createdAt,
    };
  }

  @override
  List<Object?> get props => [name, imageUrl, phoneNumber];
}
