import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/app_colors/common_app_colours.dart';
import 'package:social_media/app_loader/app_loader.dart';
import '../../common_strings/app_common_strings.dart';
import '../controller/feeds_controller.dart';
import '../widgets/post_card_widget.dart';

class FeedScreen extends GetView<FeedController> {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.black,
              expandedHeight: 150.0.h,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  kSocialMediaFare,
                  style: GoogleFonts.aBeeZee(
                    color: AppColors.kWhite.value,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Image.network(
                  'https://blog.ippon.fr/content/images/2023/09/RGFzaGF0YXJfRGV2ZWxvcGVyX092ZXJJdF9jb2xvcl9QR19zaGFkb3c-.png',
                  fit: BoxFit.cover,
                ),
              ),
              iconTheme: IconThemeData(color: AppColors.kWhite.value), // Set back button color here
            ),
            if (controller.isLoading.value)
              SliverFillRemaining(
                child: Center(child: AppLoader(color: AppColors.kBlack.value)),
              ),
            if (!controller.isLoading.value && controller.posts.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text(kNoPostAvailable)),
              ),
            if (controller.posts.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final post = controller.posts[index];
                    return PostCard(
                      post: post,
                      onDelete: () {
                        controller.removePost(post.id ?? "");
                      },
                      onLike: () {
                        controller.likePost(post.id ?? "");
                      },
                      onComment: () {
                        _showCommentBottomSheet(context, post.id!);
                      },
                      onShare: () {
                        controller.sharePost(post.imageUrl ?? post.videoUrl ?? '');
                      },
                    );
                  },
                  childCount: controller.posts.length,
                ),
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostOptions(context),
        backgroundColor: AppColors.kBlack.value,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image, color: AppColors.kWhite.value),
                title: Text(kAddImgPost, style: TextStyle(color: AppColors.kWhite.value)),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.addImagePost();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: AppColors.kWhite.value),
                title: Text(kAddVideoPost, style: TextStyle(color: AppColors.kWhite.value)),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.addVideoPost();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCommentBottomSheet(BuildContext context, String postId) {
    final TextEditingController commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kAddaComment,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: kEnterYourComment,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(kCancel, style: TextStyle(color: AppColors.kRed.value)),
                    ),
                    TextButton(
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          controller.addComment(postId, commentController.text);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(kComment, style: TextStyle(color: AppColors.kGreen.value)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

