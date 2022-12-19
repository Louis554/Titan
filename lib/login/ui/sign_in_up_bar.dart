import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myecl/tools/constants.dart';

class SignUpBar extends StatelessWidget {
  const SignUpBar({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPressed,
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Icon(
                            FontAwesomeIcons.rightLong,
                            color: Colors.white,
                            size: 24.0,
                          ),
                  ),
                ],
              ),
            )));
  }
}

class SignInBar extends StatelessWidget {
  const SignInBar(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.isLoading})
      : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: ColorConstants.background2),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: ColorConstants.gradient2,
                    )
                  : const Icon(
                      FontAwesomeIcons.rightLong,
                      color: ColorConstants.gradient2,
                      size: 24.0,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
