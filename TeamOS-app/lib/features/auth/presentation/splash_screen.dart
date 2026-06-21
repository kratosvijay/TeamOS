import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    useEffect(() {
      animationController.forward();
      // Simulate token parsing check
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          context.go('/login');
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Premium Dark Slate
      body: Center(
        child: FadeTransition(
          opacity: animationController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TeamOS Brand Logo Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.space_dashboard_rounded,
                  size: 45,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'TeamOS',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enterprise AI Collaboration OS',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
