import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
class SectionModel extends Equatable {
  final String title;
  final IconData icon;
  const SectionModel({required this.title, required this.icon});

  @override
  List<Object?> get props => [title, icon];
}
// class SectionModel {
//   final IconData icon;
//   final String title;
//   final String iconSelected;
//   final String iconUnselected;
//   const SectionModel({
//     required this.title,
//     required this.icon,
//     required this.iconSelected,
//     required this.iconUnselected,
//   });
// }