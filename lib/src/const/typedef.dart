import 'dart:async';

/// ******** Callback Zero ******** ///
/// Callback Zero
typedef Callback = void Function();

/// Callback Zero
typedef CallbackT<T> = T Function();

/// Future Callback Zero
typedef CallbackFuture = Future<void> Function();

/// Future Callback Zero
typedef CallbackFutureT<T> = Future<T> Function();

/// FutureOr Callback Zero
typedef CallbackFutureOr = FutureOr<void> Function();

/// FutureOr Callback Zero
typedef CallbackFutureOrT<T> = FutureOr<T> Function();

/// ******** Callback One ******** ///
/// Callback One
typedef ValueCallbackT<T> = T Function(T value);

/// Callback One
typedef ValueCallback<V> = void Function(V value);

/// Callback One
typedef ValueCallbackTV<T, V> = T Function(V value);

/// Future Callback One
typedef ValueCallbackFuture<V> = Future<void> Function(V value);

/// Future Callback One
typedef ValueCallbackFutureT<T> = Future<T> Function(T value);

/// Future Callback One
typedef ValueCallbackFutureTV<T, V> = Future<T> Function(V value);

/// FutureOr Callback One
typedef ValueCallbackFutureOr<V> = FutureOr<void> Function(V value);

/// FutureOr Callback One
typedef ValueCallbackFutureOrT<T> = FutureOr<T> Function(T value);

/// FutureOr Callback One
typedef ValueCallbackFutureOrTV<T, V> = FutureOr<T> Function(V value);

/// ******** Callback Two ******** ///
/// Callback Two
typedef ValueTwoCallback<V1, V2> = void Function(V1 value1, V2 value2);

/// Callback Two
typedef ValueTwoCallbackT<T, V1, V2> = T Function(V1 value1, V2 value2);

/// Future Callback Two T
typedef ValueTwoCallbackFuture<V1, V2> =
    Future<void> Function(V1 value1, V2 value2);

/// Future Callback Two T
typedef ValueTwoCallbackFutureT<T, V1, V2> =
    Future<T> Function(V1 value1, V2 value2);

/// FutureOr Callback Two T
typedef ValueTwoCallbackFutureOr<V1, V2> =
    FutureOr<void> Function(V1 value1, V2 value2);

/// FutureOr Callback Two T
typedef ValueTwoCallbackFutureOrT<T, V1, V2> =
    FutureOr<T> Function(V1 value1, V2 value2);

/// ******** Callback Three ******** ///
/// Callback Three
typedef ValueThreeCallback<V1, V2, V3> =
    void Function(V1 value1, V2 value2, V3 value3);

/// Callback Three T
typedef ValueThreeCallbackT<T, V1, V2, V3> =
    T Function(V1 value1, V2 value2, V3 value3);

/// Future Callback Three
typedef ValueThreeCallbackFuture<V1, V2, V3> =
    Future<void> Function(V1 value1, V2 value2, V3 value3);

/// Future Callback Three T
typedef ValueThreeCallbackFutureT<T, V1, V2, V3> =
    Future<T> Function(V1 value1, V2 value2, V3 value3);

/// FutureOr Callback Three
typedef ValueThreeCallbackFutureOr<V1, V2, V3> =
    FutureOr<void> Function(V1 value1, V2 value2, V3 value3);

/// FutureOr Callback Three T
typedef ValueThreeCallbackFutureOrT<T, V1, V2, V3> =
    FutureOr<T> Function(V1 value1, V2 value2, V3 value3);

/// ******** Callback Four ******** ///
/// Callback Four
typedef ValueFourCallback<V1, V2, V3, V4> =
    void Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// Callback Four T
typedef ValueFourCallbackT<T, V1, V2, V3, V4> =
    T Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// Future Callback Four
typedef ValueFourCallbackFuture<V1, V2, V3, V4> =
    Future<void> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// Future Callback Four T
typedef ValueFourCallbackFutureT<T, V1, V2, V3, V4> =
    Future<T> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// FutureOr Callback Four
typedef ValueFourCallbackFutureOr<V1, V2, V3, V4> =
    FutureOr<void> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// FutureOr Callback Four T
typedef ValueFourCallbackFutureOrT<T, V1, V2, V3, V4> =
    FutureOr<T> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// ******** Callback Five ******** ///
/// Callback Five
typedef ValueFiveCallback<V1, V2, V3, V4, V5> =
    void Function(V1 value1, V2 value2, V3 value3, V4 value4, V5 value5);

/// Callback Five T
typedef ValueFiveCallbackT<T, V1, V2, V3, V4, V5> =
    T Function(V1 value1, V2 value2, V3 value3, V4 value4, V5 value5);

/// Future Callback Five
typedef ValueFiveCallbackFuture<V1, V2, V3, V4, V5> =
    Future<void> Function(
      V1 value1,
      V2 value2,
      V3 value3,
      V4 value4,
      V5 value5,
    );

/// Future Callback Five T
typedef ValueFiveCallbackFutureT<T, V1, V2, V3, V4, V5> =
    Future<T> Function(V1 value1, V2 value2, V3 value3, V4 value4, V5 value5);

/// FutureOr Callback Five
typedef ValueFiveCallbackFutureOr<V1, V2, V3, V4, V5> =
    FutureOr<void> Function(
      V1 value1,
      V2 value2,
      V3 value3,
      V4 value4,
      V5 value5,
    );

/// FutureOr Callback Five T
typedef ValueFiveCallbackFutureOrT<T, V1, V2, V3, V4, V5> =
    FutureOr<T> Function(V1 value1, V2 value2, V3 value3, V4 value4, V5 value5);
