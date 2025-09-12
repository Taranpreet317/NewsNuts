import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class ApiService {
  static final String _apiKey =
      dotenv.env['API_KEY'] ?? ""; // Replace with your actual key
  static const String _baseUrl = 'https://newsdata.io/api/1/news';

  Future<List<NewsArticle>> fetchNews({String? query, String? category}) async {
    final uri = Uri.parse(
      '${_baseUrl}?apikey=${_apiKey}&country=in&language=en${query != null ? '&q=$query' : ''}${category != null && category.toLowerCase() != 'general' ? '&category=${category.toLowerCase()}' : ''}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List articles = jsonData['results'];

      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
