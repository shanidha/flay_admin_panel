import 'package:flay_admin_panel/controller/dashboard_controller.dart';
import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flay_admin_panel/core/resources/app_images.dart';
import 'package:flay_admin_panel/view/add_product_screen.dart';
import 'package:flay_admin_panel/view/category_screen.dart';
import 'package:flay_admin_panel/view/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'add_category_screen.dart';
import 'product_screen.dart';

class Dashboard extends StatelessWidget {
  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Obx(
          () => AnimatedContainer(
            width: controller.sidebarOpen.value ? 200 : 100,
            color: Colors.black,
            duration: Duration(milliseconds: 300),
            child: _buildSideBar(),
          ),
        ),

        // ───── Main Content ─────────────────
        Expanded(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Obx(() {
                  switch (controller.currentSectionIndex.value) {
                    case 0:
                      return const DashboardContentScreen();
                    case 1:
                      return const ProductsContentScreen();
                    case 2:
                      return const CategoryContentScreen();
                    case 3:
                      return const AddCategoryScreen();
                    case 4:
                      return const AddProductContentScreen();
                    default:
                      return Center(
                          child: Text(controller
                              .sections[controller.currentSectionIndex.value]
                              .title));
                  }
                }),
              ),
            ],
          ),
        ),
      ]),
    );
  }
//Build Heade for Notification and search bar
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.toggleSidebar(),
            child: Icon(
              Icons.menu,color: AppColors.secondBackground,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          const Text("Welcome!",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(width: 16),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildNotificationBadge(3),
              _buildAdminUser(),
              _buildSearchBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black54),
          onPressed: () {},
        ),

        // badge
        if (count > 0)
          Positioned(
            right: 3,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.kRedColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAdminUser() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 100,
          height: 48.0,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: AppColors.boxBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
               AppVectors.user,
                width: 40,
                height: 40,
              ),
              SizedBox(width: 8),
              Text('Admin', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ));
  }

  Widget _buildSearchBar() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 300,
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.boxBackgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Search', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildSideBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.sidebarOpen.value) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: SvgPicture.asset(
                AppVectors.flayWhite,
                width: 150,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
        Obx(
          () => Column(
              children: List.generate(
            controller.sections.length,
            (index) => _buildSideBarItem(controller.sections[index].icon,
                controller.sections[index].title, index),
          )),
        )
      ],
    );
  }

  Widget _buildSideBarItem(IconData icon, String title, int index) {
    return Obx(() {
      final isSelected = controller.currentSectionIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeSection(index),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  isSelected
                      ? Container(
                          width: 5,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    icon,
                    color: isSelected ? AppColors.primary : AppColors.kGreyDark,
                  ),
                  if (controller.sidebarOpen.value)
                    SizedBox(
                      width: 15,
                    ),
                  if (controller.sidebarOpen.value)
                    Text(
                      title,
                      style: TextStyle(
                        color:
                            isSelected ? AppColors.primary : AppColors.kGreyDark,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    )
                ],
              ))
            ],
          ),
        ),
      );
    });
  }
}
