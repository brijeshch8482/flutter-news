import 'dart:convert';

import 'package:flutter_new_app/network/network_enums.dart';
import 'package:flutter_new_app/network/network_typedef.dart';
import 'package:http/http.dart' as http;

class NetworkHelper{
  NetworkHelper._();

  static String concatUrlQp(String url, Map<String, String>? queryParameters){
    if(url.isEmpty) return url;
    if(queryParameters == null || queryParameters.isEmpty){
      return url;
    }

    final StringBuffer stringBuffer = StringBuffer("$url?");
    queryParameters.forEach((key, value) {
      if(value.trim() == '') return;
      if(value.contains(' ')) throw Exception('Invalid Input Exception');
      stringBuffer.write('$key=$value&');
    });

    final result = stringBuffer.toString();
    print("this is the url ${result.substring(0, result.length - 1)}");
    return result.substring(0, result.length - 1);
  }

  static bool _isValidResponse(json){
    return json != null
        && json['status'] != null
        && json['status'] == 'ok'
        && json['articles'] != null;
  }

  static R filterResponse<R>({
    required NetworkCallback callBack,
    required http.Response? response,
    required NetworkOnFailureCallbackWithMessage onFailureCallbackWithMessage,
    CallBackParameterName parameterName = CallBackParameterName.all,
}){
    try{

      if(response == null || response.body.isEmpty){
        return onFailureCallbackWithMessage(NetworkResponseErrorType.responseEmpty, 'empty response');
      }

      var json = jsonDecode(response.body);

      if(response.statusCode == 200){

        if(_isValidResponse(json)){

          print("this is the data ${parameterName.getJson(json)}");
          return callBack(parameterName.getJson(json));

        }
      }else if(response.statusCode == 1708){

        return onFailureCallbackWithMessage(
            NetworkResponseErrorType.socket, 'socket error');

      }

      return onFailureCallbackWithMessage(
          NetworkResponseErrorType.didNotSucceed, 'unknown error');

    }catch(e){
      return onFailureCallbackWithMessage(NetworkResponseErrorType.exception, 'Exception $e');
    }
  }
}