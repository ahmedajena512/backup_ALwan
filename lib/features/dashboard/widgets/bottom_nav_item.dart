import 'package:flutter/material.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/util/app_colors.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function? onTap;
  final bool isSelected;
  final String title;
  const BottomNavItem({
    super.key,
    required this.iconData,
    this.onTap,
    this.isSelected = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        onTap: onTap as void Function()?,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return AppColors.mainGradient.createShader(bounds);
                    },
                    child: Icon(iconData, color: Colors.white, size: 25),
                  )
                : Icon(iconData, color: Colors.grey, size: 25),

            isSelected
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return AppColors.mainGradient.createShader(bounds);
                    },
                    child: Text(
                      title,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    title,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Colors.grey,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
