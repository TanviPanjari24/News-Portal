import 'package:flutter/material.dart';
import 'package:news_portal/category.dart';
import 'package:news_portal/newsfeed.dart';
import 'package:news_portal/res/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _widgetOptions = [
    const NewsFeed(),
    CategoryScreen(), 
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
         
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.colorPrimary,
        onTap: _onItemTapped,
      ),
    );
  }
}
