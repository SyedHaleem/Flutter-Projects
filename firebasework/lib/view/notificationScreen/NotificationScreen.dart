import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasework/config/theme/app_Color.dart';
import 'package:firebasework/view/widgets/AppBar.dart';
import 'package:firebasework/view/widgets/AppRefreshIndicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String timeAgo(Timestamp timestamp) {
    final date = timestamp.toDate();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('yyyy-MM-dd').format(date);
  }
  Future<void> _refreshNotifications() async {
    // Optionally, you can force a re-fetch here if needed
    // But since StreamBuilder is real-time, you can just await a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    // If you use a controller to fetch notifications, call controller.reloadNotifications() here
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BasicAppbar(
        hideBackBtn: true,
        title: Text(
          'Notifications',
          style: TextStyle(
              color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: userId == null
          ? const Center(child: Text('Not logged in'))
        : AppRefreshIndicator(
    onRefresh: () => _refreshNotifications(),
    child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(userId)
            .collection('items')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final senderAvatarUrl = data['senderAvatarUrl'] ?? '';
              final senderName = data['senderName'] ?? '';
              final message = data['message'] ?? '';
              final createdAt = data['createdAt'] as Timestamp?;

              return Dismissible(
                key: Key(docs[index].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await docs[index].reference.delete();
                  Get.snackbar('Deleted',
                      'Notification deleted', backgroundColor: Colors.red, colorText: Get.theme.colorScheme.onError);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Notification deleted')),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 16),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: senderAvatarUrl.isNotEmpty
                            ? NetworkImage(senderAvatarUrl)
                            : null,
                        child: senderAvatarUrl.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              senderName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (createdAt != null)
                            Text(
                              timeAgo(createdAt),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          message,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Optionally, open blog details using blogId
                        // Example:
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => BlogDetailScreen(
                        //     blogId: data['blogId'],
                        //   ),
                        // ));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}