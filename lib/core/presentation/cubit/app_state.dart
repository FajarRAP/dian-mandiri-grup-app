part of 'app_cubit.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppInitial extends AppState {}

class AppInProgress extends AppState {
  const AppInProgress();
}

class AppSuccess extends AppState {}

class AppFailure extends AppState {
  const AppFailure({required this.failure});

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class NavigateToLogin extends AppState {}
