class User {
  int id;
  String name;
  String email;
  String walletAddress;
  String profilePhotoUrl;
  String token;

  User({
    this.id,
    this.name,
    this.email,
    this.walletAddress,
    this.profilePhotoUrl,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        walletAddress: responseData['walletAddress'],
        profilePhotoUrl: responseData['profile_photo_url'],
        token: responseData['token']);
  }
}
