import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:myecl/amap/router.dart';
import 'package:myecl/amap/tools/constants.dart';
import 'package:myecl/tools/ui/top_bar.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AmapTemplate extends StatelessWidget {
  final Widget child;
  const AmapTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              TopBar(
                title: AMAPTextConstants.amap,
                root: AmapRouter.root,
                rightIcon: QR.currentPath == AmapRouter.root
                    ? IconButton(
                        onPressed: () {
                          QR.to(AmapRouter.root + AmapRouter.presentation);
                        },
                        icon: const HeroIcon(
                          HeroIcons.informationCircle,
                          color: Colors.black,
                          size: 40,
                        ))
                    : null,
              ),
              Expanded(child: child)
            ],
          ),
        ),
      ),
    );
  }
}
