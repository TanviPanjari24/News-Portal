import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = 'e1876b4a4cdc427c9e4a838a80256fac';
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> fetchNews({String category = '', String country = 'in', int page = 1}) async {
    String url = '$baseUrl/top-headlines?country=$country&category=$category&apiKey=$apiKey&page=$page';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['articles'];
    } else {
      print('Failed to load news: Status code ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load news with status code: ${response.statusCode}');
    }
  }
}


