import 'dart:async';
// Credits
// https://stackoverflow.com/a/52922130/7834829

class Debouncer<T> {
  Debouncer({required this.duration, this.onValue});

  final Duration duration;

  void Function(T value)? onValue;

  T? _value;
  Timer? _timer;

  T get value => _value!;

  set value(T val) {
    _value = val;
    _timer?.cancel();
    // ignore: null_check_on_nullable_type_parameter
    _timer = Timer(duration, () => onValue!(_value!));
  }
}