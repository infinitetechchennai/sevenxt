// lib/screens/home/components/most_popular.dart
import 'package:flutter/material.dart';
import 'package:sevenxt/components/product/secondary_product_card.dart';
import 'package:sevenxt/models/product_model.dart';
import 'package:sevenxt/route/api_service.dart';
import 'package:sevenxt/utils/responsive.dart';

import '/screens/helpers/user_helper.dart';
import '../../../../components/skleton/product/secondery_produts_skelton.dart';
import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class MostPopular extends StatefulWidget {
  const MostPopular({super.key});

  @override
  State<MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<MostPopular> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _mostPopularProductsFuture;

  // Define the category you want to display
  final String _category = "Mobile & Devices";

  @override
  void initState() {
    super.initState();
    _loadMostPopularProducts();
  }

  Future<void> _loadMostPopularProducts() async {
    try {
      final userType = await UserHelper.getUserType();
      setState(() {
        _mostPopularProductsFuture =
            _apiService.getProductsByCategory(_category, userType);
      });
    } catch (e) {
      setState(() {
        _mostPopularProductsFuture = Future.value([]);
      });
      print('Error loading products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions
    final containerHeight = isDesktop ? 180.0 : (isTablet ? 160.0 : 114.0);
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
            future: _mostPopularProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SeconderyProductsSkelton();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: errorColor, size: isDesktop ? 40 : 24),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading $_category',
                        style: TextStyle(fontSize: isDesktop ? 18 : 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadMostPopularProducts,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 24 : 16,
                            vertical: isDesktop ? 12 : 8,
                          ),
                        ),
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
                      Icon(Icons.phone_iphone_outlined,
                          size: isDesktop ? 40 : 24),
                      const SizedBox(height: 8),
                      Text(
                        'No $_category found',
                        style: TextStyle(fontSize: isDesktop ? 18 : 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadMostPopularProducts,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 24 : 16,
                            vertical: isDesktop ? 12 : 8,
                          ),
                        ),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              final mostPopularProducts = snapshot.data!;

              // Desktop/Tablet: Horizontal scroll (re-using ListView logic for consistency)
              if (!isMobile) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mostPopularProducts.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: index == mostPopularProducts.length - 1 ? padding : 0,
                    ),
                    child: SecondaryProductCard(
                      image: mostPopularProducts[index].image,
                      brandName: mostPopularProducts[index].brandName,
                      title: mostPopularProducts[index].title,
                      price: mostPopularProducts[index].price.toDouble(),
                      priceAfetDiscount: mostPopularProducts[index]
                          .priceAfetDiscount
                          ?.toDouble(),
                      rating: mostPopularProducts[index].rating,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: mostPopularProducts[index],
                        );
                      },
                    ),
                  ),
                );
              }

              // Mobile: Horizontal scroll
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mostPopularProducts.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == mostPopularProducts.length - 1
                        ? defaultPadding
                        : 0,
                  ),
                  child: SecondaryProductCard(
                    image: mostPopularProducts[index].image,
                    brandName: mostPopularProducts[index].brandName,
                    title: mostPopularProducts[index].title,
                    price: mostPopularProducts[index].price.toDouble(),
                    priceAfetDiscount: mostPopularProducts[index]
                        .priceAfetDiscount
                        ?.toDouble(),
                    press: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute,
                        arguments: mostPopularProducts[index],
                      );
                    },
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
