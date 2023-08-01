import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/cinema/servide/cinema_service.dart';
import 'package:myecl/service/class/action.dart';
import 'package:myecl/service/local_notification_service.dart';
import 'package:myecl/service/providers/firebase_token_provider.dart';
import 'package:myecl/service/providers/messages_provider.dart';
import 'package:myecl/service/providers/topic_provider.dart';
import 'package:myecl/tools/logs/log.dart';
import 'package:myecl/tools/repository/repository.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';


void setUpNotification(WidgetRef ref) {
  final LocalNotificationService localNotificationService =
      LocalNotificationService();
  localNotificationService.init();

  final messageNotifier = ref.watch(messagesProvider.notifier);
  final firebaseToken = ref.watch(firebaseTokenProvider);
  final topicsNotifier = ref.watch(topicsProvider.notifier);
  final logger = Repository.logger;

  FirebaseMessaging.instance.requestPermission().then((value) {
    if (value.authorizationStatus == AuthorizationStatus.authorized) {
      firebaseToken.then((value) {
        messageNotifier.setFirebaseToken(value);
        messageNotifier.registerDevice();
        logger.writeLog(Log(
            message: "Firebase messaging token registered",
            level: LogLevel.info));
        topicsNotifier.getTopics();
      });
    }
  });

  Future<String> handleAction(Action action) async {
    final providers = {"cinema": cinemaProviders};
    final provider = providers[action.module];
    if (provider == null) {
      return "";
    }
    final information = provider[action.table];
    if (information == null) {
      return "";
    }
    final path = information.item1;
    final notifier = information.item2;
    ref.read(notifier).refresh();
    return path;
  }

  void handleMessages() async {
    tokenExpireWrapper(ref, () async {
      final messages = await messageNotifier.getMessages();
      messages.maybeWhen(
        data: (messageList) async {
          for (final message in messageList) {
            if (message.isVisible) {
              final action = message.action;
              if (action == null) {
                localNotificationService.showNotification(
                  message.context,
                  message.title,
                  message.content,
                );
              } else {
                final path = await handleAction(action);
                localNotificationService.showNotificationWithPayload(
                  message.context,
                  message.title,
                  message.content,
                  path,
                );
              }
            } else {
              final action = message.action;
              if (action != null) {
                handleAction(action);
              }
            }
          }
        },
        orElse: () {},
      );
    });
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    handleMessages();
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleMessages();
  });
}
