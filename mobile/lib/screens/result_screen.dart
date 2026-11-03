import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recognition_response.dart';

class ResultScreen extends StatefulWidget {
  final RecognitionResponse result;
  final File capturedImage;

  const ResultScreen({
    Key? key,
    required this.result,
    required this.capturedImage,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final landmark = widget.result.landmark!;
    final locality = widget.result.locality;
    final district = widget.result.district;
    final confidencePct = (widget.result.confidence * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Discovery & Facts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Header Card: Matched Landmark & Confidence Badge
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    widget.capturedImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        landmark.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Code: ${landmark.code}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      // Confidence Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Confidence: $confidencePct% (${widget.result.goodMatches} matches)',
                          style: const TextStyle(
                            color: Color(0xFF15803D),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Strict Fact Separation Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF4F46E5),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF4F46E5),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(
                  icon: Icon(Icons.location_on),
                  text: 'Locality Facts',
                ),
                Tab(
                  icon: Icon(Icons.account_balance),
                  text: 'District Facts',
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. STRICT LOCALITY FACTS VIEW
                _buildLocalityTab(locality),

                // 2. STRICT DISTRICT FACTS VIEW
                _buildDistrictTab(district),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalityTab(LocalityModel? locality) {
    if (locality == null) {
      return const Center(child: Text('No locality data found.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Locality Info Header
        Card(
          elevation: 0,
          color: const Color(0xFFEEF2FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locality.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3730A3),
                  ),
                ),
                if (locality.pincode != null) ...[
                  const SizedBox(height: 4),
                  Text('Pincode: ${locality.pincode}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                ],
                if (locality.description != null) ...[
                  const SizedBox(height: 6),
                  Text(locality.description!, style: TextStyle(color: Colors.grey[800], fontSize: 13)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        const Text(
          'Neighborhood & Local Lore',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 8),

        if (locality.facts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No locality-specific facts recorded yet.'),
          )
        else
          ...locality.facts.map((fact) => _buildFactCard(
                title: fact.title,
                type: fact.factType,
                content: fact.content,
                mediaUrl: fact.mediaUrl,
                mediaType: fact.mediaType,
              )),
      ],
    );
  }

  Widget _buildDistrictTab(DistrictModel? district) {
    if (district == null) {
      return const Center(child: Text('No district data found.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // District Info Header
        Card(
          elevation: 0,
          color: const Color(0xFFFEF3C7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${district.name} District (${district.code})',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                if (district.description != null) ...[
                  const SizedBox(height: 6),
                  Text(district.description!, style: TextStyle(color: Colors.brown[900], fontSize: 13)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        const Text(
          'District Heritage & History',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 8),

        if (district.facts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No district-level facts recorded yet.'),
          )
        else
          ...district.facts.map((fact) => _buildFactCard(
                title: fact.title,
                type: fact.factType,
                content: fact.content,
                mediaUrl: fact.mediaUrl,
                mediaType: fact.mediaType,
                source: fact.source,
              )),
      ],
    );
  }

  Widget _buildFactCard({
    required String title,
    required String type,
    required String content,
    String? mediaUrl,
    String? mediaType,
    String? source,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 13.5, height: 1.4, color: Color(0xFF334155)),
            ),
            // Cloudinary Image Preview (with tap-to-expand)
            if (mediaUrl != null && mediaUrl.isNotEmpty && mediaType != 'video') ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showFullscreenImage(context, mediaUrl, title),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.network(
                        mediaUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 180,
                            color: const Color(0xFFF1F5F9),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: const Color(0xFFF8FAFC),
                          child: const Center(
                            child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fullscreen, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Tap to zoom', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Interactive Cultural Video Stream Card
            if (mediaType == 'video' && mediaUrl != null) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showVideoPlayerModal(context, title: title, content: content, videoUrl: mediaUrl),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video watermark pattern
                      const Opacity(
                        opacity: 0.15,
                        child: Icon(Icons.movie_creation_outlined, size: 90, color: Colors.white),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
                              ],
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF4F46E5), size: 36),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.ondemand_video, color: Colors.amber, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'Cultural Video Clip (Tap to Watch)',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('HD VIDEO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (source != null && source.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Source: $source',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Fullscreen zoomable image dialog
  void _showFullscreenImage(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text('Image unavailable', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive video playback / stream viewer modal
  void _showVideoPlayerModal(BuildContext context, {required String title, required String content, required String videoUrl}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5, height: 1.4),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_done, color: Color(0xFF10B981), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cloudinary Secure Stream', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(videoUrl, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Done / மூடவும்', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

