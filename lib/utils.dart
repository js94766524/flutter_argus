import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class Utils{
  static Future<String> getMid(String id,String project,String package)async{
    final sp = await SharedPreferences.getInstance();
    var mid = sp.getString("argus_mid");
    if(mid == null){
      final origin = "$id$project${Uuid().v5(Uuid.NAMESPACE_URL, package)}";
      mid = md5.convert(origin.codeUnits).toString();
      sp.setString("argus_mid", mid);
    }
    return mid;
  }
}