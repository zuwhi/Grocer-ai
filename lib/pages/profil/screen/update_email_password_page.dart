import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/model/session/session_params.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/navigator/screen/navigator_page.dart';
import 'package:green_cart_scanner/pages/profil/provider/profil_provider.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_form_field.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:quickalert/quickalert.dart';

class UpdateEmailPasswordPage extends ConsumerStatefulWidget {
  final AccountModel account;
  const UpdateEmailPasswordPage(this.account, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateEmailPasswordPageState();
}

class _UpdateEmailPasswordPageState
    extends ConsumerState<UpdateEmailPasswordPage> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _oldPasswordC = TextEditingController();
  final TextEditingController _newPasswordC = TextEditingController();
  bool isLoad = false;
  bool isUpdatePassword = false;
  bool showPass = true;
  bool showPass2 = true;

  @override
  Widget build(BuildContext context) {
    SessionState sessionState = ref.watch(sessionNotifierProvider);
    var akun = widget.account;
    _emailC.text = akun.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Email and Password"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomTextFormField(
                controller: _emailC,
                name: 'email',
                prefixIcon: Icons.email,
                inputType: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                controller: _oldPasswordC,
                name: 'old password',
                prefixIcon: Icons.password,
                inputType: TextInputType.text,
                obscureText: showPass ? false : true,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    icon: Icon(
                      showPass
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      size: 18,
                    )),
              ),
              isUpdatePassword
                  ? CustomTextFormField(
                      controller: _newPasswordC,
                      name: 'new password',
                      prefixIcon: Icons.password,
                      inputType: TextInputType.text,
                      obscureText: showPass2 ? false : true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass2 = !showPass2;
                            });
                          },
                          icon: Icon(
                            showPass2
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined,
                            size: 18,
                          )),
                    )
                  : Container(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    onPressed: () {
                      isUpdatePassword = !isUpdatePassword;
                      setState(() {});
                    },
                    child: CustomTextStyle(
                      text: isUpdatePassword
                          ? "Hanya ubah email ?"
                          : "ubah Password ?",
                      color: AppColor.primary,
                      fontsize: 16,
                    )),
              ),
              const SizedBox(
                height: 5.0,
              ),
              ButtonFullWidth(
                  isload: isLoad,
                  onPressed: () async {
                    setState(() {
                      isLoad = true;
                    });

                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        title: 'Loading',
                        text: 'proses edit profil..',
                        disableBackBtn: true);
                    LoginParams loginParams = LoginParams(
                        email: _emailC.text,
                        password: _oldPasswordC.text,
                        newPassword: _newPasswordC.text);
                    Either<String, bool> result = await ref
                        .watch(profilNotifierProvider.notifier)
                        .updateEmailAndPassword(loginParams: loginParams);

                    result.fold(
                        (l) => CustomSnackbar.show(context,
                            message: l, colors: Colors.red), (r) async {
                      CustomSnackbar.show(context,
                          message: "berhasil update email dan password",
                          colors: AppColor.primary);

                      SessionParams sessionParams = SessionParams(
                          sessionId: sessionState.sessionId ?? '',
                          accountId: sessionState.account?.id ?? '');
                      await ref
                          .watch(sessionNotifierProvider.notifier)
                          .findAccount(sessionParams: sessionParams);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigatorPage(
                              targetPage: 4,
                            ),
                          ));
                    });

                    setState(() {
                      isLoad = false;
                    });

                    Navigator.pop(context);
                  },
                  title: 'Update Email and Password')
            ],
          ),
        ),
      ),
    );
  }
}
