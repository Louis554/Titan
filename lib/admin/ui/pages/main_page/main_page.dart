import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/admin/providers/group_id_provider.dart';
import 'package:myecl/admin/providers/group_provider.dart';
import 'package:myecl/admin/providers/group_list_provider.dart';
import 'package:myecl/admin/providers/settings_page_provider.dart';
import 'package:myecl/admin/ui/pages/main_page/asso_ui.dart';
import 'package:myecl/loan/providers/loaner_list_provider.dart';
import 'package:myecl/admin/tools/constants.dart';
import 'package:myecl/tools/constants.dart';
import 'package:myecl/tools/dialog.dart';
import 'package:myecl/tools/functions.dart';
import 'package:myecl/tools/refresher.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';
import 'package:myecl/user/providers/user_list_provider.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(allGroupListProvider);
    final groupsNotifier = ref.watch(allGroupListProvider.notifier);
    final pageNotifier = ref.watch(adminPageProvider.notifier);
    final groupNotifier = ref.watch(groupProvider.notifier);
    final groupIdNotifier = ref.watch(groupIdProvider.notifier);
    final loans = ref.watch(loanerList);
    final loanListNotifier = ref.watch(loanerListProvider.notifier);
    ref.watch(userList);
    void displayToastWithContext(TypeMsg type, String msg) {
      displayToast(context, type, msg);
    }

    final loanersId = loans.map((e) => e.groupManagerId).toList();

    return Refresher(
      onRefresh: () async {
        await groupsNotifier.loadGroups();
        await loanListNotifier.loadLoanerList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: groups.when(data: (g) {
          return Column(children: [
            //   const Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(AdminTextConstants.association,
            //         style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w700,
            //             color: ColorConstants.gradient1)),
            //   ),
            // const SizedBox(
            //   height: 20,
            // ),
            // GridView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: g.length + 2,
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 10,
            //         mainAxisSpacing: 10,
            //         childAspectRatio: .7),
            //     itemBuilder: (context, index) {
            //       if (index == 0) {
            //         return GestureDetector(
            //             onTap: () {
            //               pageNotifier.setAdminPage(AdminPage.addAsso);
            //             },
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: [
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 Container(
            //                   padding: const EdgeInsets.all(30),
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color:
            //                               Colors.grey.shade300.withOpacity(0.5),
            //                           spreadRadius: 5,
            //                           blurRadius: 7,
            //                           offset: const Offset(0, 3),
            //                         ),
            //                       ],
            //                       borderRadius: BorderRadius.circular(100)),
            //                   child: const HeroIcon(
            //                     HeroIcons.plus,
            //                     size: 60,
            //                   ),
            //                 ),
            //                 const SizedBox(
            //                   height: 15,
            //                 ),
            //                 const Text(
            //                   AdminTextConstants.add,
            //                   style: TextStyle(
            //                       fontSize: 20, fontWeight: FontWeight.w700),
            //                 ),
            //               ],
            //             ));
            //       } else if (index == 1) {
            //         return GestureDetector(
            //             onTap: () {
            //               pageNotifier.setAdminPage(AdminPage.addLoaner);
            //             },
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: [
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 Stack(
            //                   children: [
            //                     Container(
            //                       padding: const EdgeInsets.all(30),
            //                       decoration: BoxDecoration(
            //                           color: Colors.white,
            //                           boxShadow: [
            //                             BoxShadow(
            //                               color: Colors.grey.shade300
            //                                   .withOpacity(0.5),
            //                               spreadRadius: 5,
            //                               blurRadius: 7,
            //                               offset: const Offset(0, 3),
            //                             ),
            //                           ],
            //                           borderRadius: BorderRadius.circular(100)),
            //                       child: const HeroIcon(
            //                         HeroIcons.buildingLibrary,
            //                         size: 60,
            //                       ),
            //                     ),
            //                     const Positioned(
            //                       right: 22,
            //                       top: 22,
            //                       child: HeroIcon(
            //                         HeroIcons.plus,
            //                         size: 25,
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //                 const SizedBox(
            //                   height: 15,
            //                 ),
            //                 const Text(
            //                   AdminTextConstants.add,
            //                   style: TextStyle(
            //                       fontSize: 20, fontWeight: FontWeight.w700),
            //                 ),
            //               ],
            //             ));
            //       }
            //       final group = g[index - 2];
            //       return AssoUi(
            //         group: group,
            //         isLoaner: loanersId.contains(group.id),
            //         onTap: () async {
            //           groupIdNotifier.setId(group.id);
            //           tokenExpireWrapper(ref, () async {
            //             await groupNotifier.loadGroup(group.id);
            //             pageNotifier.setAdminPage(AdminPage.asso);
            //           });
            //         },
            //         onEdit: () {
            //           groupIdNotifier.setId(group.id);
            //           tokenExpireWrapper(ref, () async {
            //             await groupNotifier.loadGroup(group.id);
            //             pageNotifier.setAdminPage(AdminPage.edit);
            //           });
            //         },
            //         onDelete: () {
            //           showDialog(
            //               context: context,
            //               builder: (context) {
            //                 return CustomDialogBox(
            //                   title: AdminTextConstants.deleting,
            //                   descriptions:
            //                       AdminTextConstants.deleteAssociation,
            //                   onYes: () async {
            //                     tokenExpireWrapper(ref, () async {
            //                       final value =
            //                           await groupsNotifier.deleteGroup(group);
            //                       if (value) {
            //                         displayToastWithContext(TypeMsg.msg,
            //                             AdminTextConstants.deletedAssociation);
            //                       } else {
            //                         displayToastWithContext(TypeMsg.error,
            //                             AdminTextConstants.deletingError);
            //                       }
            //                     });
            //                   },
            //                 );
            //               });
            //         },
            //       );
            //     }),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    pageNotifier.setAdminPage(AdminPage.addAsso);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        Spacer(),
                        HeroIcon(
                          HeroIcons.plus,
                          color: Colors.grey.shade700,
                          size: 40,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageNotifier.setAdminPage(AdminPage.addLoaner);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        Spacer(),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            HeroIcon(
                              HeroIcons.buildingLibrary,
                              color: Colors.grey.shade700,
                              size: 40,
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: HeroIcon(
                                HeroIcons.plus,
                                size: 15,
                                color: Colors.grey.shade700,
                              ),
                            )
                          ],
                        ),
                        Spacer()
                      ],
                    ),
                    // const SizedBox(
                    //   width: 15,
                    // ),
                    // const Expanded(
                    //   child: Text(
                    //     AdminTextConstants.addLoaningAssociation,
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ),
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Container(
                //       padding: const EdgeInsets.all(30),
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.grey.shade300.withOpacity(0.5),
                //               spreadRadius: 5,
                //               blurRadius: 7,
                //               offset: const Offset(0, 3),
                //             ),
                //           ],
                //           borderRadius: BorderRadius.circular(100)),
                //       child: const HeroIcon(
                //         HeroIcons.plus,
                //         size: 60,
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 15,
                //     ),
                //     const Text(
                //       AdminTextConstants.add,
                //       style: TextStyle(
                //           fontSize: 20, fontWeight: FontWeight.w700),
                //     ),
                //   ],
                // ),
                // )),
                ...g
                    .map((group) => AssoUi(
                          group: group,
                          isLoaner: loanersId.contains(group.id),
                          onTap: () async {
                            groupIdNotifier.setId(group.id);
                            tokenExpireWrapper(ref, () async {
                              await groupNotifier.loadGroup(group.id);
                              pageNotifier.setAdminPage(AdminPage.asso);
                            });
                          },
                          onEdit: () {
                            groupIdNotifier.setId(group.id);
                            tokenExpireWrapper(ref, () async {
                              await groupNotifier.loadGroup(group.id);
                              pageNotifier.setAdminPage(AdminPage.edit);
                            });
                          },
                          onDelete: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogBox(
                                    title: AdminTextConstants.deleting,
                                    descriptions:
                                        AdminTextConstants.deleteAssociation,
                                    onYes: () async {
                                      tokenExpireWrapper(ref, () async {
                                        final value = await groupsNotifier
                                            .deleteGroup(group);
                                        if (value) {
                                          displayToastWithContext(
                                              TypeMsg.msg,
                                              AdminTextConstants
                                                  .deletedAssociation);
                                        } else {
                                          displayToastWithContext(TypeMsg.error,
                                              AdminTextConstants.deletingError);
                                        }
                                      });
                                    },
                                  );
                                });
                          },
                        ))
                    .toList(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ]);
        }, error: (e, s) {
          return Text(e.toString());
        }, loading: () {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorConstants.gradient1),
          ));
        }),
      ),
    );
  }
}
