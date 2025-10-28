
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/news_article.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsArticle>> futureNews;
  String? searchQuery;
  final List<String> categories = [
    'General',
    'Technology',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Politics',
  ];
  String selectedCategory = 'General';

  @override
  void initState() {
    super.initState();
    futureNews = ApiService().fetchNews();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) return;
     
      searchQuery = query;
      futureNews = ApiService().fetchNews(query: searchQuery);
    });
  }

  Future<void> _refreshNews() async {
    setState(() {
      futureNews = ApiService().fetchNews(
        category: selectedCategory,
      ); // Re-fetch with selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              "NewsNuts",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
               
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 40,
             
              child: TextField(
                onSubmitted: _onSearch,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                 
                ),
                decoration: InputDecoration(
                  hintText: "Search news...",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 20, 20, 20),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        toolbarHeight: 85,
      ),

      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color:
                            selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.grey[200],
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                        futureNews = ApiService().fetchNews(
                          category: category,
                        ); // Refresh news by category
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshNews,
              child: FutureBuilder<List<NewsArticle>>(
                future: futureNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 5, // number of shimmer cards
                      itemBuilder: (context, index) => shimmerCardDesign(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No news found'));
                  }

                  final articles = snapshot.data!;
                  return PageView(
                    scrollDirection: Axis.vertical,
                    children:
                        articles.map((article) {
                          return cardDesign(context, article);
                        }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}



Widget shimmerCardDesign() {
  return Stack(
    children: [
      Container(height: 500, color: Colors.black.withValues(alpha: 0.3)),
      Padding(
        padding: const EdgeInsets.only(top: 350),
        child: SizedBox(
          height: 350,
          width: double.infinity,
          child: Card(
            color: Colors.black,
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 25,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Container(height: 20, width: 250, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget cardDesign(context, NewsArticle article) {
  return Stack(
    children: [
      if (article.imageUrl.isNotEmpty)
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            article.imageUrl,
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  height: 500,
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.broken_image)),
                ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top: 370),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          height: 250,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 350),
        child: SizedBox(
          height: 350,
          width: double.infinity,
          child: InkWell(
            onTap: () async {
              final url = Uri.parse(article.link);
           

              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not launch article")),
                );
              }
            },
            child: Card(
              color: Colors.black,
              elevation: 20,
              child: Column(
             
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color.fromARGB(179, 208, 205, 205),
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
