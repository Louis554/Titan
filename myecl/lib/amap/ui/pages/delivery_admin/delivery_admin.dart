import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/amap/class/delivery.dart';
import 'package:myecl/amap/providers/delivery_list_provider.dart';
import 'package:myecl/amap/providers/is_amap_admin_provider.dart';
import 'package:myecl/amap/tools/constants.dart';
import 'package:myecl/amap/ui/pages/delivery_admin/admin_delivery_ui.dart';
import 'package:myecl/amap/ui/refresh_indicator.dart';

class DeliveryAdminPage extends HookConsumerWidget {
  const DeliveryAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryList = ref.watch(deliveryListProvider);
    final deliveryListNotifier = ref.watch(deliveryListProvider.notifier);
    final isAmapAdmin = ref.watch(isAmapAdminProvider);
    List<Widget> listWidgetOrder = [];
    deliveryList.when(
      data: (orders) {
        orders.sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
        if (!isAmapAdmin) {
          orders = orders.where((element) => !element.locked).toList();
        }
        if (orders.isNotEmpty) {
          listWidgetOrder.addAll([
            const SizedBox(
              height: 30,
            ),
            const Text(
              AMAPTextConstants.deliveryList,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AMAPColorConstants.textDark,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]);
          for (Delivery c in orders) {
            listWidgetOrder.add(DeliveryAdminUi(c: c, i: c.id));
          }
        } else {
          listWidgetOrder.add(Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                alignment: Alignment.center,
                child: Text(
                  AMAPTextConstants.notPlannedDelivery,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ));
        }
      },
      error: (error, s) {
        listWidgetOrder.add(Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 70,
              alignment: Alignment.center,
              child: Text(
                error.toString(),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
      },
      loading: () {
        listWidgetOrder.add(
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AMAPColorConstants.textDark,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );

    return AmapRefresher(
        onRefresh: () async {
          await deliveryListNotifier.loadDeliveriesList();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(children: listWidgetOrder),
        ));
  }
}
