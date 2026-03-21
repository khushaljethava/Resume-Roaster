import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/roast_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RoastProvider _roastProvider = RoastProvider();

  @override
  void initState() {
    super.initState();
    _roastProvider.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return RoastProviderScope(
      provider: _roastProvider,
      child: MaterialApp(
        title: 'AI Resume Roaster',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

class RoastProviderScope extends InheritedNotifier<RoastProvider> {
  const RoastProviderScope({
    super.key,
    required RoastProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static RoastProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RoastProviderScope>();
    return scope!.notifier!;
  }

  static RoastProvider read(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<RoastProviderScope>();
    return scope!.notifier!;
  }
}
