import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.maxLines,
    required this.hintText,
    this.validator,
    required this.title
  });

  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final String? Function(String?)? validator;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFCFC),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            errorStyle: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
