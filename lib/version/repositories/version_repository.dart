import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/tools/repository/repository.dart';
import 'package:myecl/version/class/version.dart';

class VersionRepository extends Repository {
  @override
  // ignore: overridden_fields
  final ext = "information";

  Future<Version> getVersion() async {
    initLogger();
    return Version.fromJson(await getOne(""));
  }
}

final versionRepositoryProvider = Provider((ref) {
  return VersionRepository();
});
