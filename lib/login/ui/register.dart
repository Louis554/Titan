import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/auth/providers/openid_provider.dart';
import 'package:myecl/login/class/account_type.dart';
import 'package:myecl/login/providers/sign_up_provider.dart';
import 'package:myecl/login/tools/constants.dart';
import 'package:myecl/login/tools/functions.dart';
import 'package:myecl/login/ui/sign_in_up_bar.dart';
import 'package:myecl/login/ui/text_from_decoration.dart';
import 'package:myecl/tools/functions.dart';

class Register extends HookConsumerWidget {
  const Register(
      {Key? key, required this.onSignInPressed, required this.onMailRecieved})
      : super(key: key);

  final VoidCallback onSignInPressed, onMailRecieved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNotifier = ref.watch(signUpProvider.notifier);
    final mail = useTextEditingController();
    final password = useTextEditingController();
    final hidePass = useState(true);
    void displayLoginToastWithContext(TypeMsg type, String msg) {
      displayLoginToast(context, type, msg);
    }

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onSignInPressed,
                child: const HeroIcon(
                  HeroIcons.chevronLeft,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  LoginTextConstants.createAccountTitle,
                  style: GoogleFonts.elMessiri(
                      textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                          controller: mail,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          decoration: signInRegisterInputDecoration(
                              isSignIn: false,
                              hintText: LoginTextConstants.email))),
                  const SizedBox(
                    height: 30,
                  ),
                  SignUpBar(
                    label: LoginTextConstants.create,
                    isLoading: ref.watch(loadingrovider),
                    onPressed: () async {
                      final value = await signUpNotifier.createUser(
                          mail.text, password.text, AccountType.student);
                      if (value) {
                        displayLoginToastWithContext(
                            TypeMsg.msg, LoginTextConstants.sendedMail);
                        hidePass.value = true;
                        mail.clear();
                        password.clear();
                        onSignInPressed();
                      } else {
                        displayLoginToastWithContext(
                            TypeMsg.error, LoginTextConstants.mailSendingError);
                      }
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            splashColor: const Color.fromRGBO(255, 255, 255, 1),
                            onTap: () {
                              onSignInPressed();
                            },
                            child: const Text(
                              LoginTextConstants.signIn,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          )),
                      Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            splashColor: const Color.fromRGBO(255, 255, 255, 1),
                            onTap: () {
                              onMailRecieved();
                            },
                            child: const Text(
                              LoginTextConstants.recievedMail,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
