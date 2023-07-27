import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:myecl/drawer/class/module.dart';
import 'package:myecl/tombola/providers/is_tombola_admin.dart';
import 'package:myecl/tombola/ui/pages/admin_page/admin_page.dart';
import 'package:myecl/tombola/ui/pages/lots_pages/add_edit_lot_page.dart';
import 'package:myecl/tombola/ui/pages/main_page/main_page.dart';
import 'package:myecl/tombola/ui/pages/tombola_page/tombola_page.dart';
import 'package:myecl/tombola/ui/pages/type_ticket_pages/add_edit_type_ticket_page.dart';
import 'package:myecl/tools/middlewares/admin_middleware.dart';
import 'package:myecl/tools/middlewares/authenticated_middleware.dart';
import 'package:qlevar_router/qlevar_router.dart';

class RaffleRouter {
  final ProviderRef ref;
  static const String root = '/raffle';
  static const String admin = '/admin';
  static const String addEditLot = '/add_edit_lot';
  static const String addEditTypeTicket = '/add_edit_type_ticket';
  static const String tombola = '/tombola';
  static final Module module = Module(
      name: "Tombola",
      icon: HeroIcons.gift,
      root: RaffleRouter.root,
      selected: false);
  RaffleRouter(this.ref);

  QRoute route() => QRoute(
        path: RaffleRouter.root,
        builder: () => const RaffleMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: [
          QRoute(path: admin, builder: () => const AdminPage(), middleware: [
            AdminMiddleware(ref, isTombolaAdminProvider),
          ], children: [
            QRoute(path: addEditLot, builder: () => const AddEditLotPage()),
            QRoute(
                path: addEditTypeTicket,
                builder: () => const AddEditTypeTicketSimplePage()),
          ]),
          QRoute(path: tombola, builder: () => const TombolaInfoPage()),
        ],
      );
}