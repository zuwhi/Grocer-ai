// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:green_cart_scanner/constant/appColor.dart';
import 'package:green_cart_scanner/constant/loading_app.dart';
import 'package:green_cart_scanner/model/post/posts.dart';
import 'package:green_cart_scanner/model/statusState/StatusCondition.dart';
import 'package:green_cart_scanner/pages/login/screen/login_page.dart';
import 'package:green_cart_scanner/pages/navigator/provider/session_provider.dart';
import 'package:green_cart_scanner/pages/navigator/screen/navigator_page.dart';
import 'package:green_cart_scanner/pages/posts/provider/posts_provider/posts_provider.dart';
import 'package:green_cart_scanner/pages/posts/widgets/text_form_quill.dart';
import 'package:green_cart_scanner/widgets/ImageCacheNetwork_widget.dart';
import 'package:green_cart_scanner/widgets/buttonfull_widget.dart';
import 'package:green_cart_scanner/widgets/custom_snackbar.dart';
import 'package:green_cart_scanner/widgets/custom_text_style.dart';
import 'package:green_cart_scanner/widgets/custom_textformfield_grey_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PostPage extends ConsumerStatefulWidget {
  final Posts? posts;
  const PostPage({
    super.key,
    this.posts,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final _formKey = GlobalKey<FormState>();
  Posts? posts;
  final TextEditingController _titleC = TextEditingController();
  String? selectedString;
  List<String>? initSelectItems;
  bool isEdit = false;
  String? imgUrl;
  final ImagePicker _picker = ImagePicker();
  bool isLoad = false;
  XFile? _imagePick;

  final QuillController _descC = QuillController.basic();

  @override
  void initState() {
    //pengecekan apakah post mempunyai data
    posts = widget.posts;
    if (posts != null) {
      final json = jsonDecode(posts!.desc!);

      isEdit = true;
      _titleC.text = posts!.title!;
      _descC.document = Document.fromJson(json);
      imgUrl = posts!.image;
      selectedString = posts!.category!;
      initSelectItems = selectedString?.split(", ");
    }
    super.initState();
  }

  List<String> items = ['kesehatan', 'berita', 'resep'];
  List<String> selectItems = [];

  @override
  Widget build(BuildContext context) {
    SessionState state = ref.watch(sessionNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text("${isEdit ? "Edit" : "Buat"} Artikel "),
          centerTitle: true,
          actions: const [],
        ),
        body: Consumer(
          builder: (context, ref, child) {
            if (state.status == StatusCondition.success) {
              return isLoad
                  ? const LoadingWidgets()
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        height: 130,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: SizedBox(
                                            height: 90,
                                            child: _imagePick != null
                                                ? Image.file(
                                                    File(_imagePick!.path),
                                                  )
                                                : imgUrl != null
                                                    ? CustomImageCacheNetwork(
                                                        url: imgUrl ?? '')
                                                    : Image.asset(
                                                        'assets/images/empty.jpg',
                                                        fit: BoxFit.cover,
                                                      ))),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 50,
                                              color: AppColor.primary,
                                            )))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              CustomTextFormFieldGrey(
                                  controller: _titleC,
                                  name: 'Title Article',
                                  prefixIcon: Icons.title_rounded),
                              DropdownSearch<String>.multiSelection(
                                validator: (value) {
                                  return null;
                                },
                                selectedItems: initSelectItems ?? [],
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                  prefixIcon: Icon(Icons.category),
                                  prefixIconColor: AppColor.grey4,
                                  hintStyle: TextStyle(color: AppColor.grey4),
                                  hintText: "Kategori artikel",
                                  filled: true,
                                  fillColor: AppColor.grey6,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13.0),
                                    ),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                )),
                                items: items,
                                popupProps: PopupPropsMultiSelection.menu(
                                  showSelectedItems: true,
                                  disabledItemFn: (item) {
                                    if (item.length >= 2) {
                                      print('danger');
                                      return false;
                                    }
                                    return true;
                                  },
                                ),
                                onChanged: (value) {
                                  selectItems = value;

                                  selectedString = selectItems.join(', ');
                                  setState(() {});
                                  print(selectedString);
                                },
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              const Align(
                                alignment: Alignment.bottomLeft,
                                child: CustomTextStyle(
                                  text: "Deskripsi :",
                                  fontsize: 14,
                                ),
                              ),
                              TextFormQuill(controller: _descC),
                              const SizedBox(
                                height: 25.0,
                              ),
                              ButtonFullWidth(
                                  onPressed: () async {
                                    String descEncode = jsonEncode(
                                        _descC.document.toDelta().toJson());

                                    setState(() {
                                      isLoad = true;
                                    });
                                    Posts postAdd = Posts(
                                        title: _titleC.text,
                                        desc: descEncode,
                                        date: DateFormat('kk:mm d-M-y ')
                                            .format(DateTime.now()),
                                        image: _imagePick,
                                        category: selectedString ?? '',
                                        accountId: state.account!.id,
                                        author: state.account!.name);

                                    if (isEdit) {
                                      if (posts != null) {
                                        Posts postUpdate = Posts(
                                          id: posts!.id,
                                          title: _titleC.text,
                                          desc: descEncode,
                                          date: DateFormat('kk:mm d-M-y ')
                                              .format(DateTime.now()),
                                          image: _imagePick ?? imgUrl,
                                          category: selectedString ?? '',
                                          fileId: posts!.fileId,
                                        );

                                        Either<String, bool> result = await ref
                                            .watch(
                                                postsNotifierProvider.notifier)
                                            .updatePost(postUpdate);
                                        result.fold(
                                            (l) => CustomSnackbar.show(context,
                                                message: l, colors: Colors.red),
                                            (r) => CustomSnackbar.show(context,
                                                message:
                                                    'Berhasil mengubah artikel',
                                                colors: AppColor.primary));
                                      }
                                    } else {
                                      Either<String, bool> result = await ref
                                          .watch(postsNotifierProvider.notifier)
                                          .createPost(postAdd);

                                      result.fold(
                                          (l) => CustomSnackbar.show(context,
                                              message: l,
                                              colors: Colors.red), (r) {
                                        CustomSnackbar.show(context,
                                            message: 'Berhasil membuat artikel',
                                            colors: AppColor.primary);
                                      });
                                    }

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NavigatorPage(
                                            targetPage: 3,
                                          ),
                                        ),
                                        (route) => false);

                                    setState(() {
                                      isLoad = false;
                                    });
                                  },
                                  title:
                                      isEdit ? 'Edit artikel' : 'Buat artikel'),
                            ],
                          ),
                        ),
                      ),
                    );
            }
            if (state.status == StatusCondition.empty) {
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('anda belum login'),
                      const Text('silahkan login terlebih dahulu'),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: 200,
                        child: ButtonFullWidth(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false);
                          },
                          title: 'Login',
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.status == StatusCondition.loading) {
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

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imagePick = image;
    });
  }
}
