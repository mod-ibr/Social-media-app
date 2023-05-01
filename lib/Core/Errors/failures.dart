import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NoSavedUserFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WeakPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailAlreadyInUseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class FaceBookLogInFailure extends Failure {
  @override
  List<Object?> get props => [];
}
// Maps Failure

class CamPosLocNotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CamPosLocErrorFailure extends Failure {
  @override
  List<Object?> get props => [];
}
