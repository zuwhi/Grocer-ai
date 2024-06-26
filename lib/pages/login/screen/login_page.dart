import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/constant/route.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/pages/item/provider/items_online/items_appwrite.dart';
import 'package:green_cart_scanner/pages/login/provider/form_validate.dart';
import 'package:green_cart_scanner/pages/login/provider/login_provider.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/custom_textformfield_grey_widgets.dart';
import 'package:green_cart_scanner/widgets/oval_clip_widgets.dart';
import 'package:logger/logger.dart';

class LoginPage extends ConsumerStatefulWidget {
  final LoginParams? loginParams;
  const LoginPage({super.key, this.loginParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool showPass = false;
  bool isLoad = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.loginParams != null) {
        emailTextController.text = widget.loginParams!.email;
        passwordTextController.text = widget.loginParams!.password;
        FormValidateLogin formValidate = ref.watch(formValidateProvider);
        formValidate.validatorUsername(emailTextController.text);
        formValidate.validatorNumber(passwordTextController.text);
      }
    });

    super.initState();
  }

  signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoadingWidgets(),
                ]),
          );
        });
  }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (context, wiRef, child) {
          FormValidateLogin formValidate = wiRef.watch(formValidateProvider);

          return formValidate.isLoad
              ? const LoadingWidgets()
              : Center(
                  child: Container(
                    child: Stack(
                      children: [
                        const OvalClipWidgets(
                          height: 380,
                          left: -270,
                          width: 820,
                        ),
                        Positioned(
                            right: 25,
                            top: 120,
                            child: SvgPicture.asset(
                              "assets/images/people.svg",
                              width: 230,
                            )),
                        const Positioned(
                          top: 200,
                          left: 20,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Login ',
                            style: TextStyle(
                              color: AppColor.grey6,
                              fontWeight: FontWeight.w600,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 18.0,
                              ),
                              CustomTextFormFieldGrey(
                                inputType: TextInputType.emailAddress,
                                controller: emailTextController,
                                name: "email",
                                hintText: "Masukkan emailmu",
                                prefixIcon: Icons.email_rounded,
                                errorText: formValidate.errorEmail,
                                onChanged: (value) {
                                  formValidate.validatorUsername(value);
                                },
                              ),
                              CustomTextFormFieldGrey(
                                controller: passwordTextController,
                                name: 'Password',
                                hintText: "Masukkan password",
                                prefixIcon: Icons.lock,
                                errorText: formValidate.errorPassword,
                                inputType: TextInputType.text,
                                obscureText: showPass ? false : true,
                                onChanged: (value) {
                                  formValidate.validatorNumber(value);
                                },
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
                              const SizedBox(height: 10),
                              formValidate.isValidEmail &&
                                      formValidate.isValidPassword
                                  ? Consumer(
                                      builder: (context, buttonRef, child) {
                                        return ButtonFullWidth(
                                          isload: isLoad,
                                          title: 'Login',
                                          onPressed: () async {
                                            setState(() {
                                              isLoad = true;
                                            });

                                            LoginParams loginParams =
                                                LoginParams(
                                                    email: emailTextController
                                                        .text,
                                                    password:
                                                        passwordTextController
                                                            .text);
                                            Either<String, bool> result =
                                                await buttonRef
                                                    .watch(loginNotifierProvider
                                                        .notifier)
                                                    .checkEmailAndPasswordProvider(
                                                        loginParams:
                                                            loginParams);

                                            Logger().d(
                                                "cek result is right di Login page ${result.isRight()}");

                                            // mendapatkan item saat telah login
                                            await buttonRef
                                                .read(itemsAppwriteProvider
                                                    .notifier)
                                                .getAllItems();

                                            CustomSnackbar.show(
                                              context,
                                              message: result.fold((l) => l,
                                                  (r) => "berhasil login"),
                                              colors: (result.isRight())
                                                  ? Colors.teal
                                                  : Colors.red,
                                            );

                                            setState(() {
                                              isLoad = false;
                                            });
                                            if (result.isRight()) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  NameRoute.navigator,
                                                  (route) => false);
                                            } else {
                                              Container();
                                            }
                                          },
                                        );
                                      },
                                    )
                                  : ButtonFullWidth(
                                      onPressed: () {},
                                      title: 'Login',
                                      warna: AppColor.primary.withOpacity(0.2),
                                    ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              ButtonFullWidth(
                                isDisable: isLoad,
                                warna: AppColor.primary2,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, NameRoute.register);
                                },
                                title: 'Register',
                              ),
                              isLoad
                                  ? const SizedBox(
                                      height: 42.0,
                                    )
                                  : TextButton(
                                      style: const ButtonStyle(
                                          elevation:
                                              MaterialStatePropertyAll(0),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.white),
                                          splashFactory:
                                              NoSplash.splashFactory),
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            NameRoute.navigator,
                                            (route) => false);
                                      },
                                      child: const CustomTextStyle(
                                        text: 'Sedang Offline? klik disini',
                                        color: AppColor.primary,
                                      )),
                              const SizedBox(
                                height: 105.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
