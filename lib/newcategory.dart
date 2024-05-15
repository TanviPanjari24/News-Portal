import 'package:flutter/material.dart';
import 'package:news_portal/newsservice.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCategoryDetailsScreen extends StatefulWidget {
  final String category;
  

  const NewsCategoryDetailsScreen({super.key, required this.category});

  @override
  // ignore: library_private_types_in_public_api
  _NewsCategoryDetailsScreenState createState() => _NewsCategoryDetailsScreenState();
}

class _NewsCategoryDetailsScreenState extends State<NewsCategoryDetailsScreen> {
  List<dynamic> articles = [];
  bool isLoading = true;
final Uri url = Uri.parse('https://flutter.dev');
  @override
  void initState() {
    super.initState();
    NewsService().fetchNews(category:  widget.category).then((data) {
      setState(() {
        articles = data;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching news: $error'))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                var imageUrl = article['urlToImage'] ?? 'https://via.placeholder.com/150';
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover, height: 200,errorBuilder:((context, error, stackTrace) => SizedBox.shrink()),), 
                       Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(article['title'] ?? '', style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(article['description'] ?? 'No description available', style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () => _launchURL(article['url']),
                            child: const Text('Read More'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _launchURL(String? url) async {
     if (!await launchUrl(Uri.parse(url??''))) {
    throw Exception('Could not launch $url');
  }
}
}
