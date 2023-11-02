Future<T?> baseMethodExceptions<T>(Future<T?> Function() baseMethod,
    {Function? onErrorFunction}) async {
  try {
    return await baseMethod();
  } catch (e, stacktrace) {
    if (onErrorFunction != null) {
      return onErrorFunction(e, stacktrace);
    }
  }
  return null;
}

T? baseMethodExceptionsForSync<T>(T? Function() baseMethod,
    {Function? onErrorFunction}) {
  try {
    return baseMethod();
  } catch (e, stacktrace) {
    if (onErrorFunction != null) {
      return onErrorFunction(e, stacktrace);
    }
  }
  return null;
}
