import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> saveParentId(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('parent_id', parentId);
    print("Parent ID guardado: $parentId");
  }

  static Future<String?> getParentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parentId = prefs.getString('parent_id');
    print("Parent ID recuperado: $parentId");
    return parentId;
  }
}
