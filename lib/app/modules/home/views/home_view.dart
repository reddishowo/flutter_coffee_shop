import 'package:coffee_shop/app/modules/account/views/account_view.dart';
import 'package:coffee_shop/app/modules/apiexperiment/views/apiexperiment_view.dart';
import 'package:coffee_shop/app/modules/cart/views/cart_view.dart';
import 'package:coffee_shop/app/modules/home_tab/views/home_tab_view.dart';
import 'package:coffee_shop/app/modules/menu/views/menu_view.dart';
import 'package:coffee_shop/app/modules/search/views/search_view.dart';
import 'package:coffee_shop/app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
// import 'package:coffeshop/screens/api_experiment_screen.dart';
// import 'package:coffeshop/screens/cart_screen.dart';
// import 'package:coffeshop/screens/home_tab.dart';
// import 'package:coffeshop/screens/search_screen.dart';
// import 'package:coffeshop/screens/account_screen.dart';
// import 'package:coffeshop/widgets/bottom_nav.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.index,
            children: const [
              HomeTabView(),
              MenuView(),
              SearchView(),
              AccountView(),
              ApiexperimentView(),
              CartView(),
            ],
          ),
          bottomNavigationBar: BottomNav(
            currentIndex: controller.index,
            onTap: (i) => controller.changeIndex(i),
          ),
        );
      },
    );
  }
}
