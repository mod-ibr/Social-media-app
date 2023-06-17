import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Core/Errors/exception.dart';
import 'package:instagram/Core/Errors/failures.dart';
import 'package:instagram/Core/Services/insta_remote_services.dart';
import 'package:instagram/Features/Auth/Model/auth_model.dart';

import '../../../../Core/Errors/errors_strings.dart';
import '../../../../core/Network/network_connection_checker.dart';

part 'home_view_tab_state.dart';

class HomeViewTabCubit extends Cubit<HomeViewTabState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;
  HomeViewTabCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(HomeTapViewInitial());

  bool showDropdownList = false;
  bool showAddPostStoryReelLiveList = false;

  void instaLogoDropDownButton() {
    showDropdownList = !showDropdownList;
    showAddPostStoryReelLiveList = false;
    emit(DropDownButtonState(showDropdownList: showDropdownList));
  }

  void addPostStoryReelLiveButton() {
    showAddPostStoryReelLiveList = !showAddPostStoryReelLiveList;
    showDropdownList = false;
    emit(AddPostStoryReelLiveState(
        showAddPostStoryReelLiveList: showAddPostStoryReelLiveList));
  }

  void disableAllDropDownLists() {
    showDropdownList = false;
    showAddPostStoryReelLiveList = false;
    emit(DropDownButtonState(showDropdownList: showDropdownList));
  }

  void getUserByUserName(String userName) async {
    emit(LoadingSearchByUserNameState());
    final Either<Failure, List<AuthModel>> failureOrSuccess =
        await _getUserByUsername(userName: userName);

    failureOrSuccess.fold(
      (failure) => emit(
          ErrorSearchByUserNameState(message: _mapFailureToMessage(failure))),
      (success) => emit(SucceededSearchByUserNameState(users: success)),
    );
  }

  Future<Either<Failure, List<AuthModel>>> _getUserByUsername(
      {required String userName}) async {
    if (await networkConnectionChecker.isConnected) {
      try {
        List<AuthModel> users =
            await instaRemoteServices.getUsersByUserName(userName);
        if (users.isEmpty) {
          return Left(EmptySearchFailure());
        }
        return Right(users);
      } on SearchException {
        return Left(SearchFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ErrorsStrings.serverFailureMessage;
      case OfflineFailure:
        return ErrorsStrings.offlineFailureMessage;
      case SearchFailure:
        return ErrorsStrings.searchFailureMessage;
      case EmptySearchFailure:
        return ErrorsStrings.emptySearchFailureMessage;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
