class UserDetail {

  final String name;
  final int age;

  UserDetail({required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age};
  }
}

class PageData {
  // final String imageUrl;
  final String title;
  final String description;

  PageData({required this.title, required this.description});
}
