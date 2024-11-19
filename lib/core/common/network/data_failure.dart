import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../enums/enums.dart';

part 'error_handler.dart';

class DataFailure {
  int? statusCode;
  String? message;
  dynamic data;
  DataFailure({this.statusCode, this.message, this.data});

  DataFailure copyWith({int? statusCode, String? message, dynamic data}) {
    return DataFailure(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data);
  }
}
