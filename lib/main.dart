import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/repository/product_repository.dart';
import 'data/repository/payment_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/cart_repository.dart';
import 'logic/cubit/product/product_cubit.dart';
import 'logic/cubit/cart/cart_cubit.dart';
import 'logic/cubit/payment/payment_cubit.dart';
import 'logic/cubit/auth/auth_cubit.dart';
import 'data/provider/firebase_auth_provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductCubit(ProductRepository())..loadProducts(),
        ),
        BlocProvider(
          create: (_) => CartCubit(CartRepository()),
        ),
        BlocProvider(create: (_) => PaymentCubit(PaymentRepository())),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthRepository(FirebaseAuthProvider())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopiera',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const HomePage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/auth': (context) => const AuthScreen(),
        },
      ),
    );
  }
}