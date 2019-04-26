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
  List<ValueNotifier> states = [];

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

  void initState() {
    super.initState();
    widget.builder(context, useStateInit);
    for (final state in states) {
      state.addListener(() {
        setState(() {});
      });
    }
  }

  Widget build(BuildContext context) => widget.builder(context, createUseState());
}
