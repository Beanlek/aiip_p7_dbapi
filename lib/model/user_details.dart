class UserDetails {
  var id;
  String firstName;
  String lastName;
  int age;
  String address;
  String email;
  var password;
  var lastLogin;
  String firstRegister;

  UserDetails(
      {this.id = '',
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.address,
      required this.email,
      required this.password,
      required this.lastLogin,
      required this.firstRegister});

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'address': address,
        'email': email,
        'password': password,
        'lastLogin': lastLogin,
        'firstRegister': firstRegister
      };

  static UserDetails fromJson(Map<String, dynamic> json) => UserDetails(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'],
      address: json['address'],
      email: json['email'],
      password: json['password'],
      lastLogin: json['last_login'],
      firstRegister: json['first_register']);
}
