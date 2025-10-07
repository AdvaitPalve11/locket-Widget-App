import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/photo_service.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';

class EnhancedCameraScreen extends StatefulWidget {
  const EnhancedCameraScreen({super.key});

  @override
  State<EnhancedCameraScreen> createState() => _EnhancedCameraScreenState();
}

class _EnhancedCameraScreenState extends State<EnhancedCameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final PhotoService _photoService = PhotoService();
  final AuthService _authService = AuthService();
  final TextEditingController _captionController = TextEditingController();
  
  XFile? _selectedMedia;
  bool _isVideo = false;
  bool _isUploading = false;
  String _mediaType = 'photo';
  
  // Caption styling options
  Color _captionColor = Colors.white;
  double _captionFontSize = 18.0;
  FontWeight _captionFontWeight = FontWeight.normal;
  TextAlign _captionAlignment = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Media selection area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[900],
              ),
              child: _selectedMedia == null
                  ? _buildMediaSelectionOptions()
                  : _buildMediaPreview(),
            ),
          ),

          // Caption area
          if (_selectedMedia != null) ...[
            _buildCaptionSection(),
            const SizedBox(height: 16),
          ],

          // Action buttons
          _buildActionButtons(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMediaSelectionOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.add_photo_alternate_outlined,
          size: 80,
          color: Colors.grey,
        ),
        const SizedBox(height: 24),
        const Text(
          'Select or capture media',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        
        // Media selection buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMediaOption(
              icon: Icons.photo_camera,
              label: 'Camera',
              color: const Color(0xFF6C5CE7),
              onTap: () => _selectMedia(ImageSource.camera, false),
            ),
            _buildMediaOption(
              icon: Icons.videocam,
              label: 'Video',
              color: Colors.red,
              onTap: () => _selectMedia(ImageSource.camera, true),
            ),
            _buildMediaOption(
              icon: Icons.photo_library,
              label: 'Gallery',
              color: Colors.green,
              onTap: _selectFromGallery,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _isVideo
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[800],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline, color: Colors.white, size: 64),
                      SizedBox(height: 8),
                      Text(
                        'Video Selected',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Image.file(
                  File(_selectedMedia!.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        
        // Caption overlay
        if (_captionController.text.isNotEmpty)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _captionController.text,
                style: TextStyle(
                  color: _captionColor,
                  fontSize: _captionFontSize,
                  fontWeight: _captionFontWeight,
                ),
                textAlign: _captionAlignment,
              ),
            ),
          ),

        // Change media button
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMedia = null;
                _captionController.clear();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add a caption',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          // Caption input
          TextField(
            controller: _captionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'What\'s happening?',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterStyle: TextStyle(color: Colors.grey[400]),
            ),
            onChanged: (text) => setState(() {}),
          ),
          
          // Caption styling options
          if (_captionController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildCaptionStylingOptions(),
          ],
        ],
      ),
    );
  }

  Widget _buildCaptionStylingOptions() {
    return Row(
      children: [
        // Color picker
        GestureDetector(
          onTap: _showColorPicker,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _captionColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Font size
        Icon(Icons.format_size, color: Colors.grey[400], size: 20),
        const SizedBox(width: 4),
        Text(
          '${_captionFontSize.toInt()}',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        
        const SizedBox(width: 16),
        
        // Bold toggle
        GestureDetector(
          onTap: () {
            setState(() {
              _captionFontWeight = _captionFontWeight == FontWeight.bold
                  ? FontWeight.normal
                  : FontWeight.bold;
            });
          },
          child: Icon(
            Icons.format_bold,
            color: _captionFontWeight == FontWeight.bold ? Colors.white : Colors.grey[400],
            size: 20,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Alignment
        GestureDetector(
          onTap: _toggleAlignment,
          child: Icon(
            _captionAlignment == TextAlign.left
                ? Icons.format_align_left
                : _captionAlignment == TextAlign.center
                    ? Icons.format_align_center
                    : Icons.format_align_right,
            color: Colors.grey[400],
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Share button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _selectedMedia != null && !_isUploading ? _shareMedia : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[700],
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _selectedMedia == null ? 'Select Media' : 'Share $_mediaType',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectMedia(ImageSource source, bool isVideo) async {
    try {
      final XFile? media;
      if (isVideo) {
        media = await _picker.pickVideo(
          source: source,
          maxDuration: const Duration(seconds: 30), // 30-second limit like Snapchat
        );
        _mediaType = 'video';
      } else {
        media = await _picker.pickImage(
          source: source,
          imageQuality: 90,
        );
        _mediaType = 'photo';
      }

      if (media != null) {
        setState(() {
          _selectedMedia = media;
          _isVideo = isVideo;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting media: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectFromGallery() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select from Gallery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildGalleryOption(
                    icon: Icons.photo,
                    label: 'Photo',
                    onTap: () {
                      Navigator.pop(context);
                      _selectMedia(ImageSource.gallery, false);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGalleryOption(
                    icon: Icons.videocam,
                    label: 'Video',
                    onTap: () {
                      Navigator.pop(context);
                      _selectMedia(ImageSource.gallery, true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker() {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Caption Color',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _captionColor = color;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color == _captionColor ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _toggleAlignment() {
    setState(() {
      if (_captionAlignment == TextAlign.left) {
        _captionAlignment = TextAlign.center;
      } else if (_captionAlignment == TextAlign.center) {
        _captionAlignment = TextAlign.right;
      } else {
        _captionAlignment = TextAlign.left;
      }
    });
  }

  Future<void> _shareMedia() async {
    if (_selectedMedia == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create caption style data
      final captionStyle = _captionController.text.isNotEmpty
          ? {
              'color': _captionColor.value,
              'fontSize': _captionFontSize,
              'fontWeight': _captionFontWeight.index,
              'alignment': _captionAlignment.index,
            }
          : null;

      final success = await _photoService.uploadMedia(
        File(_selectedMedia!.path),
        caption: _captionController.text.isEmpty ? null : _captionController.text,
        captionStyle: captionStyle,
        mediaType: _mediaType,
      );

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_mediaType.capitalize()} shared successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload $_mediaType'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}