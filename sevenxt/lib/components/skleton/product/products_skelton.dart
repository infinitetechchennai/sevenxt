import 'package:flutter/material.dart';
import 'package:sevenxt/utils/responsive.dart';

import '../../../constants.dart';
import 'product_card_skelton.dart';

class ProductsSkelton extends StatelessWidget {
  const ProductsSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions
    final containerHeight = isDesktop ? 380.0 : (isTablet ? 320.0 : 240.0);
    final cardWidth = isDesktop ? 260.0 : (isTablet ? 220.0 : 180.0);

    if (!isMobile) {
      // Desktop/Tablet: Grid layout
      final crossAxisCount = isDesktop ? 4 : 3;
      return SizedBox(
        height: containerHeight,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : defaultPadding,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => SizedBox(
            width: cardWidth,
            child: const ProductCardSkelton(),
          ),
        ),
      );
    }

    // Mobile: Horizontal scroll
    return SizedBox(
      height: containerHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: index == 4 ? defaultPadding : 0,
          ),
          child: SizedBox(
            width: cardWidth,
            child: const ProductCardSkelton(),
          ),
        ),
      ),
    );
  }
}
