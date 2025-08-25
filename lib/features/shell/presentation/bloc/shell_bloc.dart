import 'package:bloc/bloc.dart';


import 'shell_event.dart';
import 'shell_state.dart';

// class ShellBloc extends Bloc<ShellEvent, ShellState> {
//   ShellBloc() : super(ShellInitial()) {
//     on<ShellEvent>((event, emit) {
//     
//     });
//   }
// }
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'shell_event.dart';
// import 'shell_state.dart';

// features/shell/presentation/bloc/shell_bloc.dart
class ShellBloc extends Bloc<ShellEvent, ShellState> {
  ShellBloc() : super(ShellState.initial()) {
    on<ShellSectionChanged>(_onSectionChanged);
    on<ShellSidebarToggled>(_onSidebarToggled);
  }

  void _onSectionChanged(ShellSectionChanged event, Emitter<ShellState> emit) {
    emit(state.copyWith(section: event.section));
  }

  void _onSidebarToggled(ShellSidebarToggled event, Emitter<ShellState> emit) {
    emit(state.copyWith(sidebarOpen: !state.sidebarOpen));
  }
}
// class ShellBloc extends Bloc<ShellEvent, ShellState> {
//   ShellBloc()
//       : super(ShellState(
//           currentIndex: 0,
//           sidebarOpen: true,
//           sections: const [
//             SectionModel(
//               title: 'Dashboard',
//               icon: Icons.dashboard,
//               iconSelected: AppVectors.dashboardSelected,
//               iconUnselected: AppVectors.dashboardUnSelected,
//             ),
//             SectionModel(
//               title: 'Products',
//               icon: Icons.list_alt,
//               iconSelected: AppVectors.productUnSelected,
//               iconUnselected: AppVectors.productUnSelected,
//             ),
//             SectionModel(
//               title: 'Categories',
//               icon: Icons.category,
//               iconSelected: AppVectors.categoryUnSelected,
//               iconUnselected: AppVectors.categoryUnSelected,
//             ),
//             SectionModel(
//               title: 'Orders',
//               icon: Icons.shopping_bag,
//               iconSelected: AppImages.booking_grey,
//               iconUnselected: AppImages.booking,
//             ),
//             SectionModel(
//               title: 'Purchases',
//               icon: Icons.inventory,
//               iconSelected: AppVectors.moneyUnSelected,
//               iconUnselected: AppVectors.moneyUnSelected,
//             ),
//             SectionModel(
//               title: 'Invoices',
//               icon: Icons.attach_money,
//               iconSelected: AppVectors.moneyUnSelected,
//               iconUnselected: AppVectors.moneyUnSelected,
//             ),
//             SectionModel(
//               title: 'Customers',
//               icon: Icons.verified_user,
//               iconSelected: AppVectors.customerUnSelected,
//               iconUnselected: AppVectors.customerUnSelected,
//             ),
//             SectionModel(
//               title: 'Support',
//               icon: Icons.support,
//               iconSelected: AppVectors.supportUnSelected,
//               iconUnselected: AppVectors.supportUnSelected,
//             ),
//             SectionModel(
//               title: 'Logout',
//               icon: Icons.logout,
//               iconSelected: AppVectors.logoutUnSelected,
//               iconUnselected: AppVectors.logoutUnSelected,
//             ),
//           ],
//         )) {
//     on<ShellSectionChanged>((e, emit) {
//       emit(state.copyWith(currentIndex: e.index));
//     });
//     on<ShellSidebarToggled>((e, emit) {
//       emit(state.copyWith(sidebarOpen: !state.sidebarOpen));
//     });
//   }
// }