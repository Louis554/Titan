
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/service/local_notification_service.dart';
import 'package:myecl/service/providers/firebase_token_provider.dart';
import 'package:myecl/service/providers/messages_provider.dart';
import 'package:myecl/tools/logs/log.dart';
import 'package:myecl/tools/repository/repository.dart';

void setUpNotification(WidgetRef ref) {
  final LocalNotificationService localNotificationService =
      LocalNotificationService();
  localNotificationService.init();

  final messageNotifier = ref.watch(messagesProvider.notifier);
  final firebaseToken = ref.watch(firebaseTokenProvider);
  final logger = Repository.logger;

  FirebaseMessaging.instance.requestPermission().then((value) {
    if (value.authorizationStatus == AuthorizationStatus.authorized) {
      logger.writeLog(Log(
          message: "Firebase messaging permission granted",
          level: LogLevel.info));
      firebaseToken.then((value) {
        messageNotifier.setFirebaseToken(value);
        messageNotifier.registerDevice();
        logger.writeLog(Log(
            message: "Firebase messaging token registered",
            level: LogLevel.info));
      });
    }
  });

  void handleMessages() async {
    final messages = await messageNotifier.getMessages();
    messages.when(
      data: (messageList) {
        messageList.map((message) {
          if (message.isVisible) {
            localNotificationService.showNotificationWithPayload(
              message.context,
              message.title,
              message.content,
              message.actionId,
            );
          }
        });
      },
      loading: () {},
      error: (error, stack) {
        localNotificationService.showNotification(
          'error',
          'Erreur',
          'Impossible de récupérer les notifications',
        );
      },
    );
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    handleMessages();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleMessages();
  });
}
