import 'package:flutter/material.dart';

class FormUtils {
  /// Validate and Save Form.
  /// [formKey] is the key of the form.
  ///
  /// Returns true if the form is valid, false otherwise.
  static bool validateAndSaveForm(final GlobalKey<FormState> formKey) {
    if (formKey.currentState == null) {
      throw ArgumentError('The currentState of the [formKey] is null.');
    }
    if (!formKey.currentState!.validate()) return false;

    formKey.currentState!.save();
    return true;
  }
}
