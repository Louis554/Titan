import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myecl/tools/repository/logo_repository.dart';

class SessionPosterRepository extends LogoRepository {
  @override
  // ignore: overridden_fields
  final ext = 'cinema/sessions/';

  Future<Image> getPretendenceLogo(String id) async {
    final uint8List = await getLogo(id, suffix: "/poster");
    if (uint8List.isEmpty) {
      return Image.asset("assets/images/logo.png");
    }
    return Image.memory(uint8List);
  }

  Future<Image> addPretendenceLogo(String path, String id) async {
    final image = await saveLogoToTemp(path);
    final uint8List = await addLogo(image.path, id, suffix: "/poster");
    return Image.memory(uint8List);
  }
}