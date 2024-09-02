import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_media/feeds_page/widgets/video_player_widget.dart';
import '../../app_colors/common_app_colours.dart';
import '../controller/feeds_controller.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLiked = Get.find<FeedController>().likedPosts.contains(post.id);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Add more space between cards
      child: Card(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Stack(
          children: [
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Gray placeholder container
                    Container(
                      width: double.infinity,
                      height: 200.h, // Adjust height as needed
                      color: Colors.grey[300], // Gray background
                    ),
                    // Image with loading indicator
                    Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          // Image is fully loaded, return the image
                          return child;
                        } else {
                          // Show a loading indicator on top of the gray container
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Error handling
                        return const Center(child: Text('Failed to load image.'));
                      },
                    ),
                  ],
                ),
              ),
            if (post.videoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: VideoPlayerWidget(post.videoUrl!),
              ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : AppColors.kBlack.value,
                      ),
                      onPressed: onLike,
                    ),
                    IconButton(
                      icon: Icon(Icons.comment_outlined, color: AppColors.kBlack.value),
                      onPressed: onComment,
                    ),
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: AppColors.kBlack.value),
                      onPressed: onShare,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppColors.kBlack.value),
                      onPressed: () {
                        onDelete(); // Call the delete callback to remove from Firebase
                        Get.find<FeedController>().posts.remove(post); // Instantly remove from UI
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
