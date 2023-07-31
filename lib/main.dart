import 'package:chat_app/auth_service.dart';
import 'package:chat_app/chat/bloc/chat_bloc.dart';
import 'package:chat_app/local_notifications.dart';
import 'package:chat_app/login/bloc/login_bloc.dart';
import 'package:chat_app/notification/bloc/notification_bloc.dart';
import 'package:chat_app/signup/bloc/signup_bloc.dart';
import 'package:chat_app/splash_view.dart';
import 'package:chat_app/users/bloc/users_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> initializePushNotifications() async {
  try {
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
    if (!kIsWeb) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('firebase exception -> $e');
    }
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializePushNotifications();
  runApp(const MyApp());
}

late String user2Email;
late double width;
late double height;
late double font;
late String emailId;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{


  AuthService service = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    LocalNotificationService.initialize();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint("Initial Message ${message.toString()}");
    });
    LocalNotificationService.messageListener(context);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("Message on App opened ${event.toString()}");
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("on message opened app");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Call updateOnlineStatus(false) when the app is paused or stopped
      service.updateStatus('offline', emailId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              authService: context.read<AuthService>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(
              authService: context.read<AuthService>(),
            ),
          ),
          BlocProvider(create: (context) => SignUpBloc(authService: context.read<AuthService>())),
          BlocProvider(
            create: (context) => UsersBloc(
              authService: context.read<AuthService>(),
            ),
          ),
          BlocProvider(create: (context) => ChatBloc())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashView(),
        ),
      ),
    );
  }
}
