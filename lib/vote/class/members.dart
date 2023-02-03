import 'package:myecl/tools/functions.dart';
import 'package:myecl/user/class/list_users.dart';

class Member extends SimpleUser {
  late String role;

  Member(
      {required super.name,
      required super.firstname,
      required super.nickname,
      required super.id,
      required this.role});

  Member copyWith({String? role}) {
    return Member(
        name: super.name,
        firstname: super.firstname,
        nickname: super.nickname,
        id: super.id,
        role: role ?? this.role);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user_id': super.id,
      'role': role,
    };
  }

  factory Member.fromJson(Map<String, dynamic> map) {
    final user = map['user'];
    return Member(
      name: capitaliseAll(user['name']),
      firstname: capitaliseAll(user['firstname']),
      nickname: capitaliseAll(user['nickname'] ?? ""),
      id: user['id'],
      role: capitaliseAll(map['role']),
    );
  }

  factory Member.fromSimpleUser(SimpleUser user, String role) {
    return Member(
      name: user.name,
      firstname: user.firstname,
      nickname: user.nickname,
      id: user.id,
      role: role,
    );
  }

  factory Member.empty() {
    return Member(
      name: '',
      firstname: '',
      nickname: '',
      id: '',
      role: '',
    );
  }
}