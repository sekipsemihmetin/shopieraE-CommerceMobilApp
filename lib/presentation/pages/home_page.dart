import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../logic/cubit/cart/cart_cubit.dart';
import '../../logic/cubit/product/product_cubit.dart';
import '../../logic/cubit/product/product_state.dart';
import '../../logic/cubit/auth/auth_cubit.dart';
import '../widgets/modern_product_card.dart';
import '../pages/cart_page.dart';
import '../../data/models/add_cart.dart';
import '../../core/constants/base_constants.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _welcomeController;
  late AnimationController _contentController;
  late Animation<double> _welcomeAnimation;
  late Animation<double> _contentAnimation;

  bool _showWelcome = true;

  final List<String> bannerImages = [
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
    'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800',
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
    'https://images.unsplash.com/photo-1607282348824-0a96f2a4b9da?w=800',
  ];


  @override
  void initState() {
    super.initState();

    _welcomeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _welcomeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeInOut),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutQuart),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _welcomeController.forward();
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _showWelcome = false;
    });

    _contentController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Check if user is authenticated
  bool _isUserAuthenticated() {
    final authState = context
        .read<AuthCubit>()
        .state;
    return authState is Authenticated;
  }

  // Show login required dialog
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.login,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Giriş Gerekli',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Bu işlemi gerçekleştirmek için önce giriş yapmanız gerekiyor.',
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Color(0xFF718096)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/auth');
                  },
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return _buildWelcomeScreen();
    }

    return _buildMainContent();
  }

  Widget _buildWelcomeScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _welcomeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _welcomeAnimation.value,
                child: Opacity(
                  opacity: _welcomeAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          size: 60,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Shopiera',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sen Neredeysen Alışveriş Orada!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _contentAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _contentAnimation.value)),
          child: Opacity(
            opacity: _contentAnimation.value,
            child: Scaffold(
              backgroundColor: const Color(0xFFF8F9FA),
              appBar: _buildModernAppBar(),
              body: _buildBody(),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Shopiera',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: [
        // Login/Profile Button
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Color(0xFF48BB78),
                  ),
                  onPressed: () {

                    _showUserMenu();
                  },
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.login,
                    color: Color(0xFF667eea),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                ),
              );
            }
          },
        ),
        // Cart Button
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF667eea),
            ),
            onPressed: () {
              if (_isUserAuthenticated()) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BlocProvider.value(
                          value: context.read<CartCubit>()
                            ..fetchCartItems(),
                          child: const CartPage(),
                        ),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                _showLoginRequiredDialog();
              }
            },
          ),
        ),
      ],
    );
  }

  void _showUserMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFFE53E3E)),
                  title: const Text('Çıkış Yap'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthCubit>().logout();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildLoadingState();
        } else if (state is ProductLoaded) {
          return _buildLoadedState(state.products);
        } else if (state is ProductError) {
          return _buildErrorState(state.message);
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
          ),
          SizedBox(height: 16),
          Text(
            'Ürünler yükleniyor...',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFE53E3E),
          ),
          const SizedBox(height: 16),
          Text(
            'Hata: $message',
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductCubit>().loadProducts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Color(0xFF718096),
          ),
          SizedBox(height: 16),
          Text(
            'Henüz ürün bulunmuyor',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(List products) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductCubit>().loadProducts();
      },
      color: const Color(0xFF667eea),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerSlider(),
            const SizedBox(height: 24),
            _buildSectionTitle('Öne Çıkan Ürünler'),
            const SizedBox(height: 16),
            _buildProductGrid(products),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
        items: bannerImages.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF667eea).withOpacity(0.1),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 48,
                                color: Color(0xFF667eea),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          'Özel İndirimler',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: ModernProductCard(
                    product: products[index],
                    onAddToCart: () => _handleAddToCart(products[index]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  void _handleAddToCart(dynamic product) {
    final authState = context
        .read<AuthCubit>()
        .state;

    if (authState is! Authenticated) {

      _showLoginRequiredDialog();
      return;
    }


    final cartItem = AddCart(
      name: product.name,
      image: product.image,
      category: product.category,
      price: product.price,
      brand: product.brand,
      quantity: 1,

      username: BaseInfo.username,
    );

    context.read<CartCubit>().addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text("${product.name} sepete eklendi!"),
          ],
        ),
        backgroundColor: const Color(0xFF48BB78),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}


