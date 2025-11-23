import 'package:ship_tracker/core/errors/exceptions.dart';
import 'package:ship_tracker/core/failure/failure.dart';

const tServerFailure = ServerFailure(
  message: 'Server Error Occured',
  statusCode: 500,
);
const tNetworkFailure = NetworkFailure(
  message: 'Network Error Occured',
  statusCode: 500,
);
const tCacheFailure = CacheFailure(
  message: 'Cache Error Occured',
  statusCode: 500,
);

const tServerException = ServerException(
  message: 'Server Error Occured',
  code: 500,
);
const tNetworkException = NetworkException(
  message: 'Network Error Occured',
  code: 500,
);
const tCacheException = CacheException(
  message: 'Cache Error Occured',
  code: 500,
);
