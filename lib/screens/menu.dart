import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/experience_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506554171";
  final String nama = "Paramita Santoso";
  final String kelas = "KKI";

  final List<ItemHomepage> items = [
    ItemHomepage("View Education Record", Icons.folder, Colors.teal.shade500),
    ItemHomepage("View Experiences", Icons.assignment_ind, Colors.deepPurple.shade500),
    ItemHomepage("Logout", Icons.logout, Colors.red.shade500),
    ItemHomepage("Add Education Record", Icons.post_add, Colors.cyanAccent.shade700),
    ItemHomepage("Add Experience", Icons.add_circle, Colors.indigoAccent.shade700),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'MyPortofolio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: const LeftDrawer(),
      
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Horizontal row showing 3 InfoCards.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Expanded(child: x) makes the InfoCard responsive
                      Expanded(child: InfoCard(title: 'NPM', content: npm)),
                      Expanded(child: InfoCard(title: 'Name', content: nama)),
                      Expanded(child: InfoCard(title: 'Class', content: kelas)),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // Greeting and 3-column action grid.
                  Center(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Welcome to MyPortofolio Mobile!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),

                        GridView.count(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          children: items.map((ItemHomepage item) {
                            return ItemCard(item);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class InfoCard extends StatelessWidget {
  // Information card displaying a title and its associated content.
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  /// Copies [content] to the clipboard, then notifies the user.
  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: content));

    // Guard: the widget may have been removed while awaiting the copy.
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$title copied: $content')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _copyToClipboard(context),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}