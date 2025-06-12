import 'package:fl_chart/fl_chart.dart';
import 'package:flexmerchandiser/features/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexmerchandiser/features/home/cubit/home_cubit.dart';
import 'package:flexmerchandiser/features/home/ui/home_shimmer.dart';
import 'package:flexmerchandiser/features/home/models/outlets_model.dart';
import 'package:flexmerchandiser/widgets/scaffold_messengers.dart';
import 'package:flexmerchandiser/widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  bool _showSideMenu = false;

  
  @override
  void initState() {
    super.initState();
    // Fetch outlets when the page loads
    context.read<HomeCubit>().fetchOutlets();
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isPortrait = screenHeight > screenWidth;
    
    // Calculate responsive dimensions
    final double basePadding = screenWidth * 0.04; // 4% of screen width
    final double baseSpacing = screenHeight * 0.02; // 2% of screen height
    final double baseFontSize = screenWidth * 0.05; // 5% of screen width for base font size

    return Scaffold(
      drawer: SideMenu(
        name: "Promoter",
        phone: "Profile",
        onLogout: () async {
          setState(() => _showSideMenu = false);
          // TODO: Add your logout logic here
        },
        onDeleteAccount: () {
          setState(() => _showSideMenu = false);
          // TODO: Add your delete account logic here
        },
        onClose: () => setState(() => _showSideMenu = false), // Pass close callback
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/appbarbackground.png",
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(basePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopRow(screenWidth),
                    SizedBox(height: baseSpacing),
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: baseFontSize * 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: baseSpacing * 0.5),
                    _buildSecondRow(screenWidth),
                    SizedBox(height: baseSpacing * 0.8),
                    _buildGraphRow(screenWidth, screenHeight),
                    SizedBox(height: baseSpacing * 1.5),
                    Text(
                      "Outlets",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: baseFontSize * 0.9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    BlocListener<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state is HomeError) {
                          CustomSnackBar.showError(
                            context,
                            title: "Oops!",
                            message: state.message,
                          );
                        }
                      },
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoading) {
                            return const HomeShimmer();
                          } else if (state is HomeSuccess) {
                            final List<Outlet> outlets = state.outlets;
                            return _buildOutletsGrid(outlets, screenWidth);
                          } else if (state is HomeError) {
                            return const HomeShimmer();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(double screenWidth) {
    final double avatarSize = screenWidth * 0.2;
    final double spacing = screenWidth * 0.04;
    
    return Row(
      children: [
        // Drawer Icon
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: EdgeInsets.all(spacing * 0.5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/drawer.png",
                width: avatarSize * 0.5,
                height: avatarSize * 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        Stack(
          alignment: Alignment.center,
          // children: [
          //   SizedBox(
          //     width: avatarSize,
          //     height: avatarSize,
          //     child: CircularProgressIndicator(
          //       value: 0.65,
          //       strokeWidth: 4,
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
          //       backgroundColor: Colors.transparent,
          //     ),
          //   ),
          //   CircleAvatar(
          //     radius: avatarSize * 0.4,
          //     child: Icon(Icons.person, size: avatarSize * 0.4),
          //   ),
          // ],
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Afternoon",
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing * 0.3),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 0.4,
                  vertical: spacing * 0.3,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last activity:",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      "6 Dec, 2025 at 12:43 pm",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondRow(double screenWidth) {
    final double spacing = screenWidth * 0.02;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing * 2,
        vertical: spacing * 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _circleIcon(Icons.savings, screenWidth),
                  SizedBox(width: spacing),
                  Text(
                    "FlexChama",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing,
                  vertical: spacing * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "x2.0",
                  style: TextStyle(
                    fontFamily: 'montserrat',
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "25% Full",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: screenWidth * 0.03,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    "\120",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.25,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.lime,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _circleIcon(Icons.people, screenWidth),
                  SizedBox(width: spacing),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Users",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: screenWidth * 0.03,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "67",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _circleIcon(Icons.people, screenWidth),
                  SizedBox(width: spacing),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Not in chama",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: screenWidth * 0.03,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "3",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraphRow(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Conversion Activity",
          style: TextStyle(
            fontFamily: 'montserrat',
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        SizedBox(
          height: screenHeight * 0.25,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade800,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(
                          months[value.toInt()],
                          style: TextStyle(
                            fontFamily: 'montserrat',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    interval: 1,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              lineBarsData: [
                _lineData(
                  Colors.orangeAccent,
                  [10, 12, 15, 8, 10, 0],
                ),
                _lineData(
                  Colors.greenAccent,
                  [2, 1.5, 2, 1, 2, 0],
                ),
              ],
              minX: 0,
              maxX: 5,
              minY: 0,
              maxY: 15,
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _lineData(Color color, List<double> spots) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.black,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
      spots: List.generate(spots.length, (i) => FlSpot(i.toDouble(), spots[i])),
    );
  }

  Widget _buildOutletsGrid(List<Outlet> outlets, double screenWidth) {
    final double spacing = screenWidth * 0.04;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing * 0.8,
        childAspectRatio: 1.1,
      ),
      itemCount: outlets.length,
      itemBuilder: (context, index) {
        final Outlet outlet = outlets[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/customer-details',
              arguments: outlet.id.toString(),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(getOutletImage(outlet.outletName ?? "")),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: spacing,
                  left: spacing,
                  right: spacing,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outlet.outletName ?? "Unknown Outlet",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        outlet.locationName ?? "Unknown Location",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: screenWidth * 0.03,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _circleIcon(IconData icon, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: screenWidth * 0.05),
    );
  }

  String getOutletImage(String outletName) {
    if (outletName.startsWith("Quickmart")) {
      return "assets/images/dashboardimages/Quickmart.png";
    } else if (outletName.startsWith("Naivas")) {
      return "assets/images/dashboardimages/Naivas.png";
    } else if (outletName.startsWith("Car and General")) {
      return "assets/images/dashboardimages/Car-and-General.png";
    } else {
      return "assets/images/dashboardimages/Default.png";
    }
  }
}
