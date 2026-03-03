// lib/screens/home/components/popular_products.dart
import 'package:flutter/material.dart';
import 'package:sevenxt/components/product/product_card.dart';
import 'package:sevenxt/models/product_model.dart';
import 'package:sevenxt/route/api_service.dart';
import 'package:sevenxt/route/screen_export.dart';
import 'package:sevenxt/utils/responsive.dart';

import '/screens/helpers/user_helper.dart';
import '../../../../components/skleton/product/products_skelton.dart'
    show ProductsSkelton;
import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _productsFuture;

  // Define the category you want to display
  final String _category = "Laptops & PCs";

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
                      Icon(Icons.error_outline,
                          color: errorColor, size: isDesktop ? 56 : 40),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading $_category',
                        style: TextStyle(fontSize: isDesktop ? 18 : 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        child: Text(isDesktop ? 'Retry' : 'Retry'),
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
                      Icon(Icons.inventory_2_outlined,
                          size: isDesktop ? 56 : 40),
                      const SizedBox(height: 8),
                      Text(
                        'No $_category found',
                        style: TextStyle(fontSize: isDesktop ? 18 : 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              final products = snapshot.data!;

              // Desktop/Tablet: Grid layout
              if (!isMobile) {
                final crossAxisCount = isDesktop ? 4 : 3;
                return SizedBox(
                  height: containerHeight,
                  width: double.infinity,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: padding),
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
                );
              }

              // Mobile: Horizontal scroll
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == products.length - 1 ? defaultPadding : 0,
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
        )
      ],
    );
  }
}
