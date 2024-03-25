// ignore_for_file: constant_identifier_names

import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:myecl/drawer/class/module.dart';
import 'package:myecl/ph/ui/pages/past_ph_page/past_ph_page.dart';
import 'package:myecl/ph/ui/pages/past_ph_selection_page/past_ph_selection_page.dart';
import 'package:myecl/tools/middlewares/deferred_middleware.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:myecl/ph/ui/pages/main_page/main_page.dart'
    deferred as main_page;
import 'package:myecl/ph/ui/pages/admin_page/admin_page.dart'
    deferred as admin_page;

class PhRouter {
  final ProviderRef ref;
  static const String root = '/ph';
  static const String past_ph_selection = '/past_ph_selection';
  static const String past_ph = '/past_ph';
  static const String admin = '/admin';
  static final Module module = Module(
      name: "Ph",
      icon: const Left(HeroIcons.documentText),
      root: PhRouter.root,
      selected: false);
  PhRouter(this.ref);
  QRoute route() => QRoute(
          name: "ph",
          path: PhRouter.root,
          builder: () => main_page.PhMainPage(),
          middleware: [
            DeferredLoadingMiddleware(main_page.loadLibrary)
          ],
          children: [
            QRoute(
                path: past_ph_selection,
                builder: () => const PastPhSelectionPage(),
                children: [
                  QRoute(
                      path: past_ph,
                      builder: () => const PastPhPage(),
                      middleware: [
                        DeferredLoadingMiddleware(admin_page.loadLibrary)
                      ]),
                ]),
            QRoute(
                path: admin,
                builder: () => admin_page.AdminPage(),
                middleware: [
                  DeferredLoadingMiddleware(admin_page.loadLibrary)
                ]),
          ]);
}
