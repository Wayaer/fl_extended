/// [RegExp] 的薄封装，构造 API 与原生一致。
///
/// 示例：
/// ```dart
/// final wordPattern = FlRegExp(r'(\w+)');
/// final digitPattern = FlRegExp(r'(\d+)');
/// ```
class FlRegExp implements Pattern {
  FlRegExp(
    String source, {
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) : _regExp = RegExp(source, multiLine: multiLine, caseSensitive: caseSensitive, unicode: unicode, dotAll: dotAll);

  final RegExp _regExp;

  /// 转义正则保留字符，使 [text] 按字面匹配。
  ///
  /// 示例：
  /// ```dart
  /// FlRegExp.escape('a+b'); // a\+b
  /// ```
  static String escape(String text) => RegExp.escape(text);

  /// 返回首个匹配；无匹配时为 null。
  FlRegExpMatch? firstMatch(String input) {
    final match = _regExp.firstMatch(input);
    return match == null ? null : FlRegExpMatch._(match, this);
  }

  /// 返回所有匹配。
  @override
  Iterable<FlRegExpMatch> allMatches(String input, [int start = 0]) {
    return _regExp.allMatches(input, start).map((match) => FlRegExpMatch._(match, this));
  }

  /// 是否存在匹配。
  bool hasMatch(String input) => _regExp.hasMatch(input);

  /// 返回首个匹配的子串；无匹配时为 null。
  String? stringMatch(String input) => _regExp.stringMatch(input);

  /// 从 [start] 起作为前缀匹配。
  @override
  Match? matchAsPrefix(String string, [int start = 0]) => _regExp.matchAsPrefix(string, start);

  /// 正则源模式字符串。
  String get pattern => _regExp.pattern;

  /// 是否多行模式（影响 `^` / `$`）。
  bool get isMultiLine => _regExp.isMultiLine;

  /// 是否区分大小写。
  bool get isCaseSensitive => _regExp.isCaseSensitive;

  /// 是否 Unicode 模式。
  bool get isUnicode => _regExp.isUnicode;

  /// `.` 是否匹配换行符。
  bool get isDotAll => _regExp.isDotAll;
}

/// [RegExpMatch] 的薄封装。
class FlRegExpMatch implements Match {
  FlRegExpMatch._(this._match, this._pattern);

  final RegExpMatch _match;
  final FlRegExp _pattern;

  /// 按名称取捕获组内容。
  String? namedGroup(String name) => _match.namedGroup(name);

  /// 命名捕获组名称集合。
  Iterable<String> get groupNames => _match.groupNames;

  /// 对应的 [FlRegExp]。
  @override
  FlRegExp get pattern => _pattern;

  @override
  String? operator [](int group) => _match[group];

  @override
  int get end => _match.end;

  @override
  String? group(int group) => _match.group(group);

  @override
  int get groupCount => _match.groupCount;

  @override
  List<String?> groups(List<int> groupIndices) => _match.groups(groupIndices);

  @override
  String get input => _match.input;

  @override
  int get start => _match.start;
}
