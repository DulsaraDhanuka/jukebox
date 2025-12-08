class Lazy<T> {
  final T Function() _func;
  bool _isEvaluated = false;
  Lazy(this._func);
  late T _value;
  T call() {
    if (!_isEvaluated) {
      _value = _func();
      _isEvaluated = true;
    }
    return _value;
  }
}
