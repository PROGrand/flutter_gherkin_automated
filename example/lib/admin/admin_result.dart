import 'package:meta/meta.dart';

@immutable
abstract class AdminResult {}

class AdminResultSuccess extends AdminResult {
  final String id;

  AdminResultSuccess(this.id);
}

class AdminResultError extends AdminResult {
  final dynamic error;

  AdminResultError(this.error);
}
