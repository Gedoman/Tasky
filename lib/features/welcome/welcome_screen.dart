import 'package:flutter/material.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/features/navigation/main_screen.dart';
import '../../core/services/preferences_manager.dart';
import '../../core/widgets/custom_svg_picture.dart';


class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key, // 1. تم ربط المفتاح هنا ليتمكن الـ Validator من العمل
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvgPicture(path: "assets/images/logo.svg", withColorFilter: false,),
                      const SizedBox(width: 16),
                       Text(
                        "Tasky",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 118),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Welcome To Tasky ",
                        style: Theme.of(context).textTheme.displayMedium
                      ),
                      CustomSvgPicture.withoutColor(path: "assets/images/waving_hand.svg"),
                    ],
                  ),
                  const SizedBox(height: 8),
                   Text(
                    "Your productivity journey starts here.",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 16
                    )
                  ),
                  const SizedBox(height: 24),
                  CustomSvgPicture.withoutColor(path: "assets/images/pana.svg",
                  width: 215,
                  height: 200,),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          const SizedBox(height: 8),
                          // 2. تم التغيير إلى TextFormField لدعم الـ Validator
                          CustomTextFormField(controller: controller,
                            hintText: "Abdulrahman Hisham",
                            title: "Full Name",
                            validator: (String? value) {
                              if (value == null || value
                                  .trim()
                                  .isEmpty) {
                                return "Please Enter Your Full name";
                              }
                              return null;
                            },),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                48, // زيادة الارتفاع قليلاً ليعطي شكلاً أجمل مع رسالة الخطأ
                              ),
                            ),
                            onPressed: () async {
                              // 3. التحقق من حالة الـ Form بالكامل بشكل صحيح قبل الانتقال
                              if (_key.currentState!.validate()) {
                                // final pref = await SharedPreferences
                                //     .getInstance();
                                await PreferencesManager().setString("username", controller.value.text);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return MainScreen();
                                    },
                                  ),
                                );
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(
                                        "Please Enter Your Full name")));
                              }
                            },
                            child: const Text(
                              "Let’s Get Started",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}