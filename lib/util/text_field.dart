import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

//Simple TextField

class AddTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enabled;
  AddTextField({
    super.key,
    this.keyboardType,
    required this.label,
    this.controller,
    required this.obscureText,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(),
        child: TextFormField(
          enabled: enabled,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            } else if (value.length < 3) {
              return 'Please enter at least 3 characters';
            }
            return null;
          },
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        ),
      ),
    );
  }
}

//DropDown TextField

class DropTextField extends StatelessWidget {
  final List<DropDownValueModel> dropDownList;
  final int count;
  final TextInputType? keyboardType;
  final String label;
  final SingleValueDropDownController? controller;
  const DropTextField({
    super.key,
    required this.count,
    required this.dropDownList,
    this.keyboardType,
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(),
        child: DropDownTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          dropDownItemCount: count,
          dropDownList: dropDownList,
          dropdownRadius: 0,
          controller: controller,
          keyboardType: keyboardType,
          textFieldDecoration: InputDecoration(
            labelText: label,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        ),
      ),
    );
  }
}
