import 'package:flutter/material.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:pos_portal/routes/routes.dart';
import 'package:pos_portal/view_model/cart_provider.dart';
import 'package:pos_portal/view_model/cart_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CartProvider()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pos Portal',
      initialRoute: RoutesName.ROOT,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
