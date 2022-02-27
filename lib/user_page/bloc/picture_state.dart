part of 'picture_bloc.dart';

abstract class PictureState extends Equatable {
  const PictureState();

  @override
  List<Object> get props => [];
}

class PictureInitial extends PictureState {}

class PictureSelectedState extends PictureState {
  final File picture;

  PictureSelectedState({required this.picture});
  @override
  // TODO: implement props
  List<Object> get props => [picture];
}

class PictureErroState extends PictureState {
  final String errorMsg;

  PictureErroState({required this.errorMsg});
  @override
  // TODO: implement props
  List<Object> get props => [errorMsg];
}

//class PictureEmpty extends PictureState {}
