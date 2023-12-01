// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore
import 'package:shared_preferences/shared_preferences.dart';

void saveDataToSharedPreferences(
    String name, String status, String flatNo, String societyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('societyName', societyName);
  await prefs.setString('memberName', name);
  await prefs.setString('flatNo', flatNo);
  await prefs.setString('status', status);
}

void clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<String> getSocietyNameFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('societyName') ?? '';
}

Future<String> getMemberNameFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('memberName') ?? '';
}

Future<String> getFlatNoFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('flatNo') ?? '';
}

Future<String> getStatusFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('Status') ?? '';
}
