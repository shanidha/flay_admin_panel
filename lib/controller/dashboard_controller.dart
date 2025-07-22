import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentSectionIndex = 0.obs;
  final RxBool sidebarOpen = true.obs;
  final RxList<SectionModel> sections = [
    SectionModel(title: "Dashboard", icon: Icons.dashboard),
    SectionModel(title: "Products", icon: Icons.list_alt),
    SectionModel(title: "Categories", icon: Icons.category),
    SectionModel(title: "Orders", icon: Icons.shopping_bag),
    SectionModel(title: "Purchases", icon: Icons.inventory),
    SectionModel(title: "Invoices", icon: Icons.attach_money),
     SectionModel(title: "Customers", icon: Icons.verified_user),
      SectionModel(title: "Support", icon: Icons.support),
       SectionModel(title: "Logout", icon: Icons.logout),
  ].obs;

  //Creating dummy data
  Future<List<Map<String, dynamic>>> fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(
        5,
        (index) => {
              "productName": "Product $index",
              "sales": "\$${(index + 1) * 1000}",
              "stock": "Category $index",
              "dateAdded": "2024-10-1${index + 1}",
              "totalRevenue": "\$${(index + 1) * 5000}",
              "averageOrderValue": "\$${(index + 1) * 50}",
              "customerCount": index + 1 * 100,
            });
  }

  void changeSection(int index) {
    currentSectionIndex.value = index;
  }
    void toggleSidebar() {
    sidebarOpen.value = !sidebarOpen.value;
  }
}

class SectionModel {
  final IconData icon;
  final String title;
  SectionModel({required this.title, required this.icon});
}
