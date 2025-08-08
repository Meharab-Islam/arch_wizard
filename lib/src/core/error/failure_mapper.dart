// core/error/failure_mapper.dart
import 'failures.dart';

/// Maps different exceptions to corresponding `Failure` objects.
/// Extend this as your project grows.
Failure mapExceptionToFailure(Exception e) {
  if (e.toString().contains('SocketException')) {
    return const NetworkFailure('No Internet Connection');
  } else if (e.toString().contains('Cache')) {
    return const CacheFailure('Cache error occurred');
  } else {
    return ServerFailure(e.toString());
  }
}
