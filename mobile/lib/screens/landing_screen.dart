import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'camera_screen.dart';

class LandingScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const LandingScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openCamera() {
    if (widget.cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No camera detected on this device.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen(cameras: widget.cameras),
      ),
    );
  }

  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.lightbulb, color: Color(0xFFEA580C), size: 28),
            SizedBox(width: 8),
            Text(
              'Coloring & Scan Tips',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🎨 1. Point your camera at any Hindu God or temple landmark.',
              style: TextStyle(fontSize: 14.5, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '📸 2. Tap the banner or button to launch the live scanner.',
              style: TextStyle(fontSize: 14.5, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '✨ 3. Experience divine halo rays and auto-playing devotional songs and videos!',
              style: TextStyle(fontSize: 14.5, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '🗺️ 4. You can also scan Tamil Nadu district maps & cultural landmarks!',
              style: TextStyle(fontSize: 14.5, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Got It!',
              style: TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showExitDialog() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.exit_to_app_rounded, color: Color(0xFFEA580C), size: 28),
            SizedBox(width: 10),
            Text(
              'Exit App?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Do you want to exit the application?',
              style: TextStyle(fontSize: 15, color: Color(0xFF475569), height: 1.4),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                // 1. Tick Button (✓) -> STAY in the app
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pop(ctx), // Stay
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF16A34A).withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_rounded, color: Colors.white, size: 24),
                          SizedBox(width: 6),
                          Text(
                            'STAY',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. X Button (✕) -> EXIT the app
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      SystemNavigator.pop(); // Exit app
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.close_rounded, color: Colors.white, size: 24),
                          SizedBox(width: 6),
                          Text(
                            'EXIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _showExitDialog();
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: Stack(
        children: [
          // Background Floating Pastel Confetti Triangles
          CustomPaint(
            size: Size(size.width, size.height),
            painter: PastelConfettiPainter(),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // ==========================================
                          // 1. TOP HEADER WITH "TIPS" BUTTON
                          // ==========================================
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: _showTipsDialog,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFEA580C).withOpacity(0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'TIPS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.lightbulb,
                                            color: Color(0xFFEA580C),
                                            size: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // ==========================================
                          // 2. ILLUSTRATED HINDU GODS COLOURING BOOK STALL (CENTERPIECE)
                          // ==========================================
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: child,
                                );
                              },
                              child: GestureDetector(
                                onTap: _openCamera,
                                child: Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(maxWidth: 380),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // A. Awning Striped Canopy
                                      CustomPaint(
                                        size: const Size(double.infinity, 42),
                                        painter: AwningCanopyPainter(),
                                      ),

                                      // B. White Signboard with "HINDU GODS"
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 24),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          border: Border.symmetric(
                                            vertical: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.04),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'HINDU GODS',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF0F172A),
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // C. Shelf Base / Counter with "SONGS AND VIDEOS"
                                      Container(
                                        width: double.infinity,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Color(0xFFD97706), Color(0xFFB45309)],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.22),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'SONGS AND VIDEOS',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              letterSpacing: 1.5,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black45,
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ==========================================
                          // 3. CLEAN "TAP TO SCAN" BUTTON
                          // ==========================================
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _openCamera,
                                icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 22),
                                label: const Text(
                                  'TAP TO SCAN & EXPLORE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEA580C),
                                  elevation: 5,
                                  shadowColor: const Color(0xFFEA580C).withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}

/// Paints the alternating caramel and white scalloped awning canopy on top of the shop
class AwningCanopyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stripeCount = 13;
    final stripeWidth = size.width / stripeCount;

    final darkPaint = Paint()..color = const Color(0xFFD97706);
    final lightPaint = Paint()..color = const Color(0xFFFFFBEB);

    for (int i = 0; i < stripeCount; i++) {
      final isDark = i % 2 == 0;
      final paint = isDark ? darkPaint : lightPaint;
      final x = i * stripeWidth;

      final path = Path();
      path.moveTo(x, 0);
      path.lineTo(x + stripeWidth, 0);
      path.lineTo(x + stripeWidth, size.height - 8);
      // Scalloped bottom arc
      path.quadraticBezierTo(
        x + stripeWidth / 2,
        size.height,
        x,
        size.height - 8,
      );
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints subtle pastel geometric confetti triangles in the background
class PastelConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final confettiList = [
      {'x': 0.12, 'y': 0.08, 's': 14.0, 'c': const Color(0xFFFED7AA)}, // pale orange
      {'x': 0.85, 'y': 0.06, 's': 16.0, 'c': const Color(0xFFCCFBF1)}, // pale teal
      {'x': 0.08, 'y': 0.22, 's': 12.0, 'c': const Color(0xFFFBCFE8)}, // pale pink
      {'x': 0.92, 'y': 0.28, 's': 15.0, 'c': const Color(0xFFFEF08A)}, // pale yellow
      {'x': 0.15, 'y': 0.45, 's': 16.0, 'c': const Color(0xFFE9D5FF)}, // pale purple
      {'x': 0.88, 'y': 0.52, 's': 18.0, 'c': const Color(0xFFFED7AA)}, // pale orange
      {'x': 0.06, 'y': 0.68, 's': 15.0, 'c': const Color(0xFFCCFBF1)}, // pale teal
      {'x': 0.94, 'y': 0.72, 's': 14.0, 'c': const Color(0xFFFBCFE8)}, // pale pink
      {'x': 0.20, 'y': 0.85, 's': 18.0, 'c': const Color(0xFFFEF08A)}, // pale yellow
      {'x': 0.82, 'y': 0.88, 's': 16.0, 'c': const Color(0xFFE9D5FF)}, // pale purple
      {'x': 0.52, 'y': 0.38, 's': 12.0, 'c': const Color(0xFFCCFBF1)}, // center teal
    ];

    for (final item in confettiList) {
      final cx = (item['x'] as double) * size.width;
      final cy = (item['y'] as double) * size.height;
      final s = item['s'] as double;
      final color = item['c'] as Color;

      final paint = Paint()
        ..color = color.withOpacity(0.65)
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(cx, cy - s);
      path.lineTo(cx + s * 0.86, cy + s * 0.5);
      path.lineTo(cx - s * 0.86, cy + s * 0.5);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
