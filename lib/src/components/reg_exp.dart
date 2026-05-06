abstract interface class FlRegExp implements Pattern {
  /// Constructs a regular expression.
  ///
  /// Throws a [FormatException] if [source] does not follow valid regular
  /// expression syntax.
  ///
  /// If your code enables `multiLine`, then `^` and `$` will match
  /// the beginning and end of a _line_, as well as matching beginning and
  /// end of the input, respectively.
  ///
  /// If your code disables `caseSensitive`,
  /// then Dart ignores the case of letters when matching.
  /// For example, with `caseSensitive` disable, the regexp pattern `a`
  /// matches both `a` and `A`.
  ///
  /// If your code enables `unicode`, then Dart treats the pattern as a
  /// Unicode pattern per the ECMAScript standard.
  ///
  /// If your code enables `dotAll`, then the `.` pattern will match _all_
  /// characters, including line terminators.
  ///
  /// Example:
  ///
  /// ```dart
  /// final wordPattern = FlRegExp(r'(\w+)');
  /// final digitPattern = FlRegExp(r'(\d+)');
  /// ```
  ///
  /// These examples use a _raw string_ as the argument.
  /// You should prefer to use a raw string as argument to the [FlRegExp]
  /// constructor, because it makes it easy to write
  /// the `\` and `$` characters as regexp reserved characters.
  ///
  /// The same examples written using non-raw strings would be:
  /// ```dart
  /// final wordPattern = FlRegExp('(\\w+)'); // Should be raw string.
  /// final digitPattern = FlRegExp('(\\d+)'); // Should be raw string.
  /// ```
  /// Use a non-raw string only when you need to use
  /// string interpolation. For example:
  /// ```dart
  /// Pattern keyValuePattern(String keyIdentifier) =>
  ///     FlRegExp('$keyIdentifier=(\\w+)');
  /// ```
  /// When including a string verbatim into the regexp pattern like this,
  /// be careful that the string does not contain regular expression
  /// reserved characters.
  /// If that risk exists, use the [escape] function to convert those
  /// characters to safe versions of the reserved characters
  /// and match only the string itself:
  /// ```dart
  /// Pattern keyValuePattern(String anyStringKey) =>
  ///     FlRegExp('${FlRegExp.escape(anyStringKey)}=(\\w+)');
  /// ```
  external factory FlRegExp(
    String source, {
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  });

  /// Creates regular expression syntax that matches the input [text].
  ///
  /// If [text] contains regular expression reserved characters,
  /// the resulting regular expression matches those characters literally.
  /// If [text] contains no regular expression reserved characters,
  /// Dart returns the expression unmodified.
  ///
  /// The reserved characters in regular expressions are:
  /// `(`, `)`, `[`, `]`, `{`, `}`, `*`, `+`, `?`, `.`, `^`, `$`, `|` and `\`.
  ///
  /// Use this method to create a pattern to be included in a
  /// larger regular expression. Since a [String] is itself a [Pattern]
  /// which matches itself, converting the string to a regular expression
  /// isn't needed to search for that exact string.
  /// ```dart
  /// print(FlRegExp.escape('dash@example.com')); // dash@example\.com
  /// print(FlRegExp.escape('a+b')); // a\+b
  /// print(FlRegExp.escape('a*b')); // a\*b
  /// print(FlRegExp.escape('{a-b}')); // \{a-b\}
  /// print(FlRegExp.escape('a?')); // a\?
  /// ```
  external static String escape(String text);

  /// Finds the first match of the regular expression in the string [input].
  ///
  /// Returns `null` if there is no match.
  /// ```dart
  /// final string = '[00:13.37] This is a chat message.';
  /// final regExp = FlRegExp(r'c\w*');
  /// final match = regExp.firstMatch(string)!;
  /// print(match[0]); // chat
  /// ```
  FlRegExpMatch? firstMatch(String input);

  @override
  Iterable<FlRegExpMatch> allMatches(String input, [int start = 0]);

  /// Checks whether this regular expression has a match in the [input].
  ///
  /// ```dart
  /// var string = 'Dash is a bird';
  /// var regExp = FlRegExp(r'(humming)?bird');
  /// var match = regExp.hasMatch(string); // true
  ///
  /// regExp = FlRegExp(r'dog');
  /// match = regExp.hasMatch(string); // false
  /// ```
  bool hasMatch(String input);

  /// Finds the string of the first match of this regular expression
  /// in [input].
  ///
  /// Searches for a match for this regular expression in [input],
  /// just like [firstMatch],
  /// but returns only the matched substring if a match is found,
  /// not a [FlRegExpMatch].
  ///
  /// ```dart
  /// var string = 'Dash is a bird';
  /// var regExp = FlRegExp(r'(humming)?bird');
  /// var match = regExp.stringMatch(string); // Match
  ///
  /// regExp = FlRegExp(r'dog');
  /// match = regExp.stringMatch(string); // No match
  /// ```
  String? stringMatch(String input);

  /// The regular expression pattern source of this `FlRegExp`.
  ///
  /// ```dart
  /// final regExp = FlRegExp(r'\p{L}');
  /// print(regExp.pattern); // \p{L}
  /// ```
  String get pattern;

  /// Whether this regular expression matches multiple lines.
  ///
  /// If the regexp does match multiple lines, the "^" and "$" characters
  /// match the beginning and end of lines. If not, the characters match the
  /// beginning and end of the input.
  bool get isMultiLine;

  /// Whether this regular expression is case sensitive.
  ///
  /// If the regular expression is not case sensitive, it will match an input
  /// letter with a pattern letter even if the two letters are different case
  /// versions of the same letter.
  /// ```dart
  /// final text = 'Parse my string';
  /// var regExp = FlRegExp(r'STRING', caseSensitive: false);
  /// print(regExp.isCaseSensitive); // false
  /// print(regExp.hasMatch(text)); // true, matches.
  ///
  /// regExp = FlRegExp(r'STRING', caseSensitive: true);
  /// print(regExp.isCaseSensitive); // true
  /// print(regExp.hasMatch(text)); // false, no match.
  /// ```
  bool get isCaseSensitive;

  /// Whether this regular expression uses Unicode mode.
  ///
  /// In Unicode mode, Dart treats UTF-16 surrogate pairs in the original
  /// string as a single code point and will not match each code unit in the
  /// pair separately. Otherwise,
  /// Dart treats the target string as a sequence of individual code
  /// units and does not treat surrogates as special.
  ///
  /// In Unicode mode, Dart restricts the syntax of the FlRegExp pattern,
  /// for example disallowing some unescaped uses
  /// of restricted regexp characters,
  /// and disallowing unnecessary `\`-escapes ("identity escapes"),
  /// which have both historically been allowed in non-Unicode mode.
  /// Dart also allows some pattern features, like Unicode property escapes,
  /// only in this mode.
  /// ```dart
  /// var regExp = FlRegExp(r'^\p{L}$', unicode: true);
  /// print(regExp.hasMatch('a')); // true
  /// print(regExp.hasMatch('b')); // true
  /// print(regExp.hasMatch('?')); // false
  /// print(regExp.hasMatch(r'p{L}')); // false
  ///
  /// // U+1F600 (😀), one code point, two code units.
  /// var smiley = '\ud83d\ude00';
  ///
  /// regExp = FlRegExp(r'^.$', unicode: true); // Matches one code point.
  /// print(regExp.hasMatch(smiley)); // true
  /// regExp = FlRegExp(r'^..$', unicode: true); // Matches two code points.
  /// print(regExp.hasMatch(smiley)); // false
  ///
  /// regExp = FlRegExp(r'^\p{L}$', unicode: false);
  /// print(regExp.hasMatch('a')); // false
  /// print(regExp.hasMatch('b')); // false
  /// print(regExp.hasMatch('?')); // false
  /// print(regExp.hasMatch(r'p{L}')); // true
  ///
  /// regExp = FlRegExp(r'^.$', unicode: false);  // Matches one code unit.
  /// print(regExp.hasMatch(smiley)); // false
  /// regExp = FlRegExp(r'^..$', unicode: false);  // Matches two code units.
  /// print(regExp.hasMatch(smiley)); // true
  /// ```
  bool get isUnicode;

  /// Whether "." in this regular expression matches line terminators.
  ///
  /// When false, the "." character matches a single character, unless that
  /// character terminates a line. When true, then the "." character will
  /// match any single character including line terminators.
  ///
  /// This feature is distinct from [isMultiLine]. They affect the behavior
  /// of different pattern characters, so they can be used together or
  /// separately.
  bool get isDotAll;
}

abstract interface class FlRegExpMatch implements Match {
  /// The string captured by the named capture group [name].
  ///
  /// Returns the substring of the input that the
  /// labeled capture group, labeled [name], matched,
  /// or `null` if that capture group was not part of the match.
  ///
  /// The [name] must be the name of a named capture group in the regular
  /// expression [pattern] which created this match.
  /// That is, the name must be in [groupNames].
  String? namedGroup(String name);

  /// The names of the named capture groups of [pattern].
  Iterable<String> get groupNames;

  @override
  FlRegExp get pattern;
}
