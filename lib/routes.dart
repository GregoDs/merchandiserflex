import 'package:flexmerchandiser/features/customers/models/customers_model.dart';
import 'package:flexmerchandiser/features/customers/ui/customer_profile.dart';
import 'package:flexmerchandiser/features/home/ui/home.dart';
import 'package:flexmerchandiser/features/home/cubit/home_cubit.dart';
import 'package:flexmerchandiser/features/home/repo/home_repo.dart';
import 'package:flexmerchandiser/features/customers/ui/customers.dart';
import 'package:flexmerchandiser/features/customers/cubit/customers_cubit.dart';
import 'package:flexmerchandiser/features/customers/repo/customers_repo.dart';

import 'exports.dart';

// Create global Cubit instances
final authCubit = AuthCubit(AuthRepo());
// final commissionsCubit = CommissionsCubit(repository: CommissionRepository());
// final bookingsCubit = BookingsCubit(repository: BookingsRepository());

class AppRoutes {
  static final routes = {
    // Routes.splash: (context) => const StartupRedirector(),
    Routes.splash: (context) => const SplashScreen(),
    Routes.onboarding: (context) => const OnBoardingScreen(),
    Routes.login:
        (context) =>
            BlocProvider.value(value: authCubit, child: const LoginScreen()),

    Routes.otp:
        (context) =>
            BlocProvider.value(value: authCubit, child: const OtpScreen()),

    Routes.home:
        (context) => BlocProvider(
          create: (context) => HomeCubit(HomeRepo()),
          child: const HomePage(),
        ),

    // Routes.makeBookings: (context) => BlocProvider(
    //       create: (context) => MakeBookingCubit(BookingsRepository()),
    //       child: const MakeBookingsScreen(),
    //     ),

    // // Routes.validatedReceipts: (context) => ValidatedReceiptsPage(
    // //       validatedReceipts: _validatedReceipts,
    // //     ),
    // Routes.bookings: (context) => BlocProvider.value(
    //       value: bookingsCubit,
    //       child: const BookingsScreen(),
    //     ),

    // Routes.bookingDetails: (context) => BlocProvider.value(
    //       value: bookingsCubit,
    //       child: const BookingDetailScreen(
    //         bookings: [],
    //         title: '',
    //       ),
    //     ),

    // Routes.commissions: (context) => BlocProvider.value(
    //       value: commissionsCubit,
    //       child: const Commissions(),
    //     ),
    // Routes.leaderboard: (context) => BlocProvider.value(
    //       value: LeaderboardCubit(repository: LeaderboardRepository()),
    //       child: const LeaderboardScreen(),
    //     ),
    Routes.customerDetails: (context) {
      final outletId = ModalRoute.of(context)!.settings.arguments as String;
      return BlocProvider(
        create: (_) => CustomersCubit(customerRepo: CustomerRepo()),
        child: CustomerDetailsPage(outletId: outletId),
      );
    },
    Routes.customerProfile: (context) {
      final customer = ModalRoute.of(context)!.settings.arguments as Customer;
      return BlocProvider(
        create: (_) => CustomersCubit(customerRepo: CustomerRepo()),
        child: CustomerProfilePage(customer: customer),
      );
    },
  };
}

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const home = '/home';
  static const customerDetails = '/customer-details';
  static const makeBookings = '/make-bookings';
  static const validatedReceipts = '/validated-receipts';
  static const bookings = '/bookings';
  static const commissions = '/commissions';
  static const leaderboard = '/leaderboard';
  static const bookingDetails = '/booking-details';
  static const customerProfile = '/customer-profile';
}
