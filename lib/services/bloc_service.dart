import 'package:flutter/material.dart';
import 'package:malina/core/theme.dart';

import 'package:malina/services/cart_service.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        final favorites = cartService.favorites;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Избранное',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textcolor2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          backgroundColor: AppColors.backround2,
          body: SafeArea(
            child: Column(
              children: [
                // Заголовок

                // Контент
                Expanded(
                  child: favorites.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final product = favorites[index];
                            final cartItem = cartService.cart.firstWhere(
                              (item) => item.product.id == product.id,
                              orElse: () =>
                                  CartItem(product: product, quantity: 0),
                            );

                            return Dismissible(
                              key: Key(product.id),
                              direction: DismissDirection.horizontal,
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  cartService.addToCart(product.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Добавлено в корзину',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AppColors.iosGreen,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.sm,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  cartService.toggleFavorite(product.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Удалено из избранного',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AppColors.textcolor2,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.sm,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              background: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.iosGreen,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 24),
                                child: const Icon(
                                  Icons.shopping_bag_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              secondaryBackground: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.iosRed,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                height: 100,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                  boxShadow: AppShadows.card,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.iosGray6,
                                            AppColors.iosGray5,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.image_rounded,
                                        size: 28,
                                        color: AppColors.iosGray3,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              color: AppColors.textcolor2,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${product.price.toStringAsFixed(0)} ₽',
                                            style: const TextStyle(
                                              color: AppColors.iosBlue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.iosGray6,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.pill,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _FavQtyButton(
                                            icon: Icons.remove_rounded,
                                            onTap: () {
                                              if (cartItem.quantity > 0) {
                                                cartService.updateQuantity(
                                                  product.id,
                                                  cartItem.quantity - 1,
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 28,
                                            child: Text(
                                              '${cartItem.quantity}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: AppColors.textcolor2,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          _FavQtyButton(
                                            icon: Icons.add_rounded,
                                            onTap: () {
                                              cartService.addToCart(product.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.iosGray6,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_outlined,
              size: 40,
              color: AppColors.iosGray2,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Нет избранных товаров',
            style: TextStyle(
              color: AppColors.textcolor2,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Отмечайте понравившиеся товары ❤️',
            style: TextStyle(color: AppColors.iosGray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _FavQtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FavQtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.iosBlue),
      ),
    );
  }
}
