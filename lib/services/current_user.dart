
class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;
  CurrentUser._internal();

  Map<String, dynamic>? _user;

  void setUser(Map<String, dynamic> user) {
    _user = user;
  }

  Map<String, dynamic>? get user => _user;

  int? get id => _user?['id'];
  String? get fullname => _user?['fullname'];
  String? get role => _user?['role'];
  String? get email => _user?['email'];
  String? get username => _user?['username'];

  void clear() {
    _user = null;
  }

  bool get isLoggedIn => _user != null;
}