part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestInitial extends RequestState {}

class RequestErrorState extends RequestState {
  final String errorMsg;

  RequestErrorState({required this.errorMsg, mapAccounts});

  @override
  List<Object> get props => [errorMsg];
}

class RequestSucces extends RequestState {
  final Map mapAccounts;

  RequestSucces({required this.mapAccounts});

  @override
  List<Object> get props => [mapAccounts];
}
