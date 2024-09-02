import 'dart:convert';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:share/share.dart';
import 'package:social_media/snack_bar/widgets/common_snackbar.dart';


class FeedController extends GetxController {
  var posts = <Post>[].obs;
  var likedPosts = <String>{}.obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var tempImage = ''.obs;
  var tempVideo = ''.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    showChatNotification(
        id: 100,
        title: "Image Uploaded SuccessFully",
        body: "Test",
        data: "UploadingPage");
  }

  Future<void> addTextPost(String text) async {
    final post = Post(text: text);
    posts.add(post);
    await _savePostToFirestore(post);
  }

  Future<void> addImagePost() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      tempImage.value = pickedFile.path;
      isLoading.value = true;

      String downloadUrl = await _uploadFile(File(pickedFile.path), MediaType.image);
      final post = Post(imageUrl: downloadUrl);

      posts.add(post);
      tempImage.value = ''; // Clear preview
      isLoading.value = false;
      await _savePostToFirestore(post);
    }
  }

  Future<void> addVideoPost() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      tempVideo.value = pickedFile.path; // Show preview
      isLoading.value = true;

      try {
        String downloadUrl = await _uploadFile(File(pickedFile.path), MediaType.video);
        final post = Post(videoUrl: downloadUrl);

        posts.add(post);
        tempVideo.value = '';
        await _savePostToFirestore(post);
      } catch (e) {
        log("Error uploading video: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }



  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();
      posts.clear();

      for (var doc in snapshot.docs) {
        Post post = Post.fromDocument(doc);
        log("Fetched post: ${post.toMap()}");

        if (await _isMediaValid(post) && !posts.any((existingPost) => existingPost.id == post.id)) {
          posts.add(post);
          log("Added post: ${post.toMap()}");
        } else {
          await _firestore.collection('posts').doc(post.id).delete();
        }
      }
    } catch (e) {
      _handleError("Failed to load posts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _uploadFile(File file, MediaType mediaType) async {
    try {
      if (mediaType == MediaType.image) {
        // Compress image
        final image = img.decodeImage(await file.readAsBytes());
        final compressedFile = File('${file.path}_compressed.jpg')
          ..writeAsBytesSync(img.encodeJpg(image!, quality: 85));

        file = compressedFile;
      }
      await showChatNotification(
          id: 100,
          title: "Image Uploaded SuccessFully",
          body: "Test",
          data: "UploadingPage");

      String fileName = '${mediaType == MediaType.image ? 'images' : 'videos'}/${DateTime.now().millisecondsSinceEpoch}';
      Reference ref = _storage.ref().child(fileName);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      _handleError("File upload failed: $e");
      return '';
    }
  }

  Future<void> _savePostToFirestore(Post post) async {
    try {
      DocumentReference docRef = await _firestore.collection('posts').add(post.toMap());
      post.id = docRef.id;
    } catch (e) {
      _handleError("Failed to save post: $e");
    }
  }

  void removePost(String postId) async {
    try {
      Post? postToRemove = posts.firstWhere((post) => post.id == postId);

      if (postToRemove.imageUrl != null) {
        await _deleteFileFromStorage(postToRemove.imageUrl!);
      } else if (postToRemove.videoUrl != null) {
        await _deleteFileFromStorage(postToRemove.videoUrl!);
      }

      await _firestore.collection('posts').doc(postId).delete();
      posts.removeWhere((post) => post.id == postId);
    } catch (e) {
      _handleError("Failed to delete post: $e");
    }
  }

  Future<void> _deleteFileFromStorage(String url) async {
    try {
      Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      _handleError("Failed to delete file: $e");
    }
  }

  Future<bool> _isMediaValid(Post post) async {
    if (post.imageUrl != null) {
      return await _checkFileExists(post.imageUrl!);
    } else if (post.videoUrl != null) {
      return await _checkFileExists(post.videoUrl!);
    }
    return true;
  }

  Future<bool> _checkFileExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void likePost(String postId) {
    if (likedPosts.contains(postId)) {
      likedPosts.remove(postId);
    } else {
      likedPosts.add(postId);
    }
  }

  void addComment(String postId, String comment) async {
    // Add logic to handle comments
  }

  void sharePost(String url) {
    if (url.isNotEmpty) {
      Share.share('Check out this post: $url');
    }
  }

  void _handleError(String message) {
    showSnackBar(title: "Error", msg: message);
  }



  Future<void> showChatNotification(
      {String? title, String? body, String? data, int? id = 0}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      "100", // A unique ID for the notification channel
      'Chat Notifiation', // A name for the channel
      channelDescription:
      'Notification from driver', // A description for the channel
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const IOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: IOS);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
        id ?? 0, // Notification ID
        '$title', // Title
        '$body', // Body
        platformChannelSpecifics,
        payload: "$data");
  }


  Future<void> sendPushNotification({
    required String title,
    required String body,
    required String token, // FCM token of the target device
  }) async {
    try {
      const String serverKey = ''; // In My Firebaseconsole i could not to create the sever key

      final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      final Map<String, dynamic> notification = {
        'title': title,
        'body': body,
      };

      final Map<String, dynamic> data = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK', // To handle notification tap in Flutter
        'status': 'done',
      };

      final Map<String, dynamic> payload = {
        'notification': notification,
        'data': data,
        'to': token, // Target device's FCM token
      };

      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey', //Mark I could not create server key in my free fire base account
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        log('Push notification sent successfully');
      } else {
        log('Failed to send push notification: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending push notification: $e');
    }
  }





}

class Post {
  String? id;
  final String? text;
  final String? imageUrl;
  final String? videoUrl;

  Post({this.id, this.text, this.imageUrl, this.videoUrl});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      text: doc['text'] as String?, // Ensure type casting
      imageUrl: doc['imageUrl'] as String?,
      videoUrl: doc['videoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}


enum MediaType { image, video }
