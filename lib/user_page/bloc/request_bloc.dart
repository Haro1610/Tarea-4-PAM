import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<RequestEvent>(requests);
    // TODO: implement event handler
  }
  final String url =
      "https://api.sheety.co/4dc69be7ab2fd73ef180ed08e81f28dd/apiAaron/apiAaron";

  void requests(RequestEvent event, Emitter emitter) async {
    var Maping = await _getRequests();
    if (Maping == null) {
      emitter(RequestErrorState(errorMsg: "No hay datos disponibles"));
    } else {
      emitter(RequestSucces(mapAccounts: Maping));
    }
  }

  Future _getRequests() async {
    try {
      Response res = await get(Uri.parse(url));
      if (res.statusCode == HttpStatus.ok) return jsonDecode(res.body);
    } catch (e) {
      print(e);
    }
  }
}
