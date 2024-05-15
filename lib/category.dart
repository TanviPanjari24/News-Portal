import 'package:flutter/material.dart';
import 'package:news_portal/newcategory.dart';
class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final List<String> categories = [
    'Business', 'Entertainment', 'General', 
    'Health', 'Science', 'Sports', 'Technology'
  ];

  final Map<String, IconData> categoryIcons = {
    'Business': Icons.business_center,
    'Entertainment': Icons.movie,
    'General': Icons.public,
    'Health': Icons.health_and_safety,
    'Science': Icons.science,
    'Sports': Icons.sports_soccer,
    'Technology': Icons.memory
  };

  final Map<String, Color> categoryColors = {
    'Business': Colors.blue,
    'Entertainment': Colors.red,
    'General': Colors.green,
    'Health': Colors.purple,
    'Science': Colors.orange,
    'Sports': Colors.yellow,
    'Technology': Colors.grey,
  };

  void _startSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: CategorySearchDelegate(categories),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sections'),centerTitle: true,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () => _startSearch(context),
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search categories',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                String category = categories[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      categoryIcons[category], 
                      color: categoryColors[category],
                    ),
                    title: Text(
                      category,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsCategoryDetailsScreen(category: category),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySearchDelegate extends SearchDelegate<String> {
  final List<String> categories;

  CategorySearchDelegate(this.categories);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

 @override
Widget buildResults(BuildContext context) {
  final List<String> matches = categories.where((c) => c.toLowerCase().contains(query.toLowerCase())).toList();

  return ListView.builder(
    itemCount: matches.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(matches[index]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsCategoryDetailsScreen(category: matches[index]),
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> matches = query.isEmpty ? [] : categories.where((c) => c.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(matches[index]),
          onTap: () {
            showResults(context);
          },
        );
      },
    );
  }
}
