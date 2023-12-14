import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Call_helper_Controller extends ChangeNotifier{
  String helperPhoneNumber = '';
  String helperName = '';

  bool isCall=true;

  TextEditingController name_controller = TextEditingController();
  TextEditingController phone_numberController = TextEditingController();

  Call_helper_Controller() {
    _initialzeContent();
  }

  Future<void> _initialzeContent() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
   helperPhoneNumber= _pref.getString('number')??'null';
   helperName=_pref.getString('name')??'null';

  }

  //save the name and number in local storage using sharedpres
  void saveInHive(String name, String phone_number) async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    print(name);
    print(phone_number);
    _pref.setString('number', phone_number);
    _pref.setString('name', name);
  }
  Future<void> deleteFromSharedPref()
  async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
  }

  Future<void > callNumber(String mobile) async {
    await Call_Helper.callNumber(mobile);
  }
}

class Call_Helper {

  static const MethodChannel _channel =
      MethodChannel('flutter_phone_direct_caller');

  static Future<bool?> callNumber(String number) async {

    return await _channel.invokeMethod(
      'callNumber',
      <String, Object>{
        'number': number,
      },
    );

  }
}
