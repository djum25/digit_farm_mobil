
import 'package:digital_farm_app/utils/service.dart';
import 'package:flutter/cupertino.dart';

class ReverseWidget {
  

  

  Future<void> postData() async{
    var data = {

    };
    var res = await CallApi().postData(data, "");
  }
}