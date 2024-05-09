// Necessary imports
// See docs for more info on imports: https://pub.dev/packages
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/ui/root_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Main function
Future<void> main() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Basic notification channel',
        defaultColor: const Color.fromARGB(255, 145, 200, 226),
        ledColor: Colors.white,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic Group',
      )
    ],
  );
  bool isAllowedNotification = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Initialises Supabase client with the URL of the project and an anon (public) key.
  await Supabase.initialize(
    url: '',
    anonKey:
        '',
  );
  // Runs the app with MyApp as the root widget.
  runApp(const MyApp());
}

// MyApp class
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Build method
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Root Page',
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}