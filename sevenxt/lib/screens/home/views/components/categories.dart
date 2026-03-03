import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenxt/route/screen_export.dart';
import 'package:sevenxt/utils/responsive.dart';
import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

// For preview
class CategoryModel {
  final String name;
  final String? svgSrc, route;
  final String title; // Added field to store title

  CategoryModel({
    required this.name,
    this.svgSrc,
    this.route,
    required this.title, // Make sure to use the parameter
  });
}

List<CategoryModel> demoCategories = [
  CategoryModel(
    name: "All Gadgets",
    svgSrc: "assets/icons/Product.svg",
    route: gadgetsScreenRoute,
    title: "All Gadgets", // Provide meaningful title
  ),
  CategoryModel(
    name: "Mobile & Devices",
    svgSrc: "assets/icons/Phone.svg",
    route: categoryProductsScreen,
    title: "Mobile & Devices",
  ),
  CategoryModel(
    name: "Laptops & PCs",
    svgSrc: "assets/icons/Pc.svg",
    route: categoryProductsScreen,
    title: "Laptops & PCs",
  ),
  CategoryModel(
    name: "Cameras & Photography",
    svgSrc: "assets/icons/Camera.svg",
    route: categoryProductsScreen,
    title: "Cameras & Photography",
  ),
  CategoryModel(
    name: "Wearables",
    svgSrc: "assets/icons/Accessories.svg",
    route: categoryProductsScreen,
    title: "Wearables",
  ),
  CategoryModel(
    name: "TV & Entertainment",
    svgSrc: "assets/icons/tv.svg",
    route: categoryProductsScreen,
    title: "TV & Entertainment",
  ),
  CategoryModel(
    name: "Networking",
    svgSrc: "assets/icons/network.svg",
    route: categoryProductsScreen,
    title: "Networking",
  ),
  CategoryModel(
    name: "Peripherals",
    svgSrc: "assets/icons/Child.svg",
    route: categoryProductsScreen,
    title: "Peripherals",
  ),
];

// End For Preview

// In categories.dart - Update the Categories widget build method
class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    if (isMobile) {
      // Mobile: Horizontal scroll
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
              demoCategories.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? defaultPadding : defaultPadding / 2,
                  right: index == demoCategories.length - 1
                      ? defaultPadding
                      : 0),
                child: CategoryBtn(
                  category: demoCategories[index].name,
                  svgSrc: demoCategories[index].svgSrc,
                  isActive: index == 0,
                  press: () {
                    if (demoCategories[index].route != null) {
                      Navigator.pushNamed(
                        context,
                        demoCategories[index].route!,
                        arguments: demoCategories[index].name,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Desktop/Tablet: Grid layout
      final crossAxisCount = isDesktop ? 8 : 6;
      final padding = Responsive.horizontalPadding(context);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            demoCategories.length,
            (index) => CategoryBtn(
              category: demoCategories[index].name,
              svgSrc: demoCategories[index].svgSrc,
              isActive: index == 0,
              isLarge: isDesktop,
              press: () {
                if (demoCategories[index].route != null) {
                  Navigator.pushNamed(
                    context,
                    demoCategories[index].route!,
                    arguments: demoCategories[index].name,
                  );
                }
              },
            ),
          ),
        ),
      );
    }
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
    this.isLarge = false,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final height = isLarge ? 44.0 : 36.0;
    final fontSize = isLarge ? 14.0 : 12.0;
    final iconSize = isLarge ? 24.0 : 20.0;

    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? defaultPadding + 4 : defaultPadding,
        ),
        decoration: BoxDecoration(
          color: isActive ? kPrimaryColor : Colors.transparent,
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : Theme.of(context).dividerColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: iconSize,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) SizedBox(width: isLarge ? 10 : defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
