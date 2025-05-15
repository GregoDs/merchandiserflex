import 'package:fl_chart/fl_chart.dart';
import 'package:flexmerchandiser/features/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexmerchandiser/features/home/cubit/home_cubit.dart';
import 'package:flexmerchandiser/features/home/ui/home_shimmer.dart';
import 'package:flexmerchandiser/features/home/models/outlets_model.dart';
import 'package:flexmerchandiser/widgets/scaffold_messengers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch outlets when the page loads
    context.read<HomeCubit>().fetchOutlets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopRow(),
                    SizedBox(height: 16),
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    _buildSecondRow(),
                    SizedBox(height: 10),
                    _buildGraphRow(),
                    SizedBox(height: 24),
                    Text(
                      "Outlets",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    BlocListener<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state is HomeError) {
                          CustomSnackBar.showError(
                            context,
                            title: "Oops!", // Generic title for error
                            message: state.message,
                          );
                        }
                      },
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoading) {
                            // Show shimmer effect while loading
                            return const HomeShimmer();
                          } else if (state is HomeSuccess) {
                            // Show outlet cards when data is fetched
                            final List<Outlet> outlets = state.outlets;
                            return _buildOutletsGrid(outlets);
                          } else if (state is HomeError) {
                            // Show shimmer effect on error
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

  Widget _buildTopRow() {
    return Row(
      children: [
        SizedBox(width: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            // Orange border covering 3/4 of the circle
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: 0.65, // 3/4 of the circle
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                backgroundColor: Colors.transparent,
              ),
            ),
            // Profile image
            CircleAvatar(radius: 35, child: Icon(Icons.person)),
          ],
        ),
        SizedBox(width: 30),
        // User details
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Afternoon",
              style: TextStyle(
                fontFamily: 'montserrat',
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 1),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    "6 Dec, 2025 at 12:43 pm",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildSecondRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _circleIcon(Icons.savings), // Icon for FlexChama
                  SizedBox(width: 8),
                  Text(
                    "FlexChama",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "x2.0",
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1),
          // Progress Bar with Percentage
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
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    "\120",
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 14,
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
          // Users and Funds Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Users Section
              Row(
                children: [
                  _circleIcon(Icons.people), // Icon for Users
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Users",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "67",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Funds Section
              Row(
                children: [
                  _circleIcon(Icons.people), // Icon for Funds
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Not in chama",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "3",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 14,
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

  Widget _buildGraphRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Conversion Activity",
          style: TextStyle(
            fontFamily: 'montserrat', // Updated font
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false, // Disable vertical grid lines
                horizontalInterval: 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.shade800,
                    strokeWidth: 1,
                    dashArray: [5, 5], // Dotted line pattern
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
                            fontFamily: 'montserrat', // Updated font
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
                          fontFamily: 'montserrat', // Updated font
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
                show: false, // Remove the border
              ),
              lineBarsData: [
                _lineData(
                  Colors.orangeAccent,
                  [10, 12, 15, 8, 10, 0], // Dummy data for calls made
                ),
                _lineData(
                  Colors.greenAccent,
                  [2, 1.5, 2, 1, 2, 0], // Dummy data for customers registered
                ),
              ],
              minX: 0,
              maxX: 5,
              minY: 0,
              maxY: 15, // Adjusted to start from 15
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
      barWidth: 4, // Adjusted thickness to match the image
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4, // Rounded dots
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

  Widget _buildOutletsGrid(List<Outlet> outlets) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 26,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1, // Reduced size
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
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outlet.outletName ?? "Unknown Outlet",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 14,
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
                          fontSize: 12,
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
