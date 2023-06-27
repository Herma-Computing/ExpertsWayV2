class UserAccount {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String registedWith;
  UserAccount({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.registedWith,
  });
  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
      registedWith: json['registed_with']);

  Map<String, dynamic> toJson() => {
        "registed_with": registedWith,
        "email": email,
        "last_name": lastname,
        "first_name": firstname,
        "password": password,
      };
}
