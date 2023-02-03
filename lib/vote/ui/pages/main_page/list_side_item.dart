import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/tools/dialog.dart';
import 'package:myecl/vote/class/pretendance.dart';
import 'package:myecl/vote/class/section.dart';
import 'package:myecl/vote/providers/section_id_provider.dart';
import 'package:myecl/vote/providers/sections_provider.dart';
import 'package:myecl/vote/providers/selected_pretendance_provider.dart';
import 'package:myecl/vote/providers/voted_section_provider.dart';
import 'package:myecl/vote/tools/constants.dart';
import 'package:myecl/vote/ui/pages/main_page/side_item.dart';

class ListSideItem extends HookConsumerWidget {
  final List<Section> sectionList;
  final AnimationController animation;
  const ListSideItem(
      {super.key, required this.sectionList, required this.animation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionIdNotifier = ref.watch(sectionIdProvider.notifier);
    final selectedPretendance = ref.watch(selectedPretendanceProvider);
    final selectedPretendanceNotifier =
        ref.watch(selectedPretendanceProvider.notifier);
    final section = ref.watch(sectionProvider);
    List<String> votedSections = [];
    ref.watch(votedSectionProvider).whenData((value) {
      votedSections = value;
    });
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: sectionList.map((e) {
          return SideItem(
            section: e,
            isSelected: e.id == section.id,
            alreadyVoted: votedSections.contains(e.id),
            onTap: () async {
              if (selectedPretendance.id == Pretendance.empty().id) {
                animation.forward(from: 0);
                sectionIdNotifier.setId(e.id);
              } else {
                showDialog(
                    context: context,
                    builder: (context) => CustomDialogBox(
                          title: VoteTextConstants.warning,
                          descriptions: VoteTextConstants.warningMessage,
                          onYes: () {
                            selectedPretendanceNotifier.clear();
                            animation.forward(from: 0);
                            sectionIdNotifier.setId(e.id);
                          },
                        ));
              }
            },
          );
        }).toList(),
      ),
    );
  }
}