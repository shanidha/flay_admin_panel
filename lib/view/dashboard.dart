import 'package:flay_admin_panel/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F7F7),
      body: Row(children: [
        Obx(
          () => AnimatedContainer(
            width: controller.sidebarOpen.value ? 200 : 100,
            color: Colors.black,
            duration: Duration(milliseconds: 300),
            child: _buildSideBar(),
          ),
        ),
        Expanded(
            child: Container(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
            ],
          ),
        ))
      ]),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.toggleSidebar(),
            child: Icon(
              Icons.menu,
              size: 20,
            ),
          
          ),
          SizedBox(width: 10,),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(padding: EdgeInsetsGeometry.all(20));
  }

  Widget _buildSideBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.sidebarOpen.value) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Flay\nSlay it in Your Way",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                            color: Color(0xFFFF6C30),
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
                    color: isSelected ? Color(0XFFFF6C30) : Color(0XFF6D6562),
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
                            isSelected ? Color(0XFFFF6C30) : Color(0XFF6D6562),
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
