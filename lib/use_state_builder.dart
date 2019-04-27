import 'package:flutter/widgets.dart';

typedef UseStateWidgetBuilder = Widget Function(BuildContext context,
    ValueNotifier<T> Function<T>(T initialValue) useState);

class UseStateBuilder extends StatefulWidget {
  const UseStateBuilder({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  final UseStateWidgetBuilder builder;

  _UseStateBuilder createState() => _UseStateBuilder();
}

class _UseStateBuilder extends State<UseStateBuilder> {
  List<ValueNotifier> states;
  List<ValueNotifier> prevStates;

  void reassemble() {
    super.reassemble();
    prevStates = states;
    if (prevStates != null) {
      for (final state in prevStates) {
        state.removeListener(setStateNoOp);
      }
    }
    states = null;
  }

  void dispose() {
    super.dispose();
    for (final state in states) {
      state.removeListener(setStateNoOp);
    }
    if (prevStates != null) {
      for (final state in prevStates) {
        state.removeListener(setStateNoOp);
      }
    }
  }

  void setStateNoOp() {
    setState(() {});
  }

  ValueNotifier<T> Function<T>(T initialValue) createUseState() {
    final iterator = states.iterator;
    return <T>(T _) {
      iterator.moveNext();
      return iterator.current;
    };
  }

  useStateInit<T>() {
    final iterator = prevStates?.iterator;
    return <T>(T initialValue) {
      if (iterator != null) {
        iterator.moveNext();
        dynamic prevValue = iterator.current;
        initialValue = prevValue?.value is T ? prevValue?.value : initialValue;
      }
      final valueNotifier = ValueNotifier<T>(initialValue);
      states.add(valueNotifier);
      return valueNotifier;
    };
  }

  Widget build(BuildContext context) {
    if (states == null) {
      states = [];
      final child = widget.builder(context, useStateInit());
      for (final state in states) {
        state.addListener(setStateNoOp);
      }
      return child;
    }
    return widget.builder(context, createUseState());
  }
}
