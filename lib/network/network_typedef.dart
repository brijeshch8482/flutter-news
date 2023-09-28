
import 'package:flutter_new_app/network/network_enums.dart';

typedef NetworkCallback<R> = R Function(dynamic);
typedef NetworkOnFailureCallbackWithMessage<R> = R Function(
    NetworkResponseErrorType, String?);