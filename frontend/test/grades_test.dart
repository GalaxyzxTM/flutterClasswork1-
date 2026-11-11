// Unit tests for the grade rules in lib/grades.dart.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_classwork1/grades.dart';

void main() {
  group('formatGrade', () {
    test('drops trailing zeros', () {
      expect(formatGrade(9200), '92');
      expect(formatGrade(9210), '92.1');
      expect(formatGrade(9201), '92.01');
      expect(formatGrade(0), '0');
      expect(formatGrade(10000), '100');
    });
  });

  group('averageTenths', () {
    test('class from the design averages 66.3 (66.25 rounds up)', () {
      expect(averageTenths([9200, 7100, 5400, 4800]), 663);
      expect(formatAverage(663), '66.3');
    });

    test('rounds to the nearest tenth', () {
      expect(averageTenths([6624]), 662); // 66.24 -> 66.2
      expect(averageTenths([6625]), 663); // 66.25 -> 66.3
      expect(averageTenths([0]), 0);
      expect(averageTenths([10000]), 1000);
    });

    test('no students gives no average', () {
      expect(averageTenths([]), isNull);
      expect(formatAverage(null), '-');
    });
  });

  group('adjustGrade', () {
    test('moves by the step and stays within 0..100', () {
      expect(adjustGrade(9200, gradeStep), 9201);
      expect(adjustGrade(9200, -gradeStep), 9199);
      expect(adjustGrade(maxGrade, gradeStep), maxGrade);
      expect(adjustGrade(minGrade, -gradeStep), minGrade);
    });
  });

  group('passed', () {
    test('55.00 passes, 54.99 fails', () {
      expect(const Student(id: 1, name: 'a', grade: 5500).passed, isTrue);
      expect(const Student(id: 1, name: 'a', grade: 5499).passed, isFalse);
    });
  });

  group('sortStudents', () {
    const a = Student(id: 1, name: 'ב', grade: 7000);
    const b = Student(id: 2, name: 'א', grade: 9000);
    const c = Student(id: 3, name: 'ג', grade: 7000);
    List<int> ids(List<Student> l) => [for (final s in l) s.id];

    test('grade high to low, ties by name', () {
      expect(ids(sortStudents([a, b, c], SortMode.gradeDesc)), [2, 1, 3]);
    });

    test('grade low to high, ties by name', () {
      expect(ids(sortStudents([a, b, c], SortMode.gradeAsc)), [1, 3, 2]);
    });

    test('by name', () {
      expect(ids(sortStudents([a, b, c], SortMode.name)), [2, 1, 3]);
    });

    test('leaves the input list untouched', () {
      final input = [a, b, c];
      sortStudents(input, SortMode.name);
      expect(ids(input), [1, 2, 3]);
    });
  });
}
