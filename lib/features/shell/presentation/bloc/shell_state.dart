

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/section_model.dart';
enum ShellSection {
  dashboard,
  products,
  categories,
  brands,
  addCategory,
  addProduct,
  addBrands,
  orders,
  purchases,
  invoices,
  customers,
  support,
  logout,
}

class ShellState extends Equatable {
  final ShellSection section;
  final bool sidebarOpen;

  /// Sidebar items (what you render on the left)
  final List<SectionModel> sections;

  const ShellState({
    required this.section,
    required this.sidebarOpen,
    required this.sections,
  });

  factory ShellState.initial() => ShellState(
        section: ShellSection.dashboard,
        sidebarOpen: true,
        sections: const [
          SectionModel(title: 'Dashboard',  icon: Icons.dashboard_customize_outlined),
          SectionModel(title: 'Products',   icon: Icons.list_alt_outlined),
          SectionModel(title: 'Categories', icon: Icons.category_outlined),
           SectionModel(title: 'Brands', icon: Icons.branding_watermark),
          SectionModel(title: 'Orders',     icon: Icons.shopping_bag_outlined),
          SectionModel(title: 'Purchases',  icon: Icons.inventory_2_outlined),
          SectionModel(title: 'Invoices',   icon: Icons.receipt_long_outlined),
          SectionModel(title: 'Customers',  icon: Icons.group_outlined),
          SectionModel(title: 'Support',    icon: Icons.support_agent_outlined),
          SectionModel(title: 'Logout',     icon: Icons.logout),
        ],
      );

  ShellState copyWith({
    ShellSection? section,
    bool? sidebarOpen,
    List<SectionModel>? sections,
  }) {
    return ShellState(
      section: section ?? this.section,
      sidebarOpen: sidebarOpen ?? this.sidebarOpen,
      sections: sections ?? this.sections,
    );
  }

  /// Convenience: convert current [section] to its index in [sections] for UI
  int get currentIndex {
    switch (section) {
      case ShellSection.dashboard:  return 0;
      case ShellSection.products:   return 1;
      case ShellSection.categories: return 2;
       case ShellSection.brands:     return 3;
      case ShellSection.orders:     return 4;
      case ShellSection.purchases:  return 5;
      case ShellSection.invoices:   return 6;
      case ShellSection.customers:  return 7;
      case ShellSection.support:    return 8;
      case ShellSection.logout:     return 9;
      // Add forms aren’t in the sidebar; return -1 so you can style accordingly
      case ShellSection.addCategory:return 2;
      case ShellSection.addProduct:return 1;
        case ShellSection.addBrands:return 3;
        
    }
  }

  @override
  List<Object?> get props => [section, sidebarOpen, sections];
}
// class ShellState extends Equatable {
//   final int currentIndex;
//   final bool sidebarOpen;
//   final List<SectionModel> sections;

//   const ShellState({
//     required this.currentIndex,
//     required this.sidebarOpen,
//     required this.sections,
//   });

//   ShellState copyWith({
//     int? currentIndex,
//     bool? sidebarOpen,
//     List<SectionModel>? sections,
//   }) {
//     return ShellState(
//       currentIndex: currentIndex ?? this.currentIndex,
//       sidebarOpen: sidebarOpen ?? this.sidebarOpen,
//       sections: sections ?? this.sections,
//     );
//   }

//   @override
//   List<Object> get props => [currentIndex, sidebarOpen, sections];
// }
