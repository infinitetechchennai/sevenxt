import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/responsive.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.rating,
    required this.reviews,
    required this.press,
  });

  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final double rating;
  final int reviews;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions (OLD STYLE)
    final padding = isDesktop ? 16.0 : (isTablet ? 14.0 : 12.0);
    final brandFontSize = isDesktop ? 12.0 : (isTablet ? 11.0 : 10.0);
    final titleFontSize = isDesktop ? 16.0 : (isTablet ? 14.0 : 13.0);
    final titleMaxLines = isDesktop ? 3 : 2;
    final ratingIconSize = isDesktop ? 16.0 : (isTablet ? 15.0 : 14.0);
    final ratingFontSize = isDesktop ? 13.0 : (isTablet ? 12.0 : 11.0);
    final priceFontSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 15.0);
    final originalPriceFontSize = isDesktop ? 13.0 : (isTablet ? 12.0 : 11.0);

    return InkWell(
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: blackColor20,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE (Old Expanded behavior restored)
            Expanded(
              child: Stack(
                children: [
                  NetworkImageWithLoader(
                    imageUrl: image,
                    radius: 0,
                    fit: BoxFit.contain,
                  ),
                  if (dicountpercent != null && dicountpercent! > 0)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 8 : 6,
                          vertical: isDesktop ? 5 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: errorColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "$dicountpercent% OFF",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 10 : 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// CONTENT (Old Layout)
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (brandName.isNotEmpty)
                    Text(
                      brandName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: brandFontSize,
                        color: Colors.grey,
                      ),
                    ),

                  SizedBox(height: isDesktop ? 6 : 4),

                  Text(
                    title,
                    maxLines: titleMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: titleFontSize,
                    ),
                  ),

                  /// Rating & Reviews
                  Padding(
                    padding: EdgeInsets.only(
                      top: isDesktop ? 6 : 4,
                      bottom: isDesktop ? 8 : 6,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: ratingIconSize,
                          color: rating > 0 ? Colors.amber : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: ratingFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '($reviews)',
                          style: TextStyle(
                            fontSize: ratingFontSize,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isDesktop ? 10 : 8),

                  /// Price
                  Text(
                    priceAfetDiscount != null && priceAfetDiscount! < price
                        ? '₹${priceAfetDiscount!.toStringAsFixed(0)}'
                        : '₹${price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: priceFontSize,
                    ),
                  ),

                  /// Original Price (if discounted)
                  if (priceAfetDiscount != null && priceAfetDiscount! < price)
                    Text(
                      '₹${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: originalPriceFontSize,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
