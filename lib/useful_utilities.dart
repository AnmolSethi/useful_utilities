library useful_utilities;

import 'package:flutter/material.dart';

/// [UsefulUtilities] is a class that contains useful utilities for the app.
class UsefulUtilities {
  /// Validate and Save Form.
  /// [formKey] is the key of the form.
  ///
  /// Returns true if the form is valid, false otherwise.
  static bool validateAndSaveForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState == null) {
      throw ArgumentError('The currentState of the [formKey] is null.');
    }
    if (!formKey.currentState!.validate()) return false;

    formKey.currentState!.save();
    return true;
  }
}
