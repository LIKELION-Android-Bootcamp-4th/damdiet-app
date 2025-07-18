import 'package:damdiet/data/datasource/favorite_datasource.dart';
import 'package:damdiet/data/datasource/cart_datasource.dart';
import 'package:damdiet/data/datasource/payment_service.dart';
import 'package:damdiet/data/datasource/order_datasource.dart';
import 'package:damdiet/data/datasource/review_datasource.dart';
import 'package:damdiet/data/datasource/mypage_datasource.dart';
import 'package:damdiet/data/datasource/nutrition_datasource.dart';
import 'package:damdiet/data/models/product/product_query.dart';
import 'package:damdiet/data/repositories/favorite_repository.dart';
import 'package:damdiet/data/repositories/cart_repository.dart';
import 'package:damdiet/data/repositories/mypage_repository.dart';
import 'package:damdiet/data/repositories/nutrition_repository.dart';
import 'package:damdiet/data/repositories/payment_repository.dart';
import 'package:damdiet/data/repositories/review_repository.dart';
import 'package:damdiet/presentation/screens/mypage/mypage/mypage_viewmodel.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_address_edit_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_my_orders/mypage_my_orders_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_my_reviews/mypage_my_reviews_viewmodel.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_nickname_edit/mypage_nickname_edit_screen.dart';
import 'package:damdiet/presentation/screens/search/search_screen.dart';
import 'package:damdiet/presentation/screens/splash/splash_screen.dart';
import 'package:damdiet/presentation/provider/user_provider.dart';
import 'package:damdiet/presentation/screens/auth/signin_viewmodel.dart';
import 'package:damdiet/data/repositories/product_repository.dart';
import 'package:damdiet/presentation/routes/app_routes.dart';
import 'package:damdiet/presentation/screens/kcal_calculator/kcal_calculator_screen.dart';
import 'package:damdiet/presentation/screens/home/home_screen.dart';
import 'package:damdiet/presentation/screens/cart/cart_screen.dart';
import 'package:damdiet/presentation/screens/auth/email_verification_screen.dart';
import 'package:damdiet/presentation/screens/auth/auth_signin_screen.dart';
import 'package:damdiet/presentation/screens/auth/auth_signup_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_favorite_product/mypage_favorite_products_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_my_community_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_my_order_detail/mypage_my_order_details_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_my_reviews/mypage_my_reviews_screen.dart';
import 'package:damdiet/presentation/screens/mypage/mypage_password_edit/mypage_password_edit_screen.dart';
import 'package:damdiet/presentation/screens/payment/payment_screen.dart';
import 'package:damdiet/presentation/screens/review/review_edit_screen.dart';
import 'package:damdiet/presentation/screens/review/review_write_screen.dart';
import 'package:damdiet/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:damdiet/presentation/screens/products/products_screen.dart';
import 'package:damdiet/data/datasource/product_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'data/models/payment/payment_item.dart';
import 'data/models/request/order_request_dto.dart';
import 'data/repositories/order_repository.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
        providers: [
          Provider(create: (_) => ProductDatasource()),
          Provider(create: (_) => CartDatasource()),
          Provider(create: (_) => FavoriteDatasource()),
          Provider(create: (_) => NutritionDataSource()),
          Provider(create: (_) => OrderDataSource()),
          Provider(create: (_) => MyPageDataSource()),
          Provider(create: (_) => PaymentService()),

          ProxyProvider<ProductDatasource, ProductRepository>(
            update: (_, datasource, __) => ProductRepository(datasource),
          ),
          ProxyProvider<CartDatasource, CartRepository>(
            update: (_, datasource, __) => CartRepository(datasource),
          ),
          ProxyProvider<FavoriteDatasource, FavoriteRepository>(
            update: (_, datasource, __) => FavoriteRepository(datasource),
          ),
          ProxyProvider<NutritionDataSource, NutritionRepository>(
            update: (_, datasource, __) => NutritionRepository(datasource),
          ),
          ProxyProvider<OrderDataSource, OrderRepository>(
            update: (_, datasource, __) => OrderRepository(datasource),
          ),
          ProxyProvider<MyPageDataSource, MyPageRepository>(
            update: (_, datasource, __) => MyPageRepository(datasource),
          ),
          ProxyProvider<PaymentService, PaymentRepository>(
            update: (_, datasource, __) => PaymentRepository(datasource),
          ),


          ChangeNotifierProxyProvider<MyPageDataSource, UserProvider>(
            create: (_) => UserProvider(MyPageDataSource(), FlutterSecureStorage()),
            update: (_, datasource, __) => UserProvider(datasource, FlutterSecureStorage()),
          ),

          // 앱 전역에서 사용하는 뷰모델 냅두기
          ChangeNotifierProvider(create: (_) => SignInViewModel()),
          ChangeNotifierProvider(create: (_) => MypageViewModel(MyPageRepository((MyPageDataSource()))),),

          ChangeNotifierProvider(create: (_) => MyPageMyReviewsViewModel(ReviewRepository(ReviewDatasource()))),
        ],
        child: const DamDietApp()
    )
  );
}

class DamDietApp extends StatelessWidget {
  const DamDietApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DamDiet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.kcalCalculator: (context) => KcalCalculatorScreenWrapper(),
        AppRoutes.passwordEdit: (context) => MyPagePasswordEditScreenWrapper(),
        AppRoutes.nicknameEdit: (context) => MyPageNicknameEditScreenWrapper(),
        AppRoutes.favoriteProduct: (context) => MyPageFavoriteProductsScreenWrapper(),
        AppRoutes.myReview: (context) => MyPageMyReviewsScreen(),
        AppRoutes.myOrders: (context) => MyPageMyOrdersScreenWrapper(),
        AppRoutes.cart: (context) => CartScreenWrapper(),
        AppRoutes.reviewWrite: (context) => ReviewWriteScreenWithProvider(),
        AppRoutes.reviewEdit: (context) => ReviewEditScreen(),
        AppRoutes.signIn: (context) => SignInScreen(),
        AppRoutes.signUp: (context) => SignUpScreenWrapper(),
        AppRoutes.emailVerification: (context) => EmailVerificationScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.productDetail:
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => ProductDetailScreen(productId: productId),
              );

          case AppRoutes.payment:
              final arguments = settings.arguments as List<List<Object>?>;
              return MaterialPageRoute(
                builder: (_) => PaymentScreenWrapper(
                  orderItems: arguments[0] as List<OrderItem>,
                  paymentItems: arguments[1] as List<PaymentItem>,
                  cartIds: arguments[2] as List<String>?
                ),
              );

          case AppRoutes.products:
            final args = settings.arguments;
            final query = args is ProductQuery ? args : ProductQuery();
            return MaterialPageRoute(
                builder: (_) => ProductsScreenWrapper( productQuery: query,)
        );

          case AppRoutes.myOrderDetail: 
            final orderId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => MyPageMyOrderDetailsScreenWrapper(orderId: orderId),
            );
          default:
            return null;
        }
      },
    );
  }
}
