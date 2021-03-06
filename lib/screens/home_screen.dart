import 'package:chat_app/pages/calls_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/messeges_page.dart';
import 'package:chat_app/pages/notification_page.dart';
import 'package:chat_app/screens/screens.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/app.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier('Messages');

  final pages = const [
    MessegesPage(),
    NotificationPage(),
    CallsPage(),
    ContactsPage(),
  ];

  final pageTitles = const ['Messages', 'Notifications', 'Calls', 'Contacts'];

  void _onNavigationItemSelected(index) {
    title.value = pageTitles[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, String value, _) {
            return Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black87));
          },
        ),
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: Icons.search,
            onTap: () {
              print('search');
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Hero(
              tag: 'hero-profile-picture',
              child: Avatar.small(
                url: context.currentUserImage,
                onTap: () {
                  Navigator.of(context).push(ProfileScreen.route);
                },
              ),
            ),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: _BottomNavigationBar(
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    required this.onItemSelected,
    Key? key,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context)
        .brightness; //remeber to do in title message beside search
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                label: 'Message',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 1,
                label: 'Notifications',
                icon: CupertinoIcons.bell_solid,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 5),
                child: GlowingActionButton(
                    color: AppColors.secondary,
                    icon: CupertinoIcons.add,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => const Dialog(
                                child: AspectRatio(
                                  aspectRatio: 8 / 7,
                                  child: ContactsPage(),
                                ),
                              ));
                    }),
              ),
              _NavigationBarItem(
                index: 2,
                label: 'Calls',
                icon: CupertinoIcons.phone_fill,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 3,
                label: 'Contacts',
                icon: CupertinoIcons.person_2_fill,
                isSelected: (selectedIndex == 3),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.index,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  final ValueChanged<int> onTap;

  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary)
                  : const TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}
