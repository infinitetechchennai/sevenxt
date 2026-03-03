// lib/screens/home/components/popular_products_tv_entertainment.dart
import 'package:flutter/material.dart';
import 'package:sevenxt/components/product/product_card.dart';
import 'package:sevenxt/models/product_model.dart';
import 'package:sevenxt/route/api_service.dart';
import 'package:sevenxt/route/screen_export.dart';
import 'package:sevenxt/utils/responsive.dart';

import '/screens/helpers/user_helper.dart';
import '../../../../components/skleton/product/products_skelton.dart';
import '../../../../constants.dart';

class PopularProductsTVEntertainment extends StatefulWidget {
  const PopularProductsTVEntertainment({super.key});

  @override
  State<PopularProductsTVEntertainment> createState() =>
      _PopularProductsTVEntertainmentState();
}

class _PopularProductsTVEntertainmentState
    extends State<PopularProductsTVEntertainment> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _productsFuture;

  final String _category = "TV & Entertainment";

  @override
  void initState() {
    super.initState();
    _productsFuture = Future.value([]);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final userType = await UserHelper.getUserType();
      setState(() {
        _productsFuture =
            _apiService.getProductsByCategory(_category, userType);
      });
    } catch (e) {
      setState(() {
        _productsFuture = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions
    final cardWidth = isDesktop ? 260.0 : (isTablet ? 220.0 : 180.0);
    final containerHeight = isDesktop ? 380.0 : (isTablet ? 340.0 : 280.0);
    final padding = isDesktop ? 24.0 : defaultPadding;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isDesktop ? defaultPadding : defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDesktop ? [] : [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: padding,
              top: padding,
              right: padding,
              bottom: padding / 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 10 : 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.tv,
                        size: isDesktop ? 28 : 20,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: isDesktop ? 16 : 12),
                    Text(
                      _category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isDesktop ? 20 : 16,
                            color: Colors.orange.shade800,
                          ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _loadProducts,
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: isDesktop ? 16 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isDesktop ? 16 : defaultPadding / 2),
          SizedBox(
            height: containerHeight,
            child: FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ProductsSkelton();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          color: errorColor,
                          size: isDesktop ? 64 : 50,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Streaming Error',
                          style: TextStyle(
                            color: errorColor,
                            fontWeight: FontWeight.w500,
                            fontSize: isDesktop ? 18 : 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load entertainment products',
                          style: TextStyle(
                            color: blackColor40,
                            fontSize: isDesktop ? 16 : 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade50,
                            foregroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, size: isDesktop ? 20 : 16),
                              const SizedBox(width: 8),
                              const Text('Retry'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.speaker,
                          size: isDesktop ? 72 : 60,
                          color: blackColor40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No Entertainment Products',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isDesktop ? 18 : 16,
                            color: blackColor80,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back for home theatre systems',
                          style: TextStyle(
                            color: blackColor60,
                            fontSize: isDesktop ? 16 : 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _loadProducts,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, size: isDesktop ? 20 : 16),
                              const SizedBox(width: 8),
                              const Text('Refresh'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data!;

                // Desktop/Tablet: Grid layout
                if (!isMobile) {
                  final crossAxisCount = isDesktop ? 4 : 3;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1400),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) => SizedBox(
                            width: cardWidth,
                            child: ProductCard(
                              image: products[index].image,
                              brandName: products[index].brandName,
                              title: products[index].title,
                              price: products[index].price.toDouble(),
                              priceAfetDiscount:
                                  products[index].priceAfetDiscount?.toDouble(),
                              rating: products[index].rating,
                              reviews: products[index].reviews,
                              press: () {
                                Navigator.pushNamed(
                                  context,
                                  productDetailsScreenRoute,
                                  arguments: products[index],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Mobile: Horizontal scroll
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding / 2,
                      right: index == products.length - 1 ? defaultPadding / 2 : 0,
                    ),
                    child: SizedBox(
                      width: cardWidth,
                      child: ProductCard(
                        image: products[index].image,
                        brandName: products[index].brandName,
                        title: products[index].title,
                        price: products[index].price.toDouble(),
                        priceAfetDiscount:
                            products[index].priceAfetDiscount?.toDouble(),
                        rating: products[index].rating,
                        reviews: products[index].reviews,
                        press: () {
                          Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: products[index],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: padding),
        ],
      ),
    );
  }
}
