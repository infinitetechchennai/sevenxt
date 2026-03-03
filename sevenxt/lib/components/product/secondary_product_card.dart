import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/responsive.dart';
import '../network_image_with_loader.dart';

class SecondaryProductCard extends StatelessWidget {
  const SecondaryProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.rating,
    this.press,
    this.style,
  });

  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final double? rating;
  final VoidCallback? press;

  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions
    final cardWidth = isDesktop ? 300.0 : (isTablet ? 280.0 : 256.0);
    final imageWidth = isDesktop ? 100.0 : (isTablet ? 90.0 : 80.0);
    final minHeight = isDesktop ? 140.0 : (isTablet ? 130.0 : 114.0);

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(color: blackColor10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 12.0 : 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              SizedBox(
                width: imageWidth,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      NetworkImageWithLoader(
                        imageUrl: image,
                        radius: defaultBorderRadious,
                      ),
                      if (dicountpercent != null && dicountpercent! > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 6 : 4,
                                vertical: isDesktop ? 4 : 2),
                            decoration: BoxDecoration(
                              color: errorColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "$dicountpercent% OFF",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 10 : 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: isDesktop ? 16 : 12),

              /// CONTENT
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        brandName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                              fontSize: isDesktop ? 12 : 10,
                              color: blackColor40
                            ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        title,
                        maxLines: isDesktop ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: isDesktop ? 14 : 11,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      if (rating != null)
                        Row(
                          children: [
                            Icon(Icons.star, size: isDesktop ? 12 : 10, color: warningColor),
                            const SizedBox(width: 2),
                            Text(
                              rating!.toStringAsFixed(1),
                              style: TextStyle(
                                  fontSize: isDesktop ? 11 : 9, fontWeight: FontWeight.bold),
                            ),
                            if (isDesktop) ...[
                              const SizedBox(width: 8),
                              Text(
                                'reviews',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: blackColor40,
                                ),
                              ),
                            ],
                          ],
                        ),

                      /// PRICE
                      SizedBox(height: isDesktop ? 6 : 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (priceAfetDiscount != null &&
                              priceAfetDiscount! < price)
                            Text(
                              "₹${price.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: isDesktop ? 12 : 9,
                                color: blackColor40,
                                decoration: TextDecoration.lineThrough,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Text(
                            "₹${(priceAfetDiscount ?? price).toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: isDesktop ? 16 : 12,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
