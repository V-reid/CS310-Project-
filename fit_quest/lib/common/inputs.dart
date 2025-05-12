import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Inputs {
  static Widget formButton({
    Color? backgroundColor,
    FormState? state,
    required void Function() onPressed,
    String text = "",
    Color? textColor,
    bool isPrimary = true,
  }) {
    ElevatedButton primary = ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            backgroundColor != null
                ? WidgetStateProperty.all(backgroundColor)
                : null,
      ),
      onPressed:
          state != null && state.validate()
              ? () {
                state.save();
                onPressed();
              }
              : null,
      child: Text(text, style: TextStyle(color: textColor)),
    );
    OutlinedButton secondary = OutlinedButton(
      style: ButtonStyle(
        backgroundColor:
            backgroundColor != null
                ? WidgetStateProperty.all(backgroundColor)
                : null,
      ),
      onPressed:
          !isPrimary || state != null && state.validate()
              ? () {
                if (state != null) state.save();
                onPressed();
              }
              : null,
      child: Text(text, style: TextStyle(color: textColor)),
    );

    return isPrimary ? primary : secondary;
  }

  static InputDecoration inputDecoration(String text, IconData? icon) {
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      label: SizedBox(
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

class Validators {
  static var email = (value) {
    if (value != '') {
      if (value.isEmpty) {
        return "This field is required";
      }
      if (!EmailValidator.validate(value)) {
        return "Invalid email";
      }
    }
  };

  static var password = (value) {
    if (value != '') {
      if (value.isEmpty) {
        return "This field is required";
      }
      if (value.length < 6) {
        return "Password too short";
      }
    }
  };

  static var text = (value) {
    if (value != '') {
      if (value.isEmpty) {
        return 'This field is required';
      }
    }
  };

  static var positiveInt = (value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Invalid number format';
    }

    if (number <= 0) {
      return 'Must be greater than zero';
    }

    return null;
  };
  
  static var positiveDouble = (value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid number format';
    }

    if (number <= 0) {
      return 'Must be greater than zero';
    }

    return null;
  };
}
