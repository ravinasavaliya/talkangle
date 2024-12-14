import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/ui/staff/models/get_staff_detail_res_model.dart';
import 'package:talkangels/common/app_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());
  HandleNetworkConnection handleNetworkConnection = Get.find();
  final _formKey = GlobalKey<FormState>();
  Data? angelData = Get.arguments["profile_detail"] ?? '';
  String? pickedImage;
  bool isPicked = false;
  String genderSelect = "Female";
  final emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    super.initState();
    demo();
  }

  demo() {
    homeController.bioController = TextEditingController(text: angelData?.bio);
    homeController.languageController = TextEditingController(text: angelData?.language);
    homeController.ageController = TextEditingController(text: "${angelData!.age}");
    homeController.userNameController = TextEditingController(text: angelData?.userName);
    homeController.nameController = TextEditingController(text: angelData?.name);
    homeController.emailController = TextEditingController(text: angelData?.email ?? '');
    genderSelect = angelData!.gender!;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    homeController.updateStaffDetailsLoading;
    homeController.bioController;
    homeController.languageController;
    homeController.ageController;
    homeController.userNameController;
    homeController.nameController;
    homeController.emailController;
    genderSelect;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return Scaffold(
          appBar: AppAppBar(
            titleText: AppString.editProfileDetails,
            bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
          ),
          body: GetBuilder<HomeController>(
            builder: (controller) {
              return Container(
                height: h,
                width: w,
                decoration: const BoxDecoration(gradient: appGradient),
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: angelData == null || angelData!.name!.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: whiteColor))
                    : controller.getStaffDetailResModel.status == 200
                        ? SafeArea(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    (h * 0.05).addHSpace(),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          FilePickerResult? image = await FilePicker.platform.pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                                          );

                                          if (image != null) {
                                            pickedImage = image.files.single.path;

                                            setState(() {
                                              isPicked = true;
                                            });
                                          }
                                        } catch (e) {
                                          // log("EEEEEE_________${e}");
                                        }
                                      },
                                      child: Container(
                                        height: w * 0.35,
                                        width: w * 0.35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: whiteColor,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(w * 0.008),
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(color: containerColor, shape: BoxShape.circle),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(200),
                                              child: isPicked
                                                  ? Image.file(
                                                      File(pickedImage!),
                                                      // pickedImage,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : angelData?.image == "" || angelData?.image == "0"
                                                      ? assetImage(AppAssets.blankProfile)
                                                      : CachedNetworkImage(
                                                          imageUrl: "${angelData?.image}",
                                                          imageBuilder: (context, imageProvider) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.black45,
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          placeholder: (context, url) =>
                                                              assetImage(AppAssets.blankProfile, fit: BoxFit.cover),
                                                          errorWidget: (context, url, error) =>
                                                              assetImage(AppAssets.blankProfile, fit: BoxFit.cover),
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    (h * 0.05).addHSpace(),
                                    CommonTextFormField(
                                      hintText: "User Name",
                                      controller: controller.userNameController,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Fill Field";
                                        }
                                        return null;
                                      },
                                    ),
                                    (h * 0.05).addHSpace(),
                                    CommonTextFormField(
                                      hintText: "Name",
                                      controller: controller.nameController,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Fill Field";
                                        }
                                        return null;
                                      },
                                    ),
                                    (h * 0.05).addHSpace(),
                                    CommonTextFormField(
                                      hintText: "Email",
                                      controller: controller.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Fill Field";
                                        } else if (emailValid.hasMatch(controller.emailController.text) == false) {
                                          return "Please Enter Valid Email";
                                        }
                                        return null;
                                      },
                                    ),
                                    (h * 0.05).addHSpace(),
                                    CommonTextFormField(
                                      minLine: 1,
                                      maxLine: 10,
                                      hintText: "About Me",
                                      controller: controller.bioController,
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Fill Field";
                                        }
                                        return null;
                                      },
                                    ),
                                    (h * 0.05).addHSpace(),
                                    CommonTextFormField(
                                      hintText: "Language",
                                      controller: controller.languageController,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Fill Field";
                                        }
                                        return null;
                                      },
                                    ),
                                    (h * 0.05).addHSpace(),
                                    CommonTextFormField(
                                      hintText: "Age (Years)",
                                      controller: controller.ageController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Fill Field";
                                        }
                                        return null;
                                      },
                                    ),
                                    (h * 0.05).addHSpace(),
                                    Container(
                                      height: h * 0.07,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: textFieldBorderColor),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton<String>(
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        style: const TextStyle(color: whiteColor, fontWeight: FontWeight.w300),
                                        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                                        dropdownColor: appBarColor,
                                        value: genderSelect,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            genderSelect = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          "Female",
                                          "Male",
                                          "Other",
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    (h * 0.1).addHSpace(),
                                    AppButton(
                                      color: appColorBlue,
                                      onTap: () async {
                                        if (handleNetworkConnection.isResult == false) {
                                          if (_formKey.currentState!.validate()) {
                                            /// UPDATE STAFF DETAILS API

                                            if (pickedImage != null) {
                                              String fileType = pickedImage!.toString().split('.').last;

                                              await controller.updateStaffDetails(
                                                userName: controller.userNameController.text,
                                                language: controller.languageController.text,
                                                gender: genderSelect,
                                                bio: controller.bioController.text,
                                                age: controller.ageController.text,
                                                name: controller.nameController.text,
                                                email: controller.emailController.text,
                                                image: pickedImage,
                                                fileType: fileType,
                                              );
                                            } else {
                                              await controller.updateStaffDetails(
                                                userName: controller.userNameController.text,
                                                language: controller.languageController.text,
                                                gender: genderSelect,
                                                bio: controller.bioController.text,
                                                age: controller.ageController.text,
                                                name: controller.nameController.text,
                                                email: controller.emailController.text,
                                              );
                                            }
                                          }
                                        } else {
                                          showAppSnackBar(AppString.noInternetConnection);
                                        }
                                      },
                                      child: controller.updateStaffDetailsLoading == true
                                          ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                          : AppString.submit.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                    (h * 0.05).addHSpace(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : StaffErrorScreen(
                            isLoading: controller.isLoading,
                            onTap: () {
                              if (networkController.isResult == false) {
                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                  await homeController.getStaffDetailApi();
                                });
                              }
                            },
                          ),
              );
            },
          ),
        );
      },
    );
  }
}
