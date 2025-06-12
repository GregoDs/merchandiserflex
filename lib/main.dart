
import 'exports.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          child: MaterialApp(
            title: 'Flexpay Promoter',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: ColorName.primaryColor,
              scaffoldBackgroundColor: ColorName.whiteColor,
            ),
            // darkTheme: ThemeData(
            //   brightness: Brightness.dark,
            //   primaryColor: ColorName.primaryColor,
            //   scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            // ),
            themeMode: ThemeMode.system,
            routes: AppRoutes.routes,
            // home: const StartupRedirector(),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
