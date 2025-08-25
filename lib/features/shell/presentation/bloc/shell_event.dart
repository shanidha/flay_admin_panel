


import 'package:equatable/equatable.dart';

import 'shell_state.dart';

abstract class ShellEvent extends Equatable {
  const ShellEvent();
  @override
  List<Object?> get props => [];
}

class ShellSectionChanged extends ShellEvent {
  final ShellSection section;
  const ShellSectionChanged(this.section);

  @override
  List<Object?> get props => [section];
}

class ShellSidebarToggled extends ShellEvent {
  const ShellSidebarToggled();
}



// abstract class ShellEvent extends Equatable {
//   const ShellEvent();
//   @override
//   List<Object?> get props => [];
// }

// class ShellSectionChanged extends ShellEvent {
//   final int index;
//   const ShellSectionChanged(this.index);
//   @override
//   List<Object?> get props => [index];
// }

// class ShellSidebarToggled extends ShellEvent {
//   const ShellSidebarToggled();
// }