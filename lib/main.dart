import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // updated length to 4 tabs
      home: DefaultTabController(
        length: 4,
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    // updated length to 4
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  // Helper method for the Alert Dialog in Tab 1
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tab 1 Alert'),
          content: const Text('This is the alert dialog for Tab 1.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Defined 4 tabs
    final tabs = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // tab 1: Text Widget & alert dialog 
          Container(
            color: Colors.red[50], // unique page color 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Tab 1',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showMyDialog,
                  child: const Text('Show Alert Dialog'),
                ),
              ],
            ),
          ),

          // tab 2: Image Widget & text inputs 
          Container(
            color: Colors.blue[50], // unique page color 
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Enter some text here'),
                ),
                const SizedBox(height: 20),
                Image.network(
                  'https://cas.gsu.edu/files/2019/07/CAS-HOME-page-banner.jpg', // placeholder image URL 
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),

          // tab 3: Button Widget & SnackBar
          Container(
            color: Colors.green[50], // unique page color
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Button pressed in ${tabs[2]}!')),
                  );
                },
                child: const Text('Click me'),
              ),
            ),
          ),

          // tab 4: ListView Widget & cards
          Container(
            color: Colors.orange[50], // unique page color
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Card( // card widget implementation
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Item 1'),
                    subtitle: const Text('Details for item 1'),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Item 2'),
                    subtitle: const Text('Details for item 2'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // added Bottom App Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
    );
  }
}