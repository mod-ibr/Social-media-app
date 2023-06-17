part of 'profile_view_tab_cubit.dart';

abstract class ProfileViewTabState extends Equatable {
  const ProfileViewTabState();

  @override
  List<Object> get props => [];
}

class ProfileViewTabInitial extends ProfileViewTabState {}

class LoadingGetUserDataState extends ProfileViewTabState {}

class SucceededGetUserDataState extends ProfileViewTabState {
  final AuthModel userData;
  const SucceededGetUserDataState({required this.userData});
  @override
  List<Object> get props => [userData];
}

class ErrorGetUserDataState extends ProfileViewTabState {
  final Failure failure;

  const ErrorGetUserDataState({required this.failure});
  @override
  List<Object> get props => [failure];
}
