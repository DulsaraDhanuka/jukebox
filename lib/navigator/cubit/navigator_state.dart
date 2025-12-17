part of 'navigator_cubit.dart';

sealed class NavigatorState extends Equatable {
  const NavigatorState();

  @override
  List<Object> get props => [];
}

final class NavigatorLibraryPage extends NavigatorState {}
final class NavigatorPlayerPage extends NavigatorState {}
