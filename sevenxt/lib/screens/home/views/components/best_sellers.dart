// lib/screens/home/components/best_sellers.dart
import 'package:flutter/material.dart';
import 'package:sevenxt/components/product/product_card.dart';
import 'package:sevenxt/models/product_model.dart';
import 'package:sevenxt/route/api_service.dart';
import 'package:sevenxt/utils/responsive.dart';

import '/screens/helpers/user_helper.dart';
import '../../../../components/skleton/product/products_skelton.dart';
import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class BestSellers extends StatefulWidget {
  const BestSellers({super.key});

  @override
  State<BestSellers> createState() => _BestSellersState();
}

class _BestSellersState extends State<BestSellers> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _bestSellersFuture;
  final String _category = "Wearables";

  @override
  void initState() {
    super.initState();
    _bestSellersFuture = Future.value([]);
    _loadBestSellers();
  }

  Future<void> _loadBestSellers() async {
    try {
      final userType = await UserHelper.getUserType();
      setState(() {
        _bestSellersFuture =
            _apiService.getProductsByCategory('Wearables', userType);
      });
    } catch (e) {
      print('Error loading best sellers: $e');
      setState(() {
        _bestSellersFuture = Future.value([]);
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
    final containerHeight = isDesktop ? 380.0 : (isTablet ? 320.0 : 240.0);
    final padding = isDesktop ? 24.0 : defaultPadding;
    final titleFontSize = isDesktop ? 22.0 : (isTablet ? 18.0 : 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isDesktop ? defaultPadding : defaultPadding / 2),
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _category,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    categoryProductsScreen,
                    arguments: _category,
                  );
                },
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
        SizedBox(
          height: containerHeight,
          child: FutureBuilder<List<ProductModel>>(
            future: _bestSellersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ProductsSkelton();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: errorColor, size: isDesktop ? 56 : 40),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading wearables',
                        style: TextStyle(fontSize: isDesktop ? 18 : 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadBestSellers,
                        child: const Text('Retry'),
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
                      Icon(Icons.leaderboard_outlined,
                          size: isDesktop ? 56 : 40),
                      const SizedBox(height: 8),
                      Text(
                        'No wearables found',
                        style: TextStyle(fontSize: isDesktop ? 18 : 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadBestSellers,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              final wearables = snapshot.data!;

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
                        itemCount: wearables.length,
                        itemBuilder: (context, index) => SizedBox(
                          width: cardWidth,
                          child: ProductCard(
                            image: wearables[index].image,
                            brandName: wearables[index].brandName,
                            title: wearables[index].title,
                            price: wearables[index].price.toDouble(),
                            priceAfetDiscount:
                                wearables[index].priceAfetDiscount?.toDouble(),
                            rating: wearables[index].rating,
                            reviews: wearables[index].reviews,
                            press: () {
                              Navigator.pushNamed(
                                context,
                                productDetailsScreenRoute,
                                arguments: wearables[index],
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
                itemCount: wearables.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == wearables.length - 1 ? defaultPadding : 0,
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: ProductCard(
                      image: wearables[index].image,
                      brandName: wearables[index].brandName,
                      title: wearables[index].title,
                      price: wearables[index].price.toDouble(),
                      priceAfetDiscount:
                          wearables[index].priceAfetDiscount?.toDouble(),
                      rating: wearables[index].rating,
                      reviews: wearables[index].reviews,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: wearables[index],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
