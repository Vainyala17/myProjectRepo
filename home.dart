import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final List<String> imageUrls = [
    'https://egov.eletsonline.com/wp-content/uploads/2016/04/MahaLogo-1.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVD5h2x2fZ1DozJ5aJwToB1CH9X0UwOhAfeGHm9usD-HgZLuL1SlmDYkHrVJB7JOd2oA&usqp=CAU',
    'https://www.eprashasan.com/myimg/logo.png',
    'https://www.uvic.ca/retirees/assets/docs/scholarship.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkgmj-AmZNelpJa1uLc2phMjL6eOuM7n_sr8CT_bMlYT3xHkKW0U6N2OgiVflLSOs5DME&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2h3_C2bDX119k2M_oxMqCXHEEpkviNT2HDQ&s',
  ];

  List<String> favoriteLinks = []; // List to store favorite links
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String link) {
    setState(() {
      if (favoriteLinks.contains(link)) {
        favoriteLinks.remove(link);
      } else {
        favoriteLinks.add(link);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On-Links'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navigate to FavoritesPage and pass favorite links
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(favoriteLinks: favoriteLinks),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print('Notifications pressed');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = imageUrls[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(
                              favoriteLinks.contains(imageUrl) ? Icons.favorite : Icons.favorite_border,
                              color: favoriteLinks.contains(imageUrl) ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleFavorite(imageUrl);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: imageUrls.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blueAccent,
                  dotColor: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  items: ['Health', 'Banking', 'Education']
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    print('Selected category: $value');
                  },
                  hint: Text('Choose'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recently Accessed Forms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFormChip('Form 1'),
                  _buildFormChip('Form 2'),
                  _buildFormChip('Form 3'),
                  _buildFormChip('Form 4'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Welcome to On-Links!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Your one-stop solution for all online forms',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormChip(String formName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Chip(
        label: Text(formName),
        backgroundColor: Colors.blue.shade50,
        labelStyle: TextStyle(color: Colors.blue.shade800),
        deleteIcon: Icon(Icons.cancel, color: Colors.blue.shade800),
        onDeleted: () {
          print('$formName removed');
        },
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<String> favoriteLinks;

  FavoritesPage({required this.favoriteLinks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Links'),
      ),
      body: ListView.builder(
        itemCount: favoriteLinks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteLinks[index]),
            onTap: () {
              print('Clicked on ${favoriteLinks[index]}');
            },
          );
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
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
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('You searched for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Suggestions for: $query'),
    );
  }
}
