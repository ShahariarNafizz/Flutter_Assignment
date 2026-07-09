import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/post_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('postsBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      // Consumer ব্যবহার করা হয়েছে যেন Theme চেঞ্জ হলে পুরো অ্যাপ সাথে সাথে চেঞ্জ হয়
      child: Consumer<PostProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'API Data Explorer',
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey.shade100,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey.shade900,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white),
              cardColor: Colors.grey.shade800,
            ),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
