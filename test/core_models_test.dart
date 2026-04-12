import 'package:test/test.dart';
import 'package:tokenizer_parser/tokenizer_parser.dart';

void main() {
  group('Input', () {
    test('value semantics and escaped toString', () {
      final a = Input(input: 'a\n\tb', line: 1, column: 2, index: 3);
      final b = Input(input: 'a\n\tb', line: 1, column: 2, index: 3);
      final c = Input(input: 'x', line: 1, column: 2, index: 3);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      expect(a.toString(), contains(r'\n'));
      expect(a.toString(), contains(r'\t'));
    });
  });

  group('Token', () {
    test('Token.from composes children span and value', () {
      const first = Token(
        model: LiteralModel(name: 'id', pattern: r'[a-z]+'),
        value: 'abc',
        startLine: 0,
        endLine: 0,
        startColumn: 1,
        endColumn: 4,
      );
      const second = Token(
        model: LiteralModel(name: 'sym', pattern: r':'),
        value: ':',
        startLine: 0,
        endLine: 0,
        startColumn: 4,
        endColumn: 5,
      );

      final token = Token.from(
        const NonLiteralModel(
          name: 'field',
          sequence: TokenSequence('pair', [
            LiteralModel(name: 'id', pattern: r'[a-z]+'),
            LiteralModel(name: 'sym', pattern: r':'),
          ]),
        ),
        [first, second],
      );

      expect(token.value, 'abc:');
      expect(token.startColumn, 1);
      expect(token.endColumn, 5);
      expect(token.children, hasLength(2));
    });

    test('Token.from throws on empty children', () {
      expect(
        () => Token.from(
          const NonLiteralModel(
            name: 'empty',
            sequence: TokenSequence('empty', []),
          ),
          [],
        ),
        throwsArgumentError,
      );
    });
  });

  group('Sequence and alternatives', () {
    const id = LiteralModel(name: 'id', pattern: r'[a-z]+');
    const colon = LiteralModel(name: 'colon', pattern: r':');

    test('TokenSequence tokenizeStart success', () {
      const sequence = TokenSequence('id-colon', [id, colon]);
      const tokens = [
        Token(
          model: id,
          value: 'name',
          startLine: 0,
          endLine: 0,
          startColumn: 0,
          endColumn: 4,
        ),
        Token(
          model: colon,
          value: ':',
          startLine: 0,
          endLine: 0,
          startColumn: 4,
          endColumn: 5,
        ),
      ];

      final result = sequence.tokenizeStart(tokens);
      expect(result, isNotNull);
      expect(result!.$1, hasLength(2));
      expect(result.$2, isEmpty);
    });

    test('TokenAlternatives picks first matching option', () {
      const alternatives = TokenAlternatives('choice', [colon, id]);
      const tokens = [
        Token(
          model: id,
          value: 'abc',
          startLine: 0,
          endLine: 0,
          startColumn: 0,
          endColumn: 3,
        ),
      ];

      final result = alternatives.tokenizeStart(tokens);
      expect(result, isNotNull);
      expect(result!.$1.single.model, id);
      expect(result.$2, isEmpty);
    });
  });
}
