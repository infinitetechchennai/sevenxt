import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenxt/components/product/secondary_product_card.dart';
import 'package:sevenxt/models/category_model.dart';
import 'package:sevenxt/models/product_model.dart';
import 'package:sevenxt/route/api_service.dart';
import 'package:sevenxt/utils/responsive.dart';

import '/screens/helpers/user_helper.dart';
import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class CategorySection extends StatefulWidget {
  final CategoryModel category;

  const CategorySection({
    super.key,
    required this.category,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _productsFuture;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    final userType = await UserHelper.getUserType();
    return _apiService.getProductsByCategory(
      widget.category.name,
      userType,
    );
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive dimensions
    final horizontalHeight = isDesktop ? 180.0 : (isTablet ? 160.0 : 114.0);
    final titleFontSize = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final padding = isDesktop ? 24.0 : defaultPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: defaultPadding / 2),
        Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.name,
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
                    arguments: widget.category.name,
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
        if (isMobile)
          _buildMobileLayout(horizontalHeight)
        else
          _buildDesktopLayout(isTablet),
      ],
    );
  }

  /// Mobile: Horizontal scroll layout
  Widget _buildMobileLayout(double height) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          FutureBuilder<List<ProductModel>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              return _buildProductList(snapshot, isHorizontal: true);
            },
          ),
          Positioned(
            left: 0,
            top: 40,
            child: IconButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.offset - 150,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/miniLeft.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 40,
            child: IconButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.offset + 150,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: SvgPicture.asset(
                'assets/icons/miniRight.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop/Tablet: Grid layout
  Widget _buildDesktopLayout(bool isTablet) {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        return _buildProductGrid(snapshot, isTablet);
      },
    );
  }

  Widget _buildProductList(
    AsyncSnapshot<List<ProductModel>> snapshot, {
    required bool isHorizontal,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: kPrimaryColor),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'Error loading ${widget.category.name}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loadProducts,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 24),
              const SizedBox(height: 8),
              Text('No ${widget.category.name} found'),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loadProducts,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Refresh'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final products = snapshot.data!;

    if (isHorizontal) {
      return ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: index == products.length - 1 ? defaultPadding : 0,
          ),
          child: SecondaryProductCard(
            image: products[index].image,
            brandName: products[index].brandName,
            title: products[index].title,
            price: products[index].price,
            rating: products[index].rating,
            priceAfetDiscount: products[index].priceAfetDiscount,
            dicountpercent: products[index].discountPercentUI,
            press: () {
              Navigator.pushNamed(
                context,
                productDetailsScreenRoute,
                arguments: products[index],
              );
            },
          ),
        ),
      );
    }

    // Grid view - should not reach here, handled in _buildProductGrid
    return const SizedBox.shrink();
  }

  Widget _buildProductGrid(
    AsyncSnapshot<List<ProductModel>> snapshot,
    bool isTablet,
  ) {
    final isDesktop = Responsive.isDesktop(context); // ✅ FIX ADDED

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: kPrimaryColor),
        ),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'Error loading ${widget.category.name}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 32),
              const SizedBox(height: 12),
              Text('No ${widget.category.name} found'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    final products = snapshot.data!;
    final crossAxisCount = Responsive.categoryCrossAxisCount(context);
    final padding = Responsive.horizontalPadding(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: isDesktop ? 140.0 : 130.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => SecondaryProductCard(
              image: products[index].image,
              brandName: products[index].brandName,
              title: products[index].title,
              price: products[index].price,
              rating: products[index].rating,
              priceAfetDiscount: products[index].priceAfetDiscount,
              dicountpercent: products[index].discountPercentUI,
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
    );
  }
}
