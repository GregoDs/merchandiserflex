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

    if (firstLaunch) {
      // First launch: go to login
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pushReplacementNamed(Routes.login);
    } else if (isLoggedIn) {
      // Not first launch and token exists: verify token
      context.read<AuthCubit>().verifyTokenOnStartup();
    } else {
      // Not first launch, but no token: go to login
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthTokenInvalid) {
          CustomSnackBar.showError(
            context,
            title: "Session Ended",
            message: "Sorry, your session has ended. Please log in again.",
          );
          await Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.login,
            (route) => false,
          );
        } else if (state is AuthUserUpdated) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
      ),
    );
  }
}