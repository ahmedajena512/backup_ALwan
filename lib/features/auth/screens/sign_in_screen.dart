import 'dart:async';
import 'dart:io';
import 'package:stackfood_multivendor/util/app_colors.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/sign_in/sign_in_view.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  final bool fromResetPassword;
  const SignInScreen({
    super.key,
    required this.exitFromApp,
    required this.backFromThis,
    this.fromResetPassword = false,
  });

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              ),
            );
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
          }
        } else {
          if (Get.find<AuthController>().isOtpViewEnable) {
            Get.find<AuthController>().enableOtpView(enable: false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        body: Container(
          decoration: ResponsiveHelper.isDesktop(context)
              ? null
              : const BoxDecoration(gradient: AppColors.mainGradient),
          child: SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  if (!ResponsiveHelper.isDesktop(context))
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      child: Column(
                        children: [
                          Text(
                            'your_business_name'.tr,
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'company_slogan'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: Container(
                      width: context.width > 700 ? 500 : context.width,
                      padding: context.width > 700
                          ? const EdgeInsets.all(50)
                          : const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraLarge,
                              vertical: Dimensions.paddingSizeLarge,
                            ),
                      margin: context.width > 700
                          ? const EdgeInsets.all(50)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: context.width > 700
                            ? BorderRadius.circular(Dimensions.radiusSmall)
                            : const BorderRadius.vertical(
                                top: Radius.circular(40),
                              ),
                        boxShadow: ResponsiveHelper.isDesktop(context)
                            ? null
                            : [
                                BoxShadow(
                                  color:
                                      Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ResponsiveHelper.isDesktop(context)
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () => Get.back(),
                                      icon: const Icon(Icons.clear),
                                    ),
                                  )
                                : const SizedBox(),

                            if (ResponsiveHelper.isDesktop(context))
                              CustomImageWidget(
                                image:
                                    Get.find<SplashController>()
                                        .configModel
                                        ?.logoFullUrl ??
                                    '',
                                height: 50,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                            const SizedBox(
                              height: Dimensions.paddingSizeOverLarge,
                            ),

                            SignInView(
                              exitFromApp: widget.exitFromApp,
                              backFromThis: widget.backFromThis,
                              fromResetPassword: widget.fromResetPassword,
                              isOtpViewEnable: (v) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
