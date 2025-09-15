import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  final unreadCount = 0.obs;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _listenForUnreadNotifications();
  }

  void _listenForUnreadNotifications() async {
    if (userId == null) return;
    FirebaseFirestore.instance.collection('users').doc(userId).snapshots().listen((userDoc) {
      final lastRead = userDoc.data()?['lastReadNotificationTimestamp'] as Timestamp?;
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .snapshots()
          .listen((snapshot) {
        int count = 0;
        for (final doc in snapshot.docs) {
          final createdAt = doc.data()['createdAt'];
          if (createdAt is Timestamp &&
              (lastRead == null || createdAt.seconds > lastRead.seconds)) {
            count++;
          }
        }
        unreadCount.value = count;
      });
    });
  }

  Future<void> markAllAsRead() async {
    if (userId == null) return;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'lastReadNotificationTimestamp': FieldValue.serverTimestamp(),
    });
    unreadCount.value = 0;
  }
}