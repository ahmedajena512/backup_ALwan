import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/verification/controllers/verification_controller.dart';
import 'package:stackfood_multivendor/features/verification/screens/verification_screen.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/util/app_colors.dart';

import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromDialog;
  const ForgetPassScreen({super.key, this.fromDialog = false});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  String? _countryDialCode = CountryCode.fromCountryCode(
    Get.find<SplashController>().configModel!.country!,
  ).dialCode;
  GlobalKey<FormState>? _formKeyLogin;
  bool isEmail = false;
  bool isPhone = false;

  @override
  void initState() {
    super.initState();

    isPhone =
        (Get.find<SplashController>().configModel!.isSmsActive! ||
        Get.find<SplashController>().configModel!.firebaseOtpVerification!);
    isEmail = Get.find<SplashController>().configModel!.isMailActive!;

    _formKeyLogin = GlobalKey<FormState>();
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_numberFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? null : null,
      body: Stack(
        children: [
          // Header Section
          Container(
            height: Get.height * 0.25,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppColors.mainGradient),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'your_business_name'.tr,
                  style: robotoBlack.copyWith(
                    fontSize: 50,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                Text(
                  'company_slogan'.tr,
                  style: robotoRegular.copyWith(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Section
          Container(
            margin: EdgeInsets.only(top: Get.height * 0.20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                children: [
                  // Heading
                  Text(
                    'forgot_password'.tr,
                    style: robotoBlack.copyWith(
                      fontSize: 24,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'enter_email_address_or_phone_number'.tr,
                    style: robotoRegular.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF777777),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Form
                  (isPhone || isEmail)
                      ? Column(
                          children: [
                            Form(
                              key: _formKeyLogin,
                              child: isPhone
                                  ? Theme(
                                      data: Theme.of(context).copyWith(
                                        primaryColor: const Color(0xFF5cbf47),
                                      ),
                                      child: CustomTextFieldWidget(
                                        titleText: 'xxx-xxx-xxxxx'.tr,
                                        controller: _numberController,
                                        focusNode: _numberFocusNode,
                                        inputType: TextInputType.phone,
                                        inputAction: TextInputAction.done,
                                        isPhone: true,
                                        onCountryChanged:
                                            (CountryCode countryCode) {
                                              _countryDialCode =
                                                  countryCode.dialCode;
                                            },
                                        countryDialCode:
                                            CountryCode.fromCountryCode(
                                              Get.find<SplashController>()
                                                  .configModel!
                                                  .country!,
                                            ).code ??
                                            Get.find<LocalizationController>()
                                                .locale
                                                .countryCode,
                                        onSubmit: (text) => GetPlatform.isWeb
                                            ? _onPressedForgetPass(
                                                _countryDialCode!,
                                              )
                                            : null,
                                        labelText: 'phone'.tr,
                                        validator: (value) =>
                                            ValidateCheck.validateEmptyText(
                                              value,
                                              null,
                                            ),
                                        borderRadius: 50,
                                        borderColor: const Color(0xFF5cbf47),
                                      ),
                                    )
                                  : Theme(
                                      data: Theme.of(context).copyWith(
                                        primaryColor: const Color(0xFF5cbf47),
                                      ),
                                      child: CustomTextFieldWidget(
                                        titleText: 'enter_email'.tr,
                                        labelText: 'email'.tr,
                                        showLabelText: true,
                                        required: true,
                                        controller: _emailController,
                                        focusNode: _emailFocusNode,
                                        inputType: TextInputType.emailAddress,
                                        inputAction: TextInputAction.done,
                                        prefixIcon: CupertinoIcons.mail_solid,
                                        validator: (value) =>
                                            ValidateCheck.validateEmail(value),
                                        borderRadius: 50,
                                        borderColor: const Color(0xFF5cbf47),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 25),

                            GetBuilder<VerificationController>(
                              builder: (verificationController) {
                                return GetBuilder<AuthController>(
                                  builder: (authController) {
                                    return CustomButtonWidget(
                                      radius: 50,
                                      isBold: true,
                                      height: 55,
                                      buttonText: 'request_otp'.tr,
                                      isLoading:
                                          verificationController.isLoading ||
                                          authController.isLoading,
                                      onPressed: () => _onPressedForgetPass(
                                        _countryDialCode!,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            InkWell(
                              onTap: () => Get.back(),
                              child: Text(
                                'sign_in'.tr,
                                style: robotoBold.copyWith(
                                  fontSize: 15,
                                  color: const Color(0xFF3ab0c9),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(
                            Dimensions.paddingSizeLarge,
                          ),
                          child: Column(
                            children: [
                              Image.asset(Images.forgot, height: 220),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeLarge,
                                  vertical: Dimensions.paddingSizeSmall,
                                ),
                                child: Text(
                                  'sorry_something_went_wrong'.tr,
                                  style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeLarge,
                                ),
                                child: Text(
                                  'please_try_again_after_some_time_or_contact_with_our_support_team'
                                      .tr,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeOverLarge,
                              ),
                              CustomButtonWidget(
                                buttonText: 'help_and_support'.tr,
                                onPressed: () {
                                  Get.toNamed(RouteHelper.getSupportRoute());
                                },
                              ),
                            ],
                          ),
                        ),

                  const SizedBox(height: 48),

                  // Create Customer Account Button
                  CustomButtonWidget(
                    buttonText: '+ ${'sign_up'.tr}',
                    radius: 50,
                    isBold: true,
                    color: const Color(0xFF8ce065),
                    onPressed: () {
                      Get.toNamed(RouteHelper.getSignUpRoute());
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: Get.find<LocalizationController>().isLtr ? 20 : null,
            right: Get.find<LocalizationController>().isLtr ? null : 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressedForgetPass(String countryCode) async {
    String phone = _numberController.text.trim();
    String email = _emailController.text.trim();

    String numberWithCountryCode = countryCode + phone;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(
      numberWithCountryCode,
    );
    numberWithCountryCode = phoneValid.phone;

    if (_formKeyLogin!.currentState!.validate()) {
      if (!phoneValid.isValid && !isEmail) {
        showCustomSnackBar('invalid_phone_number'.tr);
      } else {
        Get.find<VerificationController>()
            .forgetPassword(email: email, phone: numberWithCountryCode)
            .then((status) async {
              if (status.isSuccess) {
                if (Get.find<SplashController>()
                    .configModel!
                    .firebaseOtpVerification!) {
                  Get.find<AuthController>().firebaseVerifyPhoneNumber(
                    numberWithCountryCode,
                    status.message,
                    '',
                    fromSignUp: false,
                  );
                } else {
                  if (ResponsiveHelper.isDesktop(Get.context)) {
                    Get.back();
                    Get.dialog(
                      VerificationScreen(
                        number: numberWithCountryCode,
                        email: email,
                        token: '',
                        fromSignUp: false,
                        fromForgetPassword: true,
                        loginType: '',
                        password: '',
                      ),
                    );
                  } else {
                    Get.toNamed(
                      RouteHelper.getVerificationRoute(
                        numberWithCountryCode,
                        email,
                        '',
                        RouteHelper.forgotPassword,
                        '',
                        '',
                      ),
                    );
                  }
                }
              } else {
                showCustomSnackBar(status.message);
              }
            });
      }
    }
  }
}
