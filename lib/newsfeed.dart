import 'package:flutter/material.dart';
import 'package:news_portal/newsservice.dart';
import 'package:news_portal/res/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:intl/intl.dart';
class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> articles = [];
  bool isLoading = true;
  String formattedDate = '';
  late Timer timer;
  int currentPage = 1; 
  bool isFetching = false; 

  final ScrollController _scrollController = ScrollController(); // ScrollController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      searchNews('in', currentPage); 
    });
    updateDateTime();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    timer.cancel();
    _tabController.dispose();
    _scrollController.dispose(); 
    super.dispose();
  }

  void updateDateTime() {
    setState(() {
      formattedDate = DateFormat('EEE, MMM d').format(DateTime.now());
    });
  }
   void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      
      if (!isFetching) {
        currentPage++; 
        isFetching = true; 
        searchNews('in', currentPage); 
      }
    }
  }
  void _handleTabSelection() {
  if (!_tabController.indexIsChanging) {
    setState(() {
      articles = []; 
      currentPage = 1; 
      isLoading = true;
    });
    String country = 'in'; // Default
    switch (_tabController.index) {
      case 0: country = 'in'; break;
      case 1: country = 'us'; break;
      case 2: country = 'ru'; break;
      case 3: country = 'au'; break;
      case 4: country = 'ca'; break;
      case 5: country = 'fr'; break;
      case 6: country = 'eg'; break;
      case 7: country = 'de'; break;
    }
    searchNews(country, currentPage);
  }
}
void searchNews(String country, int page) {
  if (!isLoading) {
    setState(() {
      isLoading = true; 
    });
  }
  NewsService().fetchNews(country: country, page: page).then((data) {
    setState(() {
      articles.addAll(data); 
      isLoading = false;
      isFetching = false; 
    });
  }).catchError((err) {
    setState(() {
      isLoading = false;
      isFetching = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching news: $err')),
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('News Portal', style: Theme.of(context).appBarTheme.titleTextStyle),
              Text(formattedDate, style: Theme.of(context).appBarTheme.titleTextStyle),
            ],
          ),
        ),
        bottom: TabBar(
          labelColor: AppColors.ivory,
          unselectedLabelColor: AppColors.colorPrimaryGradientBegin,
          controller: _tabController,
          isScrollable: true,
          tabs: const [
             Tab(text: 'India'),
            Tab(text: 'US'),
            Tab(text: 'Russia'),
            Tab(text: 'Australia'),
            Tab(text: 'Canada'),
            Tab(text: 'France'),
            Tab(text:'Egypt'),
            Tab(text: 'Germany',)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController, 
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      var article = articles[index];
                      var imageUrl = article['urlToImage'] ?? 'https://via.placeholder.com/150';
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                            ListTile(
                              title: Text(
                                article['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(article['description'] ?? 'No description available'),
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
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (!await launchUrl(Uri.parse(url ?? ''))) {
      throw Exception('Could not launch $url');
    }
  }
}