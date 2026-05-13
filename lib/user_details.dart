class UserDetails {
  final int id;
  final String name;
  final String company;
  final String username;
  final String email;
  final String address;
  final String zip;
  final String state;
  final String country;
  final String phone;
  final String photo;

  const UserDetails({
    required this.id,
    required this.name,
    required this.company,
    required this.username,
    required this.email,
    required this.address,
    required this.zip,
    required this.state,
    required this.country,
    required this.phone,
    required this.photo,

  });

  // A factory method to create an Album instance from a JSON map
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      company: json['company'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      zip: json['zip'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String,

    );
  }
}
