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

  ValueNotifier<T> Function<T>(T initialValue) createUseState() {
    final iterator = states.iterator;
    return <T>(T _) {
      iterator.moveNext();
      return iterator.current;
    };
  }

  ValueNotifier<T> useStateInit<T>(T initialValue) {
    final valueNotifier = ValueNotifier<T>(initialValue);
    states.add(valueNotifier);
    return valueNotifier;
  }

  Widget build(BuildContext context) {
    if (states == null) {
      states = [];
      final child = widget.builder(context, useStateInit);
      for (final state in states) {
        state.addListener(() {
          setState(() {});
        });
      }
      return child;
    }
    return widget.builder(context, createUseState());
  }
}
