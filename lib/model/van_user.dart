class VanUser {
  var id;
  String firstName;
  String lastName;
  String address;
  String email;
  var password;
  var lastLogin;
  String firstRegister;

  VanUser(
      {this.id = '',
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.email,
      required this.password,
      required this.lastLogin,
      required this.firstRegister});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'email': email,
        'password': password,
        'lastLogin': lastLogin,
        'firstRegister': firstRegister
      };

  static VanUser fromJson(Map<String, dynamic> json) => VanUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      email: json['email'],
      password: json['password'],
      lastLogin: json['last_login'],
      firstRegister: json['first_register']);
}
