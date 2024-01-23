import 'package:flutter/material.dart';
import 'package:l3homeation/models/drawer_item.dart';
import 'package:l3homeation/pages/dashboard.dart';
import 'package:l3homeation/pages/power_graph.dart';
import 'package:l3homeation/pages/userProfile.dart';
import 'package:provider/provider.dart';
import 'package:l3homeation/provider/navigation_provider.dart';
import 'package:l3homeation/data/drawer_items.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: Color(0xFFFAFAFA),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              const SizedBox(height: 24),
              buildList(
                  items: itemsFirst,
                  isCollapsed: isCollapsed,
                  context: context),
              const SizedBox(height: 24),
              Divider(color: Colors.white70),
              const SizedBox(height: 24),
              buildList(
                items: itemsSecond,
                isCollapsed: isCollapsed,
                context: context,
                indexOffset: itemsFirst.length,
              ),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    required BuildContext context,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return buildMenuItem(
            isCollapsed: isCollapsed,
            item: item,
            context: context,
            itemIndex: index + indexOffset,
            onClicked: () => selectItem(context, index + indexOffset),
          );
        },
      );

  // void selectItem(BuildContext context, int index) {
  //   final provider = Provider.of<NavigationProvider>(context, listen: false);
  //   provider.currentIndex = index; // Update the current index

  //   final navigateTo =
  //       (Widget page) => Navigator.of(context).push(MaterialPageRoute(
  //             builder: (context) => page,
  //           ));

  //   Navigator.of(context).pop(); // Close the drawer

  //   switch (index) {
  //     case 0:
  //       navigateTo(dashboard());
  //       break;
  //     case 1:
  //       navigateTo(PowerGraph());
  //       break;
  //     case 3:
  //       navigateTo(UserProfile());
  //       break;
  //   }
  // }

  // Kept the old one above just incase it messes with other routing stuff
  // I can't fix the dashboard navigate to dashboard portion though, but the rest are popping off to the dashboard after going back
  void selectItem(BuildContext context, int index) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    if (provider.currentIndex == 0 && index == 0) {
      Navigator.of(context).pop();
      return;
    }
    provider.currentIndex = index; // Update the current index

    final navigateTo = (Widget page) {
      // Check if the page is already in the stack
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      // Navigate to the page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    };

    Navigator.of(context).pop(); // Close the drawer

    switch (index) {
      case 0:
        navigateTo(dashboard());
        break;
      case 1:
        navigateTo(PowerGraph());
        break;
      case 3:
        navigateTo(UserProfile());
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required DrawerItem item,
    required BuildContext context,
    required int itemIndex,
    VoidCallback? onClicked,
  }) {
    final provider = Provider.of<NavigationProvider>(context);
    final isSelected = provider.currentIndex == itemIndex;

    Color getIconColor() {
      if (!isSelected) return Colors.black;
      switch (item.title) {
        case 'Dashboard':
          return Colors.yellow.shade700;
        case 'Power':
          return Colors.green.shade800;
        case 'Scenes':
          return Colors.blue.shade800;
        case 'Profile':
          return Colors.orange.shade800;
        case 'Searching...':
          return Colors.red.shade800;
        default:
          return Colors.black;
      }
    }

    final iconColor = getIconColor();

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: Icon(item.icon, color: iconColor),
              onTap: onClicked,
            )
          : ListTile(
              leading: Icon(item.icon, color: iconColor),
              title: Text(item.title,
                  style: TextStyle(color: iconColor, fontSize: 16)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;

    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: () {
        final provider =
            Provider.of<NavigationProvider>(context, listen: false);
        provider.toggleIsCollapsed();
      },
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? Image.asset('images/L3-homeation-logo.png', width: 48)
      : Row(
          children: [
            const SizedBox(width: 24),
            Image.asset('images/L3-homeation-logo.png', width: 48),
            const SizedBox(width: 16),
            Text(
              'By: L3Homeation',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        );
}
