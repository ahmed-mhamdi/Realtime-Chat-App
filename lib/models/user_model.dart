class UserModel {
  String? uid;
  String? name;
  String? profilePhotoURL;

  UserModel({
    required this.uid,
    required this.name,
    required this.profilePhotoURL,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    profilePhotoURL = json['profilePhotoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profilePhotoURL'] = profilePhotoURL;
    data['uid'] = uid;
    return data;
  }
}
