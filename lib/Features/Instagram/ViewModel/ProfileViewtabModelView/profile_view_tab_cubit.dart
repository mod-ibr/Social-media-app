import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:instagram/Core/Errors/exception.dart';
import 'package:instagram/Core/Errors/failures.dart';
import 'package:instagram/Features/Auth/Model/auth_model.dart';
import '../../../../Core/Errors/errors_strings.dart';
import '../../../../core/Network/network_connection_checker.dart';
import '../../../../Core/Services/insta_remote_services.dart';
part 'profile_view_tab_state.dart';

class ProfileViewTabCubit extends Cubit<ProfileViewTabState> {
  final NetworkConnectionChecker networkConnectionChecker;
  final InstaRemoteServices instaRemoteServices;
  ProfileViewTabCubit(
      {required this.networkConnectionChecker,
      required this.instaRemoteServices})
      : super(ProfileViewTabInitial());

  void getUserData() async {
    emit(LoadingGetUserDataState());
    final Either<Failure, AuthModel> failureOrSuccess = await _getUserData();

    failureOrSuccess.fold(
      (failure) => emit(ErrorGetUserDataState(failure: failure)),
      (success) => emit(SucceededGetUserDataState(userData: success)),
    );
  }

  Future<Either<Failure, AuthModel>> _getUserData() async {
    if (await networkConnectionChecker.isConnected) {
      try {
        AuthModel userData = await instaRemoteServices.getuserData();

        return Right(userData);
      } on NoSavedUserException {
        return Left(NoSavedUserFailure());
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ErrorsStrings.serverFailureMessage;
      case OfflineFailure:
        return ErrorsStrings.offlineFailureMessage;
      case NoSavedUserFailure:
        return ErrorsStrings.noSavedUserFailureeMessage;

      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
