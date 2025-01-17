import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groccery_app/config.dart';
import 'package:groccery_app/models/category.dart';
import 'package:groccery_app/models/login_response_model.dart';
import 'package:groccery_app/models/product.dart';
import 'package:groccery_app/models/product_filter.dart';
import 'package:groccery_app/utils/shared_service.dart';
import 'package:http/http.dart' as http;

final apiService = Provider((ref) => ApiService());

class ApiService {
  static var client = http.Client();

  Future<List<Category>?> getCategories(page, pageSize) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    Map<String, String> queryString = {
      'page': page.toString(),
      'pageSize': pageSize.toString()
    };
    var url = Uri.http(Config.apiURL, Config.categoryAPI, queryString);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return categoriesFromJson(data["data"]);
    } else {
      return null;
    }
  }

  Future<List<Product>?> getProducts(
      ProductFilterModel productFilterModel) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    Map<String, String> queryString = {
      'page': productFilterModel.paginationModel.page.toString(),
      'pageSize': productFilterModel.paginationModel.pageSize.toString(),
    };
    if (productFilterModel.sort_by != null) {
      queryString["sort_by"] = productFilterModel.sort_by!;
    }
    if (productFilterModel.category_id != null) {
      queryString["category_id"] = productFilterModel.category_id!;
    }
    var url = Uri.http(Config.apiURL, Config.productAPI, queryString);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return productsFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<bool> registerUser(
      String full_name, String email, String password) async {
    Map<String, String> requestHeader = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.registorAPI);

    var respons = await client.post(
      url,
      headers: requestHeader,
      body: jsonEncode(
        {"full_name": full_name, "email": email, "password": password},
      ),
    );
    if (respons.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiURL, Config.loginAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"email": email, "password": password},
      ),
    );
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
          loginResponseModelJson(response.body));
      return true;
    } else {
      return false;
    }
  }
}
