import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_ease/utils/fonts.dart';
import 'package:table_ease/utils/navigator.dart';
import 'package:table_ease/views/home/home_view.dart';
import 'package:table_ease/views/space/tabs/add_item_tab.dart';
import 'package:table_ease/views/space/tabs/items_tab.dart';
import 'package:table_ease/views/space/tabs/members_tab.dart';

import 'calculation/calculation_view.dart';

class SpaceView extends StatefulWidget {
  const SpaceView({Key? key, required this.spaceId}) : super(key: key);
  final int spaceId;

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  int totalPrice = 0;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> views = [
      AddItemTab(spaceId: widget.spaceId),
      ItemsTab(spaceId: widget.spaceId),
      CalculationView(spaceId: widget.spaceId),
      MembersTab(spaceId: widget.spaceId),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.spaceId.toString()),
          actions: [
            IconButton(
              onPressed: () {
                Navigation.navigatePush(context, HomeView());
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: SafeArea(child: views[currentIndex]),
        bottomNavigationBar: SizedBox(
          height: 64,
          child: BottomNavigationBar(
            selectedLabelStyle: AppFonts.text.titleMedium,
            showUnselectedLabels: false,
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Novo pedido',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Lista de itens',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: 'Calcular'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Membros',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
