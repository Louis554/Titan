import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/tombola/providers/raffle_list_provider.dart';
import 'package:myecl/tombola/providers/user_tickets_provider.dart';
import 'package:myecl/tombola/router.dart';
import 'package:tuple/tuple.dart';

final Map<String, Tuple2<String, List<StateNotifierProvider>>> raffleProviders =
    {
  "raffles": Tuple2(
    RaffleRouter.root,
    [raffleListProvider],
  ),
  "tickets": Tuple2(
    RaffleRouter.root,
    [userTicketListProvider],
  ),
};
