import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io'; // New import
import 'package:http/http.dart' as http; // New import
import 'package:path_provider/path_provider.dart';

// 1. Top-level background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized first

  // 2. Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 3. Initialize Notification Service
  await NotificationService.init();

  runApp(const MaterialApp(home: HomeScreen()));
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  // Helper method to download the image for the notification
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }


  static Future<void> init() async {
    // Request permissions for iOS/Android 13+
    await FirebaseMessaging.instance.requestPermission();

    // Android Setup
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/Darwin Setup
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    // 4. THE FIX: Use 'settings' named parameter (Required in v21.0.0+)
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print("Notification tapped: ${details.payload}");
      },
    );

    // 5. Handle Foreground Messages (Manual trigger for heads-up)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    // 1. Extract image URL from the FCM message
    String? imageUrl = message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl;

    BigPictureStyleInformation? bigPictureStyle;

    // 2. If image exists, download it and create the style
    if (imageUrl != null) {
      final String largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
      final String bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');

      bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: message.notification?.title,
        summaryText: message.notification?.body,
      );
    }
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    await _localNotifications.show(
      id: message.notification.hashCode,                           // Explicitly named
      title: message.notification?.title,      // Explicitly named
      body: message.notification?.body,        // Explicitly named
      notificationDetails: const NotificationDetails(android: androidDetails),     // Note: 'details' is also now 'notificationDetails'
      payload: message.data.toString(),);

  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Remote Notifications App")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? token = await FirebaseMessaging.instance.getToken();
            print("FCM Token: $token"); // Copy this to Firebase Console to test
          },
          child: const Text("Get FCM Token"),
        ),
      ),
    );
  }
}
