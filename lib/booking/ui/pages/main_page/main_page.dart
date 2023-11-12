import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/booking/class/booking.dart';
import 'package:myecl/booking/providers/booking_list_provider.dart';
import 'package:myecl/booking/providers/booking_provider.dart';
import 'package:myecl/booking/providers/confirmed_booking_list_provider.dart';
import 'package:myecl/booking/providers/is_admin_provider.dart';
import 'package:myecl/booking/providers/is_manager_provider.dart';
import 'package:myecl/booking/providers/selected_days_provider.dart';
import 'package:myecl/booking/providers/user_booking_list_provider.dart';
import 'package:myecl/booking/router.dart';
import 'package:myecl/booking/tools/constants.dart';
import 'package:myecl/booking/ui/booking.dart';
import 'package:myecl/booking/ui/booking_card.dart';
import 'package:myecl/booking/ui/calendar/calendar.dart';
import 'package:myecl/tools/constants.dart';
import 'package:myecl/tools/functions.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';
import 'package:myecl/tools/ui/dialog.dart';
import 'package:myecl/tools/ui/refresher.dart';
import 'package:myecl/tools/ui/web_list_view.dart';
import 'package:qlevar_router/qlevar_router.dart';

class BookingMainPage extends HookConsumerWidget {
  const BookingMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isManager = ref.watch(isManagerProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final bookingsNotifier = ref.watch(userBookingListProvider.notifier);
    final confirmedbookingsNotifier =
        ref.watch(confirmedBookingListProvider.notifier);
    final bookings = ref.watch(userBookingListProvider);
    final allBookingsNotifier = ref.watch(bookingListProvider.notifier);
    final bookingNotifier = ref.watch(bookingProvider.notifier);
    final selectedDaysNotifier = ref.watch(selectedDaysProvider.notifier);

    void displayToastWithContext(TypeMsg type, String message) {
      displayToast(context, type, message);
    }

    return BookingTemplate(
      child: Refresher(
        onRefresh: () async {
          await confirmedbookingsNotifier.loadConfirmedBooking();
          await bookingsNotifier.loadUserBookings();
        },
        child: Column(children: [
          if (isAdmin | isManager) const SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (isAdmin)
                  GestureDetector(
                    onTap: () {
                      QR.to(BookingRouter.root + BookingRouter.admin);
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5))
                          ]),
                      child: const Row(
                        children: [
                          HeroIcon(HeroIcons.userGroup,
                              color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text("Admin",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                if (isManager)
                  GestureDetector(
                    onTap: () {
                      QR.to(BookingRouter.root + BookingRouter.manager);
                    },
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5))
                          ]),
                      child: const Row(
                        children: [
                          HeroIcon(HeroIcons.userGroup,
                              color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text("Gestion",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 400, child: Calendar(isManagerPage: false)),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                BookingTextConstants.myBookings,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 149, 149, 149),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          bookings.when(data: (List<Booking> data) {
            data.sort((a, b) => b.start.compareTo(a.start));
            return SizedBox(
                height: 210,
                child: HorizontalListView(
                    child: Row(children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      onTap: () {
                        bookingNotifier.setBooking(Booking.empty());
                        selectedDaysNotifier.clear();
                        QR.to(BookingRouter.root + BookingRouter.addEdit);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: 120,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                              child: HeroIcon(
                            HeroIcons.plus,
                            size: 40.0,
                            color: Colors.black,
                          )),
                        ),
                      ),
                    ),
                  ),
                  ...data.map((e) => BookingCard(
                        booking: e,
                        isAdmin: false,
                        isDetail: false,
                        onEdit: () {
                          bookingNotifier.setBooking(e);
                          final recurrent = e.recurrenceRule != "";
                          if (recurrent) {
                            final allDays = [
                              "MO",
                              "TU",
                              "WE",
                              "TH",
                              "FR",
                              "SA",
                              "SU"
                            ];
                            final recurrentDays = e.recurrenceRule
                                .split(";")
                                .where((element) => element.contains("BYDAY"))
                                .first
                                .split("=")
                                .last
                                .split(",");
                            selectedDaysNotifier.setSelectedDays(allDays
                                .map((e) => recurrentDays.contains(e))
                                .toList());
                          }
                          QR.to(BookingRouter.root + BookingRouter.addEdit);
                        },
                        onInfo: () {
                          bookingNotifier.setBooking(e);
                          QR.to(BookingRouter.root + BookingRouter.detail);
                        },
                        onConfirm: () {},
                        onDecline: () {},
                        onDelete: () async {
                          await tokenExpireWrapper(ref, () async {
                            await showDialog(
                                context: context,
                                builder: (context) => CustomDialogBox(
                                      descriptions: BookingTextConstants
                                          .deleteBookingConfirmation,
                                      onYes: () async {
                                        final value = await allBookingsNotifier
                                            .deleteBooking(e);
                                        if (value) {
                                          bookingsNotifier.deleteBooking(e);
                                          if (e.decision == Decision.approved) {
                                            confirmedbookingsNotifier
                                                .deleteBooking(e);
                                          }

                                          displayToastWithContext(
                                              TypeMsg.msg,
                                              BookingTextConstants
                                                  .deleteBooking);
                                        } else {
                                          displayToastWithContext(
                                              TypeMsg.error,
                                              BookingTextConstants
                                                  .deletingError);
                                        }
                                      },
                                      title: BookingTextConstants.deleteBooking,
                                    ));
                          });
                        },
                        onCopy: () {
                          bookingNotifier.setBooking(e.copyWith(id: ""));
                          final recurrent = e.recurrenceRule != "";
                          if (recurrent) {
                            final allDays = [
                              "MO",
                              "TU",
                              "WE",
                              "TH",
                              "FR",
                              "SA",
                              "SU"
                            ];
                            final recurrentDays = e.recurrenceRule
                                .split(";")
                                .where((element) => element.contains("BYDAY"))
                                .first
                                .split("=")
                                .last
                                .split(",");
                            selectedDaysNotifier.setSelectedDays(allDays
                                .map((e) => recurrentDays.contains(e))
                                .toList());
                          }
                          QR.to(BookingRouter.root + BookingRouter.addEdit);
                        },
                      )),
                  const SizedBox(width: 15)
                ])));
          }, error: (Object error, StackTrace? stackTrace) {
            return Center(child: Text("Error $error"));
          }, loading: () {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorConstants.background2,
            ));
          }),
        ]),
      ),
    );
  }
}
