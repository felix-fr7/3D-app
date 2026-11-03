import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/recognition_response.dart';

class GodScreen extends StatefulWidget {
  final GodModel god;
  final File? capturedImage;

  const GodScreen({
    Key? key,
    required this.god,
    this.capturedImage,
  }) : super(key: key);

  @override
  State<GodScreen> createState() => _GodScreenState();
}

class _GodScreenState extends State<GodScreen> with TickerProviderStateMixin {
  late AnimationController _raysController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Audio Player
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    // 1. Rotating Divine Rays Animation
    _raysController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // 2. Pulsing Glow Animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    // 3. Auto-play Devotional Audio instantly
    _initAudio();
  }

  Future<void> _initAudio() async {
    var audioUrl = widget.god.audioUrl?.trim();
    if (audioUrl == null || audioUrl.isEmpty) {
      debugPrint('[Audio Notice]: No audio URL provided for ${widget.god.name}');
      return;
    }

    // Ensure valid absolute URL if relative
    if (audioUrl.startsWith('/')) {
      audioUrl = 'http://127.0.0.1:5000$audioUrl';
    }

    try {
      final player = AudioPlayer();
      _audioPlayer = player;

      // Set explicit Android AudioContext for Media volume
      await player.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.duckOthers},
          ),
        ),
      );

      player.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state == PlayerState.playing;
          });
        }
      });

      player.onLog.listen((msg) {
        debugPrint('[AudioPlayer Log]: $msg');
      });

      await player.setVolume(1.0);
      await player.setReleaseMode(ReleaseMode.loop);

      debugPrint('[AudioPlayer] Playing devotional stream: $audioUrl');
      await player.play(UrlSource(audioUrl));
    } catch (e) {
      debugPrint('[Devotional Audio Error]: $e');
      // Resilient fallback: If Cloudinary stream fails (e.g., offline or network hiccup), fallback to local backend stream
      if (audioUrl.startsWith('https://res.cloudinary.com')) {
        final localFallback = 'http://127.0.0.1:5000/audio/${widget.god.code}.mp3';
        debugPrint('[AudioPlayer] Retrying with local backend stream: $localFallback');
        try {
          await _audioPlayer?.play(UrlSource(localFallback));
        } catch (fbErr) {
          debugPrint('[AudioPlayer Local Fallback Error]: $fbErr');
        }
      }
    }
  }

  void _stopAndGoBack() {
    _audioPlayer?.stop();
    _audioPlayer?.dispose();
    _audioPlayer = null;
    Navigator.pop(context);
  }

  void _toggleMute() {
    if (_audioPlayer == null) return;
    setState(() {
      _isMuted = !_isMuted;
    });
    _audioPlayer!.setVolume(_isMuted ? 0.0 : 1.0);
  }

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      }
    } catch (_) {}
    return const Color(0xFFFFD700); // Default Divine Gold
  }

  @override
  void dispose() {
    _raysController.dispose();
    _pulseController.dispose();
    _audioPlayer?.stop();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _parseHexColor(widget.god.glowColor);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    // Responsive dimensions that prevent any horizontal or vertical overflow
    final raySize = math.min(screenWidth - 48, 290.0);
    final cardWidth = math.min(screenWidth * 0.52, 200.0);
    final cardHeight = cardWidth * 1.30;
    final stackHeight = math.max(raySize, cardHeight) + 40.0;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _audioPlayer?.stop();
        _audioPlayer?.dispose();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A16), // Deep Cosmic Night
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: _stopAndGoBack,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.god.name,
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            if (widget.god.audioUrl != null && widget.god.audioUrl!.isNotEmpty)
              IconButton(
                icon: Icon(
                  _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: themeColor,
                  size: 26,
                ),
                tooltip: _isMuted ? 'Unmute' : 'Mute',
                onPressed: _toggleMute,
              ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==========================================
                // 1. DIVINE GLOWING AURA & DEITY IMAGE
                // ==========================================
                SizedBox(
                  height: stackHeight,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Sunburst Divine Light Rays
                      AnimatedBuilder(
                        animation: _raysController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _raysController.value * 2 * math.pi,
                            child: CustomPaint(
                              size: Size(raySize, raySize),
                              painter: DivineRaysPainter(
                                color: themeColor.withOpacity(0.48),
                                rayCount: 18,
                              ),
                            ),
                          );
                        },
                      ),

                      // Pulsing Halo Glow Ring
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: (raySize * 0.78) * _pulseAnimation.value,
                            height: (raySize * 0.78) * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  themeColor.withOpacity(0.60),
                                  themeColor.withOpacity(0.22),
                                  Colors.transparent,
                                ],
                                stops: const [0.2, 0.65, 1.0],
                              ),
                            ),
                          );
                        },
                      ),

                      // Deity Artwork / Scanned Photo
                      Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withOpacity(0.70),
                              blurRadius: 28,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: widget.capturedImage != null
                              ? Image.file(widget.capturedImage!, fit: BoxFit.cover)
                              : (widget.god.imageUrl.isNotEmpty
                                  ? Image.network(
                                      widget.god.imageUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder: (_, child, prog) => prog == null
                                          ? child
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color: themeColor,
                                              ),
                                            ),
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.black45,
                                        child: Icon(Icons.temple_hindu, color: themeColor, size: 60),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.black45,
                                      child: Icon(Icons.temple_hindu, color: themeColor, size: 60),
                                    )),
                        ),
                      ),

                      // Divine Badge
                      Positioned(
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: themeColor, width: 1.6),
                            boxShadow: [
                              BoxShadow(color: themeColor.withOpacity(0.45), blurRadius: 10),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🕉️ ', style: TextStyle(fontSize: 13)),
                              Text(
                                widget.god.code,
                                style: TextStyle(
                                  color: themeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==========================================
                // 2. DEITY TITLE & NAME
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.god.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.god.title != null && widget.god.title!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.god.title!,
                      style: TextStyle(
                        color: themeColor,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                // Live Audio Wave indicator (Strictly Constrained)
                if (_isPlaying && !_isMuted) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: themeColor.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.music_note_rounded, color: themeColor, size: 18),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(5, (index) {
                            return AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (_, __) {
                                final heights = [10.0, 18.0, 13.0, 22.0, 11.0];
                                final mult = (index % 2 == 0)
                                    ? _pulseAnimation.value
                                    : (2.0 - _pulseAnimation.value);
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: 3.0,
                                  height: (heights[index] * mult).clamp(5.0, 22.0),
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.god.audioTitle ?? 'Playing Sacred Chant...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter that draws rotating divine light rays (Sunburst / Chakra Aura)
class DivineRaysPainter extends CustomPainter {
  final Color color;
  final int rayCount;

  DivineRaysPainter({required this.color, this.rayCount = 18});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angleStep = (2 * math.pi) / rayCount;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rayCount; i++) {
      final startAngle = i * angleStep;
      final sweepAngle = angleStep * 0.45;

      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DivineRaysPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.rayCount != rayCount;
}
