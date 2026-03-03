import 'package:flutter/material.dart';
import 'package:sevenxt/utils/responsive.dart';

import '../../../constants.dart';
import 'secondary_product_skelton.dart';

class SeconderyProductsSkelton extends StatelessWidget {
  const SeconderyProductsSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions
    final containerHeight = isDesktop ? 180.0 : (isTablet ? 160.0 : 114.0);
    final cardWidth = isDesktop ? 300.0 : (isTablet ? 280.0 : 256.0);

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
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => SizedBox(
            width: cardWidth,
            child: const SeconderyProductSkelton(),
          ),
        ),
      );
    }

    // Mobile: Horizontal scroll
    return SizedBox(
      height: containerHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: defaultPadding),
              child: SizedBox(
                width: cardWidth,
                child: const SeconderyProductSkelton(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: defaultPadding),
              child: SizedBox(
                width: cardWidth,
                child: const SeconderyProductSkelton(),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: defaultPadding, right: defaultPadding),
              child: SizedBox(
                width: cardWidth,
                child: const SeconderyProductSkelton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
