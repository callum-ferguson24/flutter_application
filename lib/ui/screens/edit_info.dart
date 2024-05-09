// Necessary Imports
// See docs for more info on imports: https://pub.dev/packages
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/auxilliary/network.dart';
import 'package:flutter_application/ui/root_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class EditInfo extends StatefulWidget {
  String name;
  EditInfo(String this.name, {super.key});

  @override
  State<EditInfo> createState() => _EditInfoState(name);
}

class _EditInfoState extends State<EditInfo> {
  
  String name;
  _EditInfoState(String this.name);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    final User? user = supabase.auth.currentUser;
    return Scaffold(

      // App bar
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Account Info', style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        
              // Spacing
              const SizedBox(
                height: 20,
              ),
        
              // Profile Picture
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey,width: 5.0,),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        final imagePicker = ImagePicker();
                        Future<void> uploadPicture(XFile picture) async {
                          String userId = user.id;
                          final avatarFile = File(picture.path);
                          try {
                            await supabase.storage
                              .from('avatars')
                              .update(
                                '$userId/avatar.png',
                                avatarFile,
                                fileOptions: const FileOptions(
                                  cacheControl: '3600', upsert: false),
                              );
                              setState(() {});
                          } catch (Exception) {
                            await supabase.storage
                              .from('avatars')
                              .upload(
                                '$userId/avatar.png',
                                avatarFile,
                                fileOptions: const FileOptions(
                                  cacheControl: '3600', upsert: false),
                              );

                              setState(() {});
                          }
                          Navigator.pushAndRemoveUntil(context, PageTransition(child: const RootPage(),type: PageTransitionType.bottomToTop) , (route) => false);
                        }

                        //Image methods
                        Future getImage() async {
                          var myImage = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (myImage != null) {
                            uploadPicture(myImage);
                          }
                        }

                        getImage();

                      },
                      child: FutureBuilder(
                        future: getDatabaseImage(user!.id),
                        builder: (BuildContext context, AsyncSnapshot imageSnapshot) {
                          if (imageSnapshot.hasData) {
                            return CircleAvatar(
                              radius: 150,
                              backgroundImage: MemoryImage(imageSnapshot.data),
                            );
                          } else {
                            return const CircleAvatar(
                              radius: 150,
                              backgroundImage:
                                  ExactAssetImage('assets/blank_profile.png'),
                            );
                          }
                        }
                      )
                    ),
                  ),
                ],
              ),
        
              // Spacing
              const SizedBox(
                        height: 80,
                      ),

              // Edit Username Text
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Edit Username',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              // Spacing
              const SizedBox(
                height: 10,
              ),
        
              //Edit Username TextField
              TextField(
                controller: myController,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none,)),
                  filled: true,
                  prefixIcon: const Icon(Icons.account_circle, color: Colors.black38),
                  hintText: name, hintStyle: const TextStyle(color: Colors.black38)
                ),
              ),

              // Spacing
              const SizedBox(
                height: 20,
              ),

              // Update Info Button
              GestureDetector(
                onTap: () async {
                  String newName = myController.text;
                  if(newName != ""){
                    await supabase
                    .from('profiles')
                    .update({'username': newName})
                    .match({'id': user.id});

                    AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 1,
                        channelKey: 'basic_channel',
                        title: 'Flight Removed',
                        body: 'Flight has been removed from your favourites.',
                      ),
                    );

                    setState(() {});
                    Navigator.pushAndRemoveUntil(context, PageTransition(child: const RootPage(),type: PageTransitionType.bottomToTop), (route) => false);
                  } else{
                    Navigator.pushAndRemoveUntil(context, PageTransition(child: const RootPage(),type: PageTransitionType.bottomToTop), (route) => false);
                  }
                },
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: const Center(
                    child: Text(
                      'Update Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
        
            ]
          ),
        ),
      ),

    );
  }
}
    