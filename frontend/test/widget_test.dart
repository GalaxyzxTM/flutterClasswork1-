// Widget tests for the grades screen: average, -/+ buttons, pass mark, sort menu.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_classwork1/grades.dart';
import 'package:flutter_classwork1/main.dart';

/// Top-to-bottom order of the rows' names on screen.
List<String> shownNames(WidgetTester tester) {
  final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList()
    ..sort((x, y) {
      final dy = tester.getTopLeft(find.byWidget(x)).dy;
      return dy.compareTo(tester.getTopLeft(find.byWidget(y)).dy);
    });
  return [for (final t in tiles) (t.title! as Text).data!];
}

void main() {
  testWidgets('starts with the class, its average and high-to-low order', (
    tester,
  ) async {
    await tester.pumpWidget(const GradesApp());

    expect(find.text('ממוצע: 66.3'), findsOneWidget);
    expect(find.text('ציון: 92'), findsOneWidget);
    expect(shownNames(tester), ['נועה', 'דנה', 'יוסף', 'עומר']);
    // 92 and 71 pass, 54 and 48 fail.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    expect(find.byIcon(Icons.cancel), findsNWidgets(2));
    // Layout is right-to-left.
    expect(
      Directionality.of(tester.element(find.byType(ListTile).first)),
      TextDirection.rtl,
    );
  });

  testWidgets('plus and minus move the grade by 0.01', (tester) async {
    await tester.pumpWidget(const GradesApp());

    await tester.tap(find.byKey(const ValueKey('plus-1')));
    await tester.pump();
    expect(find.text('ציון: 92.01'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('minus-1')));
    await tester.tap(find.byKey(const ValueKey('minus-1')));
    await tester.pump();
    expect(find.text('ציון: 91.99'), findsOneWidget);
  });

  testWidgets('average follows the grades', (tester) async {
    await tester.pumpWidget(
      const GradesApp(students: [Student(id: 1, name: 'א', grade: 6624)]),
    );
    expect(find.text('ממוצע: 66.2'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('plus-1')));
    await tester.pump();
    expect(find.text('ממוצע: 66.3'), findsOneWidget);
  });

  testWidgets('crossing 55 flips the pass mark', (tester) async {
    await tester.pumpWidget(
      const GradesApp(students: [Student(id: 1, name: 'א', grade: 5499)]),
    );
    expect(find.byIcon(Icons.cancel), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('plus-1')));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.cancel), findsNothing);
  });

  testWidgets('buttons are disabled at 0 and 100', (tester) async {
    await tester.pumpWidget(
      const GradesApp(
        students: [
          Student(id: 1, name: 'א', grade: maxGrade),
          Student(id: 2, name: 'ב', grade: minGrade),
        ],
      ),
    );
    IconButton button(String key) =>
        tester.widget<IconButton>(find.byKey(ValueKey(key)));

    expect(button('plus-1').onPressed, isNull);
    expect(button('minus-1').onPressed, isNotNull);
    expect(button('minus-2').onPressed, isNull);
    expect(button('plus-2').onPressed, isNotNull);
  });

  testWidgets('sort menu reorders the list', (tester) async {
    await tester.pumpWidget(const GradesApp());

    await tester.tap(find.byTooltip('מיון'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(sortLabels[SortMode.gradeAsc]!));
    await tester.pumpAndSettle();
    expect(shownNames(tester), ['עומר', 'יוסף', 'דנה', 'נועה']);

    await tester.tap(find.byTooltip('מיון'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(sortLabels[SortMode.name]!));
    await tester.pumpAndSettle();
    expect(shownNames(tester), ['דנה', 'יוסף', 'נועה', 'עומר']);
  });
}
