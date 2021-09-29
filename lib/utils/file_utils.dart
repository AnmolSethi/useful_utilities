import 'dart:io';

class FileUtils {
  /// Get the file name of a file.
  static String getFileName(File file) => file.path.split('/').last;

  /// Get the file extension of a file.
  static String getFileExtension(File file) => file.path.split('.').last;
}
