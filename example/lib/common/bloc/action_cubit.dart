import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ActionState extends Equatable {}

class ActionNone extends ActionState {
  ActionNone();

  @override
  List<Object> get props => [];
}

class ActionComplete extends ActionState {
  ActionComplete({required this.result});

  final dynamic result;

  @override
  List<Object> get props => [result];
}

class ActionInProcess extends ActionState {
  ActionInProcess();

  @override
  List<Object> get props => [];
}

class ActionError extends ActionState {
  ActionError({required this.error});

  final dynamic error;

  @override
  List<Object> get props => [error];
}

abstract class ActionCubit extends Cubit<ActionState> {
  ActionCubit() : super(ActionNone());

  void start() => emit(ActionInProcess());

  void done(dynamic result) => emit(ActionComplete(result: result));

  void error(dynamic error) => emit(ActionError(error: error));
}
