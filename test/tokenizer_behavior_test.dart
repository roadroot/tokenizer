import 'dart:io';

import 'package:test/test.dart';
import 'package:tokenizer_parser/tokenizer_parser.dart';

void main() {
  group('Tokenizer behavior', () {
    const identifier = LiteralModel(name: 'identifier', pattern: r'[A-Za-z_]+');
    const whitespace = LiteralModel(name: 'whitespace', pattern: r'\s+');
    const equalsSign = LiteralModel(name: 'equals', pattern: r'=');

    const assignment = NonLiteralModel(
      name: 'assignment',
      sequence: TokenSequence('identifier-equals-identifier', [
        identifier,
        equalsSign,
        identifier,
      ]),
    );

    final lang = <TokenModel>[identifier, whitespace, equalsSign, assignment];

    test('tokenize with ignore filters token models', () {
      final result = Tokenizer.tokenize('name = value', lang, [whitespace]);

      expect(result.$1.any((t) => t.model == whitespace), isFalse);
      expect(result.$2, isEmpty);
    });

    test('tokenize produces non-literal composed token', () {
      final result = Tokenizer.tokenize('a=b', lang);

      final assignmentTokens =
          result.$1.where((e) => e.model == assignment).toList();
      expect(assignmentTokens, hasLength(1));
      expect(assignmentTokens.single.value, 'a=b');
      expect(assignmentTokens.single.children, hasLength(3));
      expect(result.$2, isEmpty);
    });

    test('tokenize leaves unmatched input in remaining segments', () {
      final result = Tokenizer.tokenize('x=@', lang, [whitespace]);

      expect(result.$2, isNotEmpty);
      expect(result.$2.last.input, '@');
    });

    test('tokenizeFile reads file and tokenizes content', () {
      final dir = Directory.systemTemp.createTempSync('tokenizer_parser_test_');
      try {
        final file = File('${dir.path}/input.txt')
          ..writeAsStringSync('left=right');
        final result = Tokenizer.tokenizeFile(file.path, lang);

        expect(result.$1.where((e) => e.model == assignment), isNotEmpty);
        expect(result.$2, isEmpty);
      } finally {
        dir.deleteSync(recursive: true);
      }
    });
  });
}
