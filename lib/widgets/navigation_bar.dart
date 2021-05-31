import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:running_society/theme.dart';

class CustomNavigationBarItem {
  IconData icon;
  bool hasNotification;

  CustomNavigationBarItem({required this.icon, required this.hasNotification});
}

class NavigationBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;
  final List<CustomNavigationBarItem> children;
  final int currentIndex;

  NavigationBar({
    required this.children,
    this.currentIndex = 0,
    required this.onTabSelected,
  });

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  var _selectedIndex = 0;

  void _changeIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabIcon(
      {required int index, required CustomNavigationBarItem item, required ValueChanged<int> onPressed}) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: CupertinoButton(
          onPressed: () => onPressed(index),
          child: Icon(item.icon,
            color: _selectedIndex == index
                ? CustomTheme.lemonTint
                : Colors.black45,
            size: 24
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var items = List<Widget>.generate(widget.children.length, (int index) {
      return _buildTabIcon(index: index, item: widget.children[index], onPressed: _changeIndex);
    });

    return BottomAppBar(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ),
      ),
    );
  }
}
