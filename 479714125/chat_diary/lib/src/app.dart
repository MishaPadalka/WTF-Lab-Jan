import 'package:flutter/material.dart';

import 'components/floating_action_button.dart';
import 'models/page_model.dart';
import 'screens/add_page_screen/add_page_screen.dart';
import 'screens/daily_screen/daily_screen.dart';
import 'screens/explore_screen/explore_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/home_screen/widgets/page_card.dart';
import 'screens/timeline_screen/timeline_screen.dart';
import 'theme/app_theme.dart';
import 'theme/config.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    appTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appTheme.currentTheme,
      title: 'Chat Diary',
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String _title = 'Home';

  final List<PageCard> _listOfChats = <PageCard>[];

  @override
  void initState() {
    _listOfChats.addAll([
      PageCard(
        icon: Icons.travel_explore,
        title: 'Travel',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      ),
      PageCard(
        icon: Icons.bed,
        title: 'Hotel',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      ),
      PageCard(
        icon: Icons.sports_score,
        title: 'Sport',
        key: UniqueKey(),
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () => appTheme.toggleTheme(),
            icon: const Icon(Icons.invert_colors),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
          switch (index) {
            case 0:
              _title = 'Home';
              break;
            case 1:
              _title = 'Daily';
              break;
            case 2:
              _title = 'Timeline';
              break;
            case 3:
              _title = 'Explore';
              break;
          }
        }),
      ),
      floatingActionButton: (_currentIndex == 0)
          ? AppFloatingActionButton(
              onPressed: () => _navigateToAddPageAndFetchResult(context),
              child: const Icon(Icons.add, size: 50),
            )
          : null,
      body: IndexedStack(
        children: [
          HomeScreen(
            listOfChats: _listOfChats,
          ),
          const DailyScreen(),
          const TimelineScreen(),
          const ExploreScreen(),
        ],
        index: _currentIndex,
      ),
    );
  }

  Future<void> _navigateToAddPageAndFetchResult(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPageScreen(
          title: 'Create a new Page',
        ),
      ),
    );
    if (result != null) {
      final pageModel = result as PageModel;
      final pageCard = PageCard(
        key: UniqueKey(),
        icon: pageModel.icon,
        title: pageModel.name,
        deletePage: _deleteSelectedPage,
        editPage: _editSelectedPage,
      );
      setState(() => _listOfChats.add(pageCard));
    }
  }

  Future<void> _navigateToEditPageAndEditPage({
    required BuildContext context,
    required String currentTitleOfPage,
    required Key key,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPageScreen(
          title: 'Edit Page',
          titleOfPage: currentTitleOfPage,
        ),
      ),
    );
    if (result != null) {
      int? index;
      final pageModel = result as PageModel;
      for (final value in _listOfChats) {
        if (value.key == key) {
          index = _listOfChats.indexOf(value);
          break;
        }
      }
      if (index != null) {
        _listOfChats[index] = PageCard(
          key: key,
          icon: pageModel.icon,
          title: pageModel.name,
          deletePage: _deleteSelectedPage,
          editPage: _editSelectedPage,
        );
      }
    }
  }

  Future<void> _deleteSelectedPage(Key key) async {
    await _showDeleteDialog(key);
    setState(() {});
  }

  Future<void> _editSelectedPage(Key key, String titleOfPage) async {
    await _navigateToEditPageAndEditPage(
      context: context,
      currentTitleOfPage: titleOfPage,
      key: key,
    );
    setState(() {});
  }

  Future<void> _showDeleteDialog(Key key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete page?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you really sure you want to delete this page?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _listOfChats.removeWhere((element) => element.key == key);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
