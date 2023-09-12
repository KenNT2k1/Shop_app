import 'package:flutter/material.dart';
import 'package:flutter_imic05/music_app/screen_1.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/splash_bg.png'))),
          ),
          Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Feel the beat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Emmerse yourself into the world of music today',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 203,
                    height: 48,
                    decoration: ShapeDecoration(
                      gradient: const SweepGradient(
                        center: Alignment(0.18, 1.04),
                        startAngle: 0.28,
                        // endAngle: 0.4,
                        colors: [
                          Color(0xFF842ED7),
                          Color(0xFFDA28A8),
                          // Color(0xFF9C1CC9)
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.50),
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const Screen1();
                            },
                          ));
                        },
                        child: const Text('Continue',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white))),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
