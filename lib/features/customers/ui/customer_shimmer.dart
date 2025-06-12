import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomerRow extends StatelessWidget {
  final double screenWidth;

  const ShimmerCustomerRow({Key? key, required this.screenWidth})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Define colors based on theme
    final baseColor = isDarkMode ? Colors.grey[900]! : Colors.grey[600]!;
    final highlightColor = isDarkMode ? Colors.grey[800]! : Colors.grey[400]!;
    final containerColor = isDarkMode ? Colors.grey[900]! : Colors.grey[900];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(6, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name shimmer
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 20,
                          width: 150,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Flexsave status shimmer
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 16,
                          width: 40,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Date shimmer
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 14,
                          width: 100,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Right side - Status and phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Status shimmer
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        height: 14,
                        width: 80,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Phone number shimmer
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}