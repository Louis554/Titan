import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/ph/providers/is_ph_admin_provider.dart';
import 'package:myecl/ph/providers/ph_list_provider.dart';
import 'package:myecl/ph/providers/ph_pdf_provider.dart';
import 'package:myecl/ph/providers/ph_pdfs_provider.dart';
import 'package:myecl/ph/router.dart';
import 'package:myecl/ph/tools/constants.dart';
import 'package:myecl/ph/ui/button.dart';
import 'package:myecl/ph/ui/pages/ph.dart';
import 'package:myecl/tools/ui/builders/async_child.dart';
import 'package:myecl/tools/ui/builders/auto_loader_child.dart';
import 'package:myecl/tools/ui/widgets/admin_button.dart';
import 'package:pdfx/pdfx.dart';
import 'package:qlevar_router/qlevar_router.dart';

class PhMainPage extends HookConsumerWidget {
  const PhMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isPhAdminProvider);
    final phList = ref.watch(phListProvider);
    final phPdfNotifier = ref.watch(phPdfProvider.notifier);
    return PhTemplate(
      child: Column(
        children: [
          if (isAdmin)
            SizedBox(
              width: 116.7,
              child: AdminButton(
                onTap: () {
                  QR.to(PhRouter.root + PhRouter.admin);
                },
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            child: GestureDetector(
              onTap: () {
                QR.to(PhRouter.root + PhRouter.past_ph_selection);
              },
              child: const MyButton(
                text: PhTextConstants.seePreviousJournal,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AsyncChild(
            value: phList,
            builder: (context, phs) {
              phs.sort((b, a) => a.date.compareTo(b.date));
              if (phs.isEmpty) {
                return const Text(PhTextConstants.noJournalInDatabase);
              } else {
                final id = phs.last.id;
                final lastPdf =
                    ref.watch(phPdfsProvider.select((map) => map[id]));
                final pdfsNotifier = ref.read(phPdfsProvider.notifier);

                return Expanded(
                  child: AutoLoaderChild(
                    group: lastPdf,
                    notifier: pdfsNotifier,
                    mapKey: id,
                    loader: (id) => phPdfNotifier.loadPhPdf(id),
                    dataBuilder: (context, pdf) => PdfView(
                      pageSnapping: false,
                      controller: PdfController(
                        document: PdfDocument.openData(pdf.last),
                      ),
                      scrollDirection: kIsWeb ? Axis.vertical : Axis.horizontal,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
