
import 'package:flay_admin_panel/features/brands/presentation/pages/add_brand_page.dart';
import 'package:flay_admin_panel/features/brands/presentation/pages/brand_page.dart';
import 'package:flay_admin_panel/features/categories/presentation/pages/add_category_screen.dart';
import 'package:flay_admin_panel/features/categories/presentation/pages/category_screen.dart';
import 'package:flay_admin_panel/features/shell/presentation/pages/dashboard_screen.dart';
import 'package:flay_admin_panel/features/products/presentation/pages/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_images.dart';
import '../../../products/presentation/pages/add_product_screen.dart';
import '../../data/models/section_model.dart';
import '../../presentation/bloc/shell_bloc.dart';
import '../../presentation/bloc/shell_event.dart';
import '../../presentation/bloc/shell_state.dart';
import 'package:flutter_svg/flutter_svg.dart';




class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShellBloc(),
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Sidebar(),
            Expanded(child: _MainPanel()),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      buildWhen: (p, n) => p.sidebarOpen != n.sidebarOpen || p.currentIndex != n.currentIndex,
      builder: (context, state) {
        final width = state.sidebarOpen ? 200.0 : 100.0;
        return AnimatedContainer(
          width: width,
          color: Colors.black,
          duration: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.sidebarOpen)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(AppVectors.flayWhite, width: 150),
                ),
              Column(
                children: List.generate(
                  state.sections.length,
                  (i) => _SidebarItem(section: state.sections[i], index: i),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final SectionModel section;
  final int index;
  const _SidebarItem({required this.section, required this.index});
ShellSection sectionFromSidebarIndex(int i) {
  switch (i) {
    case 0: return ShellSection.dashboard;
    case 1: return ShellSection.products;
    case 2: return ShellSection.categories;
    case 3: return ShellSection.brands;
     case 4: return ShellSection.orders;
    case 5: return ShellSection.purchases;
    case 6: return ShellSection.invoices;
    case 7: return ShellSection.customers;
    case 8: return ShellSection.support;
    case 9: return ShellSection.logout;
    default: return ShellSection.dashboard;
  }
}
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      buildWhen: (p, n) => p.currentIndex != n.currentIndex || p.sidebarOpen != n.sidebarOpen,
      builder: (context, state) {
        final isSelected = state.currentIndex == index;
        return GestureDetector(
          onTap: () => context.read<ShellBloc>().add(ShellSectionChanged(sectionFromSidebarIndex(index))),
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isSelected)
                        Container(
                          width: 5,
                          color: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
                      const SizedBox(width: 20),
                      Icon(
                        section.icon,
                        color: isSelected ? AppColors.primary : AppColors.kGreyDark,
                      ),
                      if (state.sidebarOpen) const SizedBox(width: 15),
                      if (state.sidebarOpen)
                        Text(
                          section.title,
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.kGreyDark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MainPanel extends StatelessWidget {
  const _MainPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Header(),
        Expanded(child: _BodySwitcher()),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.read<ShellBloc>().add(const ShellSidebarToggled()),
            child: Icon(Icons.menu, color: AppColors.secondBackground, size: 20),
          ),
          const SizedBox(width: 16),
          const Text(
            "Welcome!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const Spacer(),
          Row(
            children: const [_NotificationBadge(count: 3), _AdminUser(), _SearchBar()],
          ),
        ],
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;
  const _NotificationBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black54), onPressed: () {}),
        if (count > 0)
          Positioned(
            right: 3,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: AppColors.kRedColor, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(color: AppColors.background, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class _AdminUser extends StatelessWidget {
  const _AdminUser();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 100,
        height: 48,
        decoration: BoxDecoration(color: AppColors.boxBackgroundColor, borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            SvgPicture.asset(AppVectors.user, width: 40, height: 40),
            const SizedBox(width: 8),
            const Text('Admin', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 300,
        height: 48,
        decoration: BoxDecoration(color: AppColors.boxBackgroundColor, borderRadius: BorderRadius.circular(24)),
        child: const Row(
          children: [SizedBox(width: 16), Icon(Icons.search, color: Colors.grey), SizedBox(width: 8), Text('Search', style: TextStyle(color: Colors.grey))],
        ),
      ),
    );
  }
}

class _BodySwitcher extends StatelessWidget {
  const _BodySwitcher();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      buildWhen: (p, n) => p.section != n.currentIndex,
      builder: (context, state) {
        switch (state.section) {
           case ShellSection.dashboard:  return const DashboardContentScreen();
      case ShellSection.products:   return const ProductsContentScreen();
      case ShellSection.categories: return const CategoryContentScreen();
      case ShellSection.addCategory:return const AddCategoryScreen();
      case ShellSection.addProduct: return const AddProductContentScreen();
         case ShellSection.brands: return const BrandPage();
            case ShellSection.addBrands: return const AddBrandPage();
          // case 0:
          //   return const DashboardContentScreen(); // your old DashboardContentScreen
          // case 1:
          //   return const ProductsContentScreen();       // old ProductsContentScreen
          // case 2:
          //   return const CategoryContentScreen();
          // case 3:
          //   return const AddCategoryPage();
          // case 4:
          //   return const AddCategoryScreen();
          default:
            return Center(child: Text(state.sections[state.currentIndex].title));
        }
      },
    );
  }
}