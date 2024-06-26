import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/constant/route.dart';
import 'package:green_cart_scanner/model/account/account_model.dart';
import 'package:green_cart_scanner/model/session/session_params.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/navigator/widgets/not_login_widget.dart';
import 'package:green_cart_scanner/pages/profil/provider/profil_provider.dart';
import 'package:green_cart_scanner/pages/profil/screen/update_email_password_page.dart';
import 'package:green_cart_scanner/widgets/ImageCacheNetwork_widget.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_textformfield_grey_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:quickalert/quickalert.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _alamatC = TextEditingController();
  final TextEditingController _teleponC = TextEditingController();
  bool isCanEdit = true;
  bool isLoad = false;

  bool buttonCanEdit = false;
  @override
  void initState() {
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _imagePick;
  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imagePick = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    SessionState sessionState = ref.watch(sessionNotifierProvider);

    if (sessionState.account == null) {
      return const Scaffold(
        body: LoadingWidgets(),
      );
    }
    AccountModel account = sessionState.account!;

    void checkIsUpdate() {
      if (_nameC.text != account.name ||
          _alamatC.text != account.alamat ||
          _teleponC.text != account.telepon ||
          _imagePick != null) {
        setState(() {
          buttonCanEdit = true;
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profil page"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  QuickAlert.show(
                    // headerBackgroundColor: AppColor.primary,
                    context: context,
                    type: QuickAlertType.confirm,
                    title: "Konfirmasi",
                    text: 'Apakah kamu ingin logout ?',
                    confirmBtnText: 'Iya',
                    cancelBtnText: 'Tidak',
                    confirmBtnColor: AppColor.primary,
                    onConfirmBtnTap: () async {
                      Navigator.pop(context);
                      setState(() {
                        isLoad = true;
                      });

                      Either<String, bool> sessionDestroyResult = await ref
                          .watch(sessionNotifierProvider.notifier)
                          .destroySessionState();

                      sessionDestroyResult.fold(
                        (l) {
                          Logger().d(l);
                        },
                        (r) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, NameRoute.splash, (route) => false);
                        },
                      );

                      setState(() {
                        isLoad = false;
                      });
                    },
                  );
                },
                icon: const Icon(Icons.logout)),
            const SizedBox(
              width: 15.0,
            ),
          ],
        ),
        body: Consumer(
          builder: (context, wiRef, child) {
            if (sessionState.status == StatusCondition.success) {
              _nameC.text = account.name ?? '';
              _alamatC.text = account.alamat ?? '';
              _teleponC.text = account.telepon ?? '';

              return isLoad
                  ? const LoadingWidgets()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SizedBox(
                                      height: 90,
                                      child: _imagePick != null
                                          ? Image.file(
                                              File(_imagePick!.path),
                                            )
                                          : account.image != ""
                                              ? CustomImageCacheNetwork(
                                                  url: account.image ?? '')
                                              : Image.asset(
                                                  'assets/images/profil.jpg'))),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            CustomTextFormFieldGrey(
                              controller: _nameC,
                              name: 'name',
                              prefixIcon: Icons.person,
                              onChanged: (e) {},
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            CustomTextFormFieldGrey(
                                controller: _alamatC,
                                name: 'Alamat',
                                prefixIcon: Icons.location_on),
                            const SizedBox(
                              height: 5.0,
                            ),
                            CustomTextFormFieldGrey(
                                controller: _teleponC,
                                name: 'Telepon',
                                prefixIcon: Icons.phone),
                            const SizedBox(
                              height: 35.0,
                            ),
                            Consumer(
                              builder: (context, buttonRef, child) {
                                return ButtonFullWidth(
                                    isload: isLoad,
                                    onPressed: () async {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.loading,
                                          title: 'Loading',
                                          text: 'proses edit profil..',
                                          disableBackBtn: true);

                                      AccountModel userObj = AccountModel(
                                          id: account.id,
                                          name: _nameC.text,
                                          email: '',
                                          password: '',
                                          role: 'user',
                                          alamat: _alamatC.text,
                                          telepon: _teleponC.text,
                                          image: _imagePick ?? account.image,
                                          fileId: account.fileId);

                                      Either<String, bool> result =
                                          await buttonRef
                                              .watch(profilNotifierProvider
                                                  .notifier)
                                              .updateAccount(account: userObj);
                                      Logger().d("after edit account");
                                      if (result.isRight()) {
                                        SessionParams sessionParams =
                                            SessionParams(
                                                sessionId:
                                                    sessionState.sessionId ??
                                                        '',
                                                accountId: userObj.id ?? '');

                                        Logger().d(sessionParams);
                                        await buttonRef
                                            .watch(sessionNotifierProvider
                                                .notifier)
                                            .findAccount(
                                                sessionParams: sessionParams);
                                        Logger().d("after find account");
                                      }

                                      CustomSnackbar.show(context,
                                          message: result.fold((l) => l,
                                              (r) => "berhasil update "),
                                          colors: result.isRight()
                                              ? Colors.teal
                                              : Colors.red);

                                      Navigator.pop(context);
                                    },
                                    title: 'Edit Profil');
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextButton(
                                onPressed: () {
                                  var akun = AccountModel(
                                      id: account.id,
                                      name: '',
                                      email: account.email,
                                      password: '',
                                      role: account.role);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateEmailPasswordPage(akun),
                                      ));
                                },
                                child: const Text('Edit Email and Password'))
                          ],
                        ),
                      ),
                    );
            }

            if (sessionState.status == StatusCondition.empty) {
              return const NotLoginWidgetPage();
            }
            if (sessionState.status == StatusCondition.loading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingWidgets(),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return isLoad
            ? const LoadingWidgets()
            : AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('yakin mau logout?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Iya'),
                    onPressed: () async {
                      setState(() {
                        isLoad = true;
                      });
                      Either<String, bool> sessionDestroyResult = await ref
                          .watch(sessionNotifierProvider.notifier)
                          .destroySessionState();

                      sessionDestroyResult.fold(
                        (l) {
                          Logger().d(l);
                        },
                        (r) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, NameRoute.splash, (route) => false);
                        },
                      );

                      setState(() {
                        isLoad = false;
                      });
                    },
                  ),
                ],
              );
      },
    );
  }
}
