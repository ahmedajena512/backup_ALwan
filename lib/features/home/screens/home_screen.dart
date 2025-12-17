import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor/util/app_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/features/dine_in/controllers/dine_in_controller.dart';
import 'package:stackfood_multivendor/features/home/controllers/advertisement_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/cashback_dialog_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cashback_logo_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/dine_in_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/highlight_widget_view.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/product/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/home/screens/web_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurant_filter_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/all_restaurants_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/bad_weather_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/best_review_item_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/cuisine_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/enjoy_off_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/location_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/new_on_stackfood_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/order_again_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_foods_nearby_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/popular_restaurants_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/refer_banner_view_widget.dart';
import 'package:stackfood_multivendor/features/home/screens/theme1_home_screen.dart';
import 'package:stackfood_multivendor/features/home/widgets/today_trends_view_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/what_on_your_mind_view_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';

import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';

import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/features/review/controllers/review_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload) async {
    Get.find<HomeController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload, search: '');
    Get.find<CuisineController>().getCuisineList();
    Get.find<AdvertisementController>().getAdvertisementList();
    Get.find<DineInController>().getDineInRestaurantList(1, reload);
    if (Get.find<SplashController>().configModel!.popularRestaurant == 1) {
      Get.find<RestaurantController>().getPopularRestaurantList(
        reload,
        'all',
        false,
      );
    }
    Get.find<CampaignController>().getItemCampaignList(reload);
    if (Get.find<SplashController>().configModel!.popularFood == 1) {
      Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel!.newRestaurant == 1) {
      Get.find<RestaurantController>().getLatestRestaurantList(
        reload,
        'all',
        false,
      );
    }
    if (Get.find<SplashController>().configModel!.mostReviewedFoods == 1) {
      Get.find<ReviewController>().getReviewedProductList(reload, 'all', false);
    }
    Get.find<RestaurantController>().getRestaurantList(1, reload);
    if (Get.find<AuthController>().isLoggedIn()) {
      await Get.find<ProfileController>().getUserInfo();
      Get.find<RestaurantController>().getRecentlyViewedRestaurantList(
        reload,
        'all',
        false,
      );
      Get.find<RestaurantController>().getOrderAgainRestaurantList(reload);
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<AddressController>().getAddressList();
      Get.find<HomeController>().getCashBackOfferList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ConfigModel? _configModel = Get.find<SplashController>().configModel;
  bool _isLogin = false;
  bool _showAppBarContent = true; // Track AppBar content visibility
  double _lastScrollOffset = 0.0; // Track last scroll position

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        if (_scrollController.offset > _lastScrollOffset &&
            _showAppBarContent) {
          setState(() {
            _showAppBarContent = false;
          });
        } else if (_scrollController.offset < _lastScrollOffset &&
            !_showAppBarContent) {
          setState(() {
            _showAppBarContent = true;
          });
        }
      } else {
        if (!_showAppBarContent) {
          setState(() {
            _showAppBarContent = true;
          });
        }
      }
      _lastScrollOffset = _scrollController.offset;
    });

    _isLogin = Get.find<AuthController>().isLoggedIn();
    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if ((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ??
              false) &&
          Get.find<SplashController>().showReferBottomSheet) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _showReferBottomSheet(),
        );
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(
            const Duration(milliseconds: 800),
            () => Get.find<HomeController>().changeFavVisibility(),
          );
        }
      } else {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(
            const Duration(milliseconds: 800),
            () => Get.find<HomeController>().changeFavVisibility(),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showReferBottomSheet() {
    ResponsiveHelper.isDesktop(context)
        ? Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Dimensions.radiusExtraLarge,
                ),
              ),
              insetPadding: const EdgeInsets.all(22),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const ReferBottomSheetWidget(),
            ),
            useSafeArea: false,
          ).then(
            (value) =>
                Get.find<SplashController>().saveReferBottomSheetStatus(false),
          )
        : showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            context: Get.context!,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                topRight: Radius.circular(Dimensions.radiusExtraLarge),
              ),
            ),
            builder: (context) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: const ReferBottomSheetWidget(),
              );
            },
          ).then(
            (value) =>
                Get.find<SplashController>().saveReferBottomSheetStatus(false),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizationController) {
            return Scaffold(
              appBar: ResponsiveHelper.isDesktop(context)
                  ? const WebMenuBar()
                  : null,
              endDrawer: const MenuDrawerWidget(),
              endDrawerEnableOpenDragGesture: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: SafeArea(
                top: (Get.find<SplashController>().configModel!.theme == 2),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Get.find<HomeController>().getBannerList(true);
                    await Get.find<CategoryController>().getCategoryList(
                      true,
                      search: '',
                    );
                    await Get.find<CuisineController>().getCuisineList();
                    Get.find<AdvertisementController>().getAdvertisementList();
                    await Get.find<RestaurantController>()
                        .getPopularRestaurantList(true, 'all', false);
                    await Get.find<CampaignController>().getItemCampaignList(
                      true,
                    );
                    await Get.find<ProductController>().getPopularProductList(
                      true,
                      'all',
                      false,
                    );
                    await Get.find<RestaurantController>()
                        .getLatestRestaurantList(true, 'all', false);
                    await Get.find<ReviewController>().getReviewedProductList(
                      true,
                      'all',
                      false,
                    );
                    await Get.find<RestaurantController>().getRestaurantList(
                      1,
                      true,
                    );
                    if (Get.find<AuthController>().isLoggedIn()) {
                      await Get.find<ProfileController>().getUserInfo();
                      await Get.find<NotificationController>()
                          .getNotificationList(true);
                      await Get.find<RestaurantController>()
                          .getRecentlyViewedRestaurantList(true, 'all', false);
                      await Get.find<RestaurantController>()
                          .getOrderAgainRestaurantList(true);
                    }
                  },
                  child: ResponsiveHelper.isDesktop(context)
                      ? WebHomeScreen(scrollController: _scrollController)
                      : (Get.find<SplashController>().configModel!.theme == 2)
                      ? Theme1HomeScreen(scrollController: _scrollController)
                      : CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            /// App Bar
                            SliverAppBar(
                              pinned: true,
                              floating: true,
                              snap: true,
                              toolbarHeight: 0,
                              expandedHeight: 115,
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(30),
                                ),
                              ),
                              flexibleSpace: Container(
                                decoration: const BoxDecoration(
                                  gradient: AppColors.mainGradient,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(30),
                                  ),
                                ),
                                child: FlexibleSpaceBar(
                                  titlePadding: EdgeInsets.zero,
                                  centerTitle: true,
                                  expandedTitleScale: 1,
                                  title: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 250),
                                    opacity: _showAppBarContent ? 1.0 : 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 30,
                                        left: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault,
                                        bottom: 80,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => Get.toNamed(
                                                RouteHelper.getAccessLocationRoute(
                                                  'home',
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_on,
                                                        size: 16,
                                                        color: Colors.white70,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        (AuthHelper.isLoggedIn() &&
                                                                AddressHelper.getAddressFromSharedPref()!
                                                                        .addressType !=
                                                                    'others')
                                                            ? AddressHelper.getAddressFromSharedPref()!
                                                                  .addressType!
                                                                  .tr
                                                            : 'your_location'
                                                                  .tr,
                                                        style: robotoMedium
                                                            .copyWith(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          AddressHelper.getAddressFromSharedPref()!
                                                              .address!,
                                                          style: robotoBold.copyWith(
                                                            color: Colors.white,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.expand_more,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => Get.toNamed(
                                              RouteHelper.getNotificationRoute(),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  const Icon(
                                                    Icons.notifications,
                                                    size: 24,
                                                    color: Colors.white,
                                                  ),
                                                  GetBuilder<
                                                    NotificationController
                                                  >(
                                                    builder: (notificationController) {
                                                      return notificationController
                                                              .hasNotification
                                                          ? Positioned(
                                                              top: -2,
                                                              right: -2,
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                    width: 1.5,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              bottom: PreferredSize(
                                preferredSize: const Size.fromHeight(70),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeDefault,
                                    right: Dimensions.paddingSizeDefault,
                                    bottom: 20,
                                  ),
                                  child: InkWell(
                                    onTap: () => Get.toNamed(
                                      RouteHelper.getSearchRoute(),
                                    ),
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeSmall,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.mic,
                                            size: 25,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(
                                            width: Dimensions.paddingSizeSmall,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'are_you_hungry'.tr,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(
                                                  context,
                                                ).hintColor,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            CupertinoIcons.search,
                                            size: 25,
                                            color: Theme.of(
                                              context,
                                            ).disabledColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Center(
                                child: SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const BannerViewWidget(),

                                      const BadWeatherWidget(),

                                      const WhatOnYourMindViewWidget(),

                                      const TodayTrendsViewWidget(),

                                      const LocationBannerViewWidget(),

                                      const HighlightWidgetView(),

                                      _isLogin
                                          ? const OrderAgainViewWidget()
                                          : const SizedBox(),

                                      _configModel!.mostReviewedFoods == 1
                                          ? const BestReviewItemViewWidget(
                                              isPopular: false,
                                            )
                                          : const SizedBox(),

                                      _configModel.dineInOrderOption!
                                          ? DineInWidget()
                                          : const SizedBox(),

                                      const CuisineViewWidget(),

                                      _configModel.popularRestaurant == 1
                                          ? const PopularRestaurantsViewWidget()
                                          : const SizedBox(),

                                      const ReferBannerViewWidget(),

                                      _isLogin
                                          ? const PopularRestaurantsViewWidget(
                                              isRecentlyViewed: true,
                                            )
                                          : const SizedBox(),

                                      _configModel.popularFood == 1
                                          ? const PopularFoodNearbyViewWidget()
                                          : const SizedBox(),

                                      _configModel.newRestaurant == 1
                                          ? const NewOnStackFoodViewWidget(
                                              isLatest: true,
                                            )
                                          : const SizedBox(),

                                      const PromotionalBannerViewWidget(),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SliverPersistentHeader(
                              pinned: true,
                              delegate: SliverDelegate(
                                height: 90,
                                child: const AllRestaurantFilterWidget(),
                              ),
                            ),

                            SliverToBoxAdapter(
                              child: Center(
                                child: FooterViewWidget(
                                  child: Padding(
                                    padding: ResponsiveHelper.isDesktop(context)
                                        ? EdgeInsets.zero
                                        : const EdgeInsets.only(
                                            bottom:
                                                Dimensions.paddingSizeOverLarge,
                                          ),
                                    child: AllRestaurantsWidget(
                                      scrollController: _scrollController,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              floatingActionButton:
                  AuthHelper.isLoggedIn() &&
                      homeController.cashBackOfferList != null &&
                      homeController.cashBackOfferList!.isNotEmpty
                  ? homeController.showFavButton
                        ? Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveHelper.isDesktop(context)
                                  ? 50
                                  : 0,
                              right: ResponsiveHelper.isDesktop(context)
                                  ? 20
                                  : 0,
                            ),
                            child: InkWell(
                              onTap: () =>
                                  Get.dialog(const CashBackDialogWidget()),
                              child: const CashBackLogoWidget(),
                            ),
                          )
                        : null
                  : null,
            );
          },
        );
      },
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 50});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
