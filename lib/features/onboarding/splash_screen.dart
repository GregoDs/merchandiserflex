import 'package:flexmerchandiser/exports.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isLoggedIn = false;
  bool firstLaunch = false;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    _checkLoginStatus();

    // Timer(const Duration(seconds: 7),() => Get.offNamed(RouteHelper.getAuth()));
    Timer(
        const Duration(seconds: 7),
        () => firstLaunch
             ? Navigator.pushReplacementNamed(context, Routes.onboarding)
             : isLoggedIn
                 ? Navigator.pushReplacementNamed(context, Routes.home)
                 : Navigator.pushReplacementNamed(context, Routes.login)
        // isLoggedIn
        //     ? Get.to(() => const MyBusiness())
        //     : Get.to(() => const SignIn()),
        );
  }

  _checkLoginStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var launch = localStorage.getBool('firstLaunch');
    var token = localStorage.getString('token');

    setState(() {
      firstLaunch = launch ?? true;
      isLoggedIn = token != null && token.isNotEmpty;
      print("Token: $token");
    });
  }

//   @override
// dispose() {
//   controller.dispose(); // you need this
//   super.dispose();
// }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        //statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ScaleTransition(
                  scale: animation,
                  child: Center(
                    child: Container(
                      width: 330,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icon/flexhomelogo.png"),
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 180.h,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AppText.medium("Lipia polepole", color: ColorName.mainGrey,),
                    // AppText.medium("Furahia matokeo",color: ColorName.mainGrey,)
                  ],
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class StartupRedirector extends StatefulWidget {
//   const StartupRedirector({super.key});

//   @override
//   State<StartupRedirector> createState() => _StartupRedirectorState();
// }

// class _StartupRedirectorState extends State<StartupRedirector> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateAfterDelay();
//   }

//   Future<void> _navigateAfterDelay() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     final launch = localStorage.getBool('firstLaunch') ?? true;
//     final token = localStorage.getString('token');

//     // Slight delay to ensure build has settled (optional but helps)
//     await Future.delayed(const Duration(milliseconds: 100));

//     if (launch) {
//       Navigator.pushReplacementNamed(context, Routes.onboarding);
//     } else if (token != null && token.isNotEmpty) {
//       Navigator.pushReplacementNamed(context, Routes.home);
//     } else {
//       Navigator.pushReplacementNamed(context, Routes.login);
//     }

//     // Remove splash AFTER push to avoid flicker
//     FlutterNativeSplash.remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Do not return any visual layout to avoid white screen
//     return const SizedBox.shrink(); // fully transparent
//   }
// }