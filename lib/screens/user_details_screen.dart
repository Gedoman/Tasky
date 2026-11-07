import 'package:flutter/material.dart';

import 'package:tasky/core/widgets/custom_text_form_field.dart';

import '../core/services/preferences_manager.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  String username = "";
  String motivationQuote ="";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {


    setState(() {
      usernameController.text = PreferencesManager().getString("username") ?? "";
      quoteController.text =PreferencesManager().getString("quote") ?? "";
      
    });
  }

  void _saveUserData() async {
    if(_key.currentState!.validate()) {
      //final pref = await SharedPreferences.getInstance();

      await PreferencesManager().setString("username", usernameController.text);
      await PreferencesManager().setString("quote", quoteController.text);

      if (mounted) {
       Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              CustomTextFormField(
                controller: usernameController,
                hintText: username,
                title: "User Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter User Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: quoteController,
                hintText: "One task at a time. One step closer.",
                title: "Motivation Quote",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Motivation Quote";
                  }
                  return null;
                },
                maxLines: 5,
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                onPressed: _saveUserData,
                child:  Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
