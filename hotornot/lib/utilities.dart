import 'dart:convert';

String utf8Decoding(String value) {
  try {
    return utf8.decode(value.runes.toList());
    // ignore: unused_catch_stack
  } catch (e, stacktrace) {
    return value;
  }
}
