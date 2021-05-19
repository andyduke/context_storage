import 'package:context_storage/context_storage.dart';
import 'package:context_storage/extension.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextStorage Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: TabbedScreen(),
    );
  }
}

class TabbedScreen extends StatefulWidget {
  @override
  _TabbedScreenState createState() => _TabbedScreenState();
}

class _TabbedScreenState extends State<TabbedScreen> {
  int _tabIndex = 0;

  final List<WidgetBuilder> _tabBuilders = [
    (context) => HomeTab(),
    (context) => ProfileTab(),
    (context) => SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ContextStorage(
      child: Scaffold(
        body: _tabBuilders[_tabIndex].call(context),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() {
            _tabIndex = value;
          }),
          currentIndex: _tabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// --- Tabs

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContextStorage(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.access_alarm)),
                Tab(icon: Icon(Icons.accessibility_new)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Counter()),
              Center(child: Counter()),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Counter(),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Counter(),
      ),
    );
  }
}

// --- Counter

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _value = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get value from storage
    // _value = ContextStorage.of(context)?.get<int>('counter') ?? 0;
    _value = context.storage?.get<int>('counter') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$_value', style: TextStyle(fontSize: 22)),

        //
        const SizedBox(height: 16),

        //
        MaterialButton(
          child: Icon(Icons.add),
          padding: const EdgeInsets.all(16),
          shape: CircleBorder(),
          textColor: Theme.of(context).colorScheme.onPrimary,
          color: Theme.of(context).colorScheme.primary,
          elevation: 2,
          onPressed: () {
            setState(() {
              _value++;
            });

            // Update value in storage
            // ContextStorage.of(context)?.set('counter', _value);
            context.storage?.set('counter', _value);
          },
        ),
      ],
    );
  }
}
