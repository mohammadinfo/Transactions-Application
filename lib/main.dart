import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/money.dart';
import 'screens/home_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox<Money>('moneyBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static void getData() {
    HomeScreen.moneys.clear();
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values) {
      HomeScreen.moneys.add(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'iransans'),
      debugShowCheckedModeBanner: false,
      title: 'اپلیکیشن مدیریت مالی',
      home: const MainScreen(),
    );
  }
}
