import 'dart:io';

import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/utils/caching/shared_pref.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/helper/ui/customcurvecliper.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/auth/logic/user/user_cubit.dart';
import 'package:finance_track/features/settings/logic/image/image_cubit.dart';
import 'package:finance_track/features/settings/logic/image/image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(),
      child: const SettingScreen(),
    );
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File? pickedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
      context.read<ImageCubit>().uploadImage(pickedImage!);
    } else {
      ToastNotifier.showError('No image selected');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final img = await SharedPref().getProfilePicture();
      if (img == null) {
        context.read<ImageCubit>().imageUrl;
      } else {
        context.read<ImageCubit>().setImageUrl(img);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.modify(colorCode: AppColors.mainAppColor),
        leading: const BackButton(color: Colors.white),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(fontSize: 18.sp, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await SharedPref().clearAll();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                width: double.infinity,
                height: 230.h,
                decoration: BoxDecoration(
                  color: Colors.white.modify(colorCode: AppColors.mainAppColor),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocConsumer<ImageCubit, ImageState>(
                        listener: (context, state) async {
                          if (state.status.isSuccess) {
                            ToastNotifier.showSuccess(state.message.toString());
                          }
                          if (state.status.isError) {
                            ToastNotifier.showError(state.message.toString());
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: pickImage,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50.r,
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                        child: pickedImage != null
                                            ? Image.file(
                                                pickedImage!,
                                                width: 100.r,
                                                height: 100.r,
                                                fit: BoxFit.cover,
                                              )
                                            : (state.imageUrl != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: state.imageUrl!,
                                                      width: 100.r,
                                                      height: 100.r,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) =>
                                                          Container(), // Do not show loader here; handled outside
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => const Icon(
                                                            Icons.person,
                                                            color: Colors.grey,
                                                          ),
                                                    )
                                                  : const Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                    )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                context
                                        .read<UserCubit>()
                                        .user
                                        ?.userMetadata?['name'] ??
                                    '',
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                context.read<UserCubit>().user?.email ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
