import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models.dart';
const BASE_URL  = 'http://10.0.2.2:8000/api/';

class AppService {

  Future<List<Category>> getCategoryList() async {
    final response =  await http.get(BASE_URL + 'categories/');
    var  resp = json.decode(response.body) as List;
    List<Category> categories = resp.map((val) => Category.fromJson(val)).toList();
    return categories;
  }

  Future<List<CategoryItem>> getCategoryItemList(int categoryId) async {
    final response =  await http.get(BASE_URL + 'categories/$categoryId/images');
    var  resp = json.decode(response.body) as List;
    List<CategoryItem> images = resp.map((val) => CategoryItem.fromJson(val)).toList();
    return images;
  }

  Future<List<Mode>> getModeList() async {
    final response =  await http.get(BASE_URL + 'modes/');
    var  resp = json.decode(response.body) as List;
    List<Mode> modes = resp.map((val) => Mode.fromJson(val)).toList();
    return modes;
  }

}