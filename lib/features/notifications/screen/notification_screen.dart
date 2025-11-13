import 'package:finance_track/core/extentions/modified_colors.dart';
import 'package:finance_track/core/models/notification_model.dart';
import 'package:finance_track/core/utils/colors/app_colors.dart';
import 'package:finance_track/core/utils/popups/toast.dart';
import 'package:finance_track/features/notifications/logic/notification_cubit.dart';
import 'package:finance_track/features/notifications/logic/notification_state.dart';
import 'package:finance_track/features/notifications/screen/widget/notification_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..getNotifications(),
      child: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status.isSuccess) {
          notifications = state.notifications ?? [];
        }
        if (state.status.isError) {
          ToastNotifier.showError(state.errorMessage ?? "Something went wrong");
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white.modify(
              colorCode: AppColors.mainAppColor,
            ),
            actions: [
              state.notifications != null && state.notifications!.isNotEmpty
                  ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        final cubit = context.read<NotificationCubit>();

                        if (value == 'mark_all_read') {
                          cubit.markAllNotificationsAsRead();
                        } else if (value == 'mark_all_unread') {
                          cubit.markAllNotificationsAsUnread();
                        } else if (value == 'delete') {
                          cubit.deleteAllNotifications();
                          ToastNotifier.showSuccess("All notification deleted");
                        }
                      },
                      itemBuilder: (context) => [
                        if (state.notifications != null &&
                            state.notifications!.isNotEmpty)
                          const PopupMenuItem(
                            value: 'mark_all_read',
                            child: Text('Mark All as Read'),
                          )
                        else
                          const PopupMenuItem(
                            value: 'mark_all_unread',
                            child: Text('Mark All as Unread'),
                          ),
                        const PopupMenuItem(
                          value: 'delete_all',
                          child: Text('Delete'),
                        ),
                      ],
                    )
                  : SizedBox.fromSize(),
            ],
            title: const Text(
              "Notifications",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Builder(
            builder: (context) {
              if (state.status.isLoading) {
                return const NotificationShimmer();
              }
              if (state.notifications == null || state.notifications!.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<NotificationCubit>().getNotifications();
                  },
                  color: Colors.white,
                  backgroundColor: Colors.white.modify(
                    colorCode: AppColors.mainAppColor,
                  ),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      SizedBox(height: 250.h),
                      if (state.notifications == null ||
                          state.notifications!.isEmpty)
                        const Center(
                          child: Text(
                            "No notifications found",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                );
              }
              final notifications = state.notifications ?? [];
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<NotificationCubit>().getNotifications();
                },
                color: Colors.white,
                backgroundColor: Colors.white.modify(
                  colorCode: AppColors.mainAppColor,
                ),
                child: ListView.builder(
                  itemCount: notifications.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final isNew =
                        notification.isRead == false ||
                        notification.isRead == null;

                    return Dismissible(
                      key: ValueKey(notification.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Notification"),
                            content: const Text(
                              "Are you sure you want to delete this notification?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                        return confirm ?? false;
                      },
                      onDismissed: (direction) async {
                        await context
                            .read<NotificationCubit>()
                            .deleteNotification(notification.id ?? '');
                        ToastNotifier.showSuccess("Notification deleted");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.modify(
                                  colorCode: AppColors.mainAppColor,
                                ),
                                child: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                              ),
                              if (isNew)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isNew
                                  ? Colors.black
                                  : Colors.grey.shade700,
                            ),
                          ),
                          subtitle: Text(notification.message),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              final cubit = context.read<NotificationCubit>();
                              if (value == 'mark_read') {
                                cubit.markNotificationAsRead(
                                  notification.id ?? '',
                                );
                              } else if (value == 'mark_unread') {
                                cubit.markNotificationAsUnread(
                                  notification.id ?? '',
                                );
                              } else if (value == 'delete') {
                                await cubit.deleteNotification(
                                  notification.id ?? '',
                                );
                                ToastNotifier.showSuccess(
                                  "Notification deleted",
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              if (isNew)
                                const PopupMenuItem(
                                  value: 'mark_read',
                                  child: Text('Mark as Read'),
                                )
                              else
                                const PopupMenuItem(
                                  value: 'mark_unread',
                                  child: Text('Mark as Unread'),
                                ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                          onTap: () async {
                            if (isNew) {
                              context
                                  .read<NotificationCubit>()
                                  .markNotificationAsRead(
                                    notification.id ?? '',
                                  );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
