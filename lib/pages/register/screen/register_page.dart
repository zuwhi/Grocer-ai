import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:green_cart_scanner/model/login/login_params.dart';
import 'package:green_cart_scanner/pages/login/screen/login_page.dart';
import 'package:green_cart_scanner/pages/register/provider/form_validation_register.dart';
import 'package:green_cart_scanner/pages/register/provider/register_provider.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/custom_textformfield_grey_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  final TextEditingController _alamatC = TextEditingController();
  final TextEditingController _teleponC = TextEditingController();
  final String _roleC = 'user';
  bool showPass = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _imagePick;

  bool isload = false;

  @override
  void dispose() {
    super.dispose();
    _emailC.dispose();
    _passC.dispose();
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imagePick = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
        title: const CustomTextStyle(
          text: 'Register',
          fontsize: 21,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: AppColor.primary,
          ),
          ListView(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: getImage,
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      height: 80,
                      child: _imagePick != null
                          ? Image.file(
                              File(_imagePick!.path),
                            )
                          : Image.asset(
                              'assets/images/profil.jpg',
                            ),
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Consumer(builder: (context, wiRef, child) {
                  var formValidate = wiRef.watch(formValidateRegisterProvider);
                  print("form di build ulang ? ");
                  return Form(
                      child: Column(
                    children: [
                      CustomTextFormFieldGrey(
                        controller: _nameC,
                        name: 'Nama',
                        hintText: "Masukkan nama",
                        prefixIcon: Icons.person,
                        onChanged: (value) {
                          formValidate.validatorUsername(value);
                        },
                        errorText: formValidate.errorUsername,
                      ),
                      CustomTextFormFieldGrey(
                        controller: _emailC,
                        name: 'Email',
                        hintText: "Masukkan Email",
                        prefixIcon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        errorText: formValidate.errorEmail,
                        onChanged: (value) {
                          formValidate.validatorEmail(value);
                        },
                      ),
                      CustomTextFormFieldGrey(
                        controller: _passC,
                        name: 'Password',
                        hintText: "Masukkan Password",
                        prefixIcon: Icons.lock,
                        inputType: TextInputType.text,
                        errorText: formValidate.errorPassword,
                        obscureText: showPass ? true : false,
                        onChanged: (value) {
                          formValidate.validatorPassword(value);
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
                      CustomTextFormFieldGrey(
                          controller: _alamatC,
                          name: 'Alamat',
                          hintText: "Masukkan Alamat",
                          prefixIcon: Icons.location_on),
                      CustomTextFormFieldGrey(
                        controller: _teleponC,
                        inputType: TextInputType.number,
                        name: 'Telepon',
                        hintText: "Masukkan nomer telepon",
                        prefixIcon: Icons.phone,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      formValidate.isValidUsername &&
                              formValidate.isValidEmail &&
                              formValidate.isValidPassword
                          ? Consumer(builder: (context, buttonRef, child) {
                              print("button di build ulang ? ");
                              return ButtonFullWidth(
                                isload: isload,
                                onPressed: () async {
                                  setState(() {
                                    isload = true;
                                  });
                                  AccountModel accountRegist = AccountModel(
                                      name: _nameC.text,
                                      email: _emailC.text,
                                      password: _passC.text,
                                      role: _roleC,
                                      alamat: _alamatC.text,
                                      telepon: _teleponC.text,
                                      image: _imagePick);

                                  Either<String, LoginParams> result =
                                      await buttonRef
                                          .watch(
                                              registerNotifierProvider.notifier)
                                          .createAccount(accountRegist);
                                  Logger().d(
                                      "cek result is right di register page ${result.isRight()}");

                                  CustomSnackbar.show(
                                    context,
                                    message: result.fold(
                                        (l) => l,
                                        (r) =>
                                            "berhasil Membuat Akun silahkan login"),
                                    colors: (result.isRight())
                                        ? Colors.teal
                                        : Colors.red,
                                  );

                                  result.fold(
                                      (l) => null,
                                      (r) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage(loginParams: r))));

                                  setState(() {
                                    isload = false;
                                  });
                                },
                                title: "Register",
                              );
                            })
                          : ButtonFullWidth(
                              onPressed: () {},
                              title: "Register",
                              textColor: Colors.grey,
                              warna: AppColor.primary.withOpacity(0.5),
                            )
                    ],
                  ));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
