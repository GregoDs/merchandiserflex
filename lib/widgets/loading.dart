import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  final Color color;
  final String? message;

  const LoadingPage({super.key, this.color = Colors.white, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: Theme.of(context).colorScheme.secondary,
              size: 40.0,
            ),
            const SizedBox(height: 16),
            if (message != null)
              Text(
                message!,
                style: const TextStyle(
                  color: Colors.black54,
                  fontFamily: 'montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}