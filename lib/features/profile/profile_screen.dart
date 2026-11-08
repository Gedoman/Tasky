import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/features/profile/user_details_screen.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';
import '../../constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../core/widgets/custom_svg_picture.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String? quote;
  bool isLoading = true;
  String? userImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    setState(() {
      username = PreferencesManager().getString(StorageKey.username) ?? "";
      quote =
          PreferencesManager().getString("quote") ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString("user_image");

      isLoading = false;
    });
  }

  void _logout() async {
    await PreferencesManager().remove(StorageKey.username);
    await PreferencesManager().remove("quote");
    await PreferencesManager().remove("tasks");
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (rout) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: userImagePath == null
                            ? AssetImage('assets/images/person.jpeg')
                            : FileImage(File(userImagePath!)),
                        radius: 60,
                        backgroundColor: Colors.transparent,
                      ),
                      GestureDetector(
                        onTap: () async {
                          _showImageSourceDialog(context, (XFile file){
                            _saveImage(file);
                            setState(() {
                              userImagePath = file.path;
                            });
                          });

                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(username, style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    quote ?? "One task at a time. One step closer.",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Info",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return UserDetailsScreen();
                                        },
                                      ),
                                    );
                                    if (result != null && result) {
                                      _loadUserData();
                                    }
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("User Details"),
                                  leading: CustomSvgPicture(
                                    path: "assets/icons/profile_Icon.svg",
                                  ),
                                  trailing: CustomSvgPicture(
                                    path: "assets/icons/Icon4.svg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(thickness: 1),
                          ListTile(
                            title: Text("Dark Mode"),
                            leading: CustomSvgPicture(
                              path: 'assets/icons/Icon5.svg',
                              withColorFilter: true,
                            ),
                            trailing: ValueListenableBuilder(
                              valueListenable: ThemeController.themeNotifier,
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                    return Switch(
                                      value: value == ThemeMode.dark,
                                      onChanged: (bool value) {
                                        ThemeController.toggleTheme();
                                      },
                                    );
                                  },
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          Divider(thickness: 1),
                          ListTile(
                            onTap: () {
                              _logout();
                            },
                            contentPadding: EdgeInsets.zero,
                            title: Text("Log Out"),
                            leading: CustomSvgPicture(
                              path: "assets/icons/out.svg",
                            ),
                            trailing: CustomSvgPicture(
                              path: "assets/icons/Icon4.svg",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

void _showImageSourceDialog(BuildContext context , Function(XFile) selectedFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(
          "Choose Image Source",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async{
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
              if(image != null){
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text("Camera"),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async{
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
              if(image != null){
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text("Gallery"),
              ],
            ),
          ),
        ],
      );
    },
  );
}
void _saveImage(XFile file) async{
  final appDir = await getApplicationCacheDirectory();
  final newFile = await File(file.path).copy("${appDir.path}/${file.name}");
  PreferencesManager().setString("user_image", newFile.path);
}
