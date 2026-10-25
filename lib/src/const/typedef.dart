import 'dart:async';

/// 无参无返回值回调
typedef Callback = void Function();

/// 无参并返回 [T] 的回调
typedef CallbackT<T> = T Function();

/// 无参异步回调
typedef CallbackFuture = Future<void> Function();

/// 无参并返回 [Future]<[T]> 的回调
typedef CallbackFutureT<T> = Future<T> Function();

/// 无参 [FutureOr] 回调
typedef CallbackFutureOr = FutureOr<void> Function();

/// 无参并返回 [FutureOr]<[T]> 的回调
typedef CallbackFutureOrT<T> = FutureOr<T> Function();

/// 单参同类型映射回调
typedef ValueCallbackT<T> = T Function(T value);

/// 单参无返回值回调
typedef ValueCallback<V> = void Function(V value);

/// 单参并返回 [T] 的回调
typedef ValueCallbackTV<T, V> = T Function(V value);

/// 单参异步回调
typedef ValueCallbackFuture<V> = Future<void> Function(V value);

/// 单参同类型异步映射回调
typedef ValueCallbackFutureT<T> = Future<T> Function(T value);

/// 单参并返回 [Future]<[T]> 的回调
typedef ValueCallbackFutureTV<T, V> = Future<T> Function(V value);

/// 单参 [FutureOr] 回调
typedef ValueCallbackFutureOr<V> = FutureOr<void> Function(V value);

/// 单参同类型 [FutureOr] 映射回调
typedef ValueCallbackFutureOrT<T> = FutureOr<T> Function(T value);

/// 单参并返回 [FutureOr]<[T]> 的回调
typedef ValueCallbackFutureOrTV<T, V> = FutureOr<T> Function(V value);

/// 双参无返回值回调
typedef ValueTwoCallback<V1, V2> = void Function(V1 value1, V2 value2);

/// 双参并返回 [T] 的回调
typedef ValueTwoCallbackT<T, V1, V2> = T Function(V1 value1, V2 value2);

/// 双参异步回调
typedef ValueTwoCallbackFuture<V1, V2> = Future<void> Function(V1 value1, V2 value2);

/// 双参并返回 [Future]<[T]> 的回调
typedef ValueTwoCallbackFutureT<T, V1, V2> = Future<T> Function(V1 value1, V2 value2);

/// 双参 [FutureOr] 回调
typedef ValueTwoCallbackFutureOr<V1, V2> = FutureOr<void> Function(V1 value1, V2 value2);

/// 双参并返回 [FutureOr]<[T]> 的回调
typedef ValueTwoCallbackFutureOrT<T, V1, V2> = FutureOr<T> Function(V1 value1, V2 value2);

/// 三参无返回值回调
typedef ValueThreeCallback<V1, V2, V3> = void Function(V1 value1, V2 value2, V3 value3);

/// 三参并返回 [T] 的回调
typedef ValueThreeCallbackT<T, V1, V2, V3> = T Function(V1 value1, V2 value2, V3 value3);

/// 三参异步回调
typedef ValueThreeCallbackFuture<V1, V2, V3> = Future<void> Function(V1 value1, V2 value2, V3 value3);

/// 三参并返回 [Future]<[T]> 的回调
typedef ValueThreeCallbackFutureT<T, V1, V2, V3> = Future<T> Function(V1 value1, V2 value2, V3 value3);

/// 三参 [FutureOr] 回调
typedef ValueThreeCallbackFutureOr<V1, V2, V3> = FutureOr<void> Function(V1 value1, V2 value2, V3 value3);

/// 三参并返回 [FutureOr]<[T]> 的回调
typedef ValueThreeCallbackFutureOrT<T, V1, V2, V3> = FutureOr<T> Function(V1 value1, V2 value2, V3 value3);

/// 四参无返回值回调
typedef ValueFourCallback<V1, V2, V3, V4> = void Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// 四参并返回 [T] 的回调
typedef ValueFourCallbackT<T, V1, V2, V3, V4> = T Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// 四参异步回调
typedef ValueFourCallbackFuture<V1, V2, V3, V4> = Future<void> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// 四参并返回 [Future]<[T]> 的回调
typedef ValueFourCallbackFutureT<T, V1, V2, V3, V4> = Future<T> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// 四参 [FutureOr] 回调
typedef ValueFourCallbackFutureOr<V1, V2, V3, V4> = FutureOr<void> Function(V1 value1, V2 value2, V3 value3, V4 value4);

/// 四参并返回 [FutureOr]<[T]> 的回调
typedef ValueFourCallbackFutureOrT<T, V1, V2, V3, V4> = FutureOr<T> Function(
  V1 value1,
  V2 value2,
  V3 value3,
  V4 value4,
);

/// 五参无返回值回调
typedef ValueFiveCallback<V1, V2, V3, V4, V5> = void Function(V1 value1, V2 value2, V3 value3, V4 value4, V5 value5);

/// 五参并返回 [T] 的回调
typedef ValueFiveCallbackT<T, V1, V2, V3, V4, V5> = T Function(V1 value1, V2 value2, V3 value3, V4 value4, V5 value5);

/// 五参异步回调
typedef ValueFiveCallbackFuture<V1, V2, V3, V4, V5> = Future<void> Function(
  V1 value1,
  V2 value2,
  V3 value3,
  V4 value4,
  V5 value5,
);

/// 五参并返回 [Future]<[T]> 的回调
typedef ValueFiveCallbackFutureT<T, V1, V2, V3, V4, V5> = Future<T> Function(
  V1 value1,
  V2 value2,
  V3 value3,
  V4 value4,
  V5 value5,
);

/// 五参 [FutureOr] 回调
typedef ValueFiveCallbackFutureOr<V1, V2, V3, V4, V5> = FutureOr<void> Function(
  V1 value1,
  V2 value2,
  V3 value3,
  V4 value4,
  V5 value5,
);

/// 五参并返回 [FutureOr]<[T]> 的回调
typedef ValueFiveCallbackFutureOrT<T, V1, V2, V3, V4, V5> = FutureOr<T> Function(
  V1 value1,
  V2 value2,
  V3 value3,
  V4 value4,
  V5 value5,
);
