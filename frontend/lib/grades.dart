/// Grade rules, free of Flutter so they can be unit-tested directly.
///
/// Grades are whole hundredths (92.01 -> 9201): every +/-0.01 step is exact, so no
/// floating-point drift builds up after many taps.
library;

/// Lowest grade, 0.00.
const int minGrade = 0;

/// Highest grade, 100.00.
const int maxGrade = 10000;

/// One button tap: 0.01 point.
const int gradeStep = 1;

/// Pass mark, 55.00 (inclusive): 55.00 passes, 54.99 fails.
const int passMark = 5500;

/// One student row. Immutable: a grade change makes a new copy via [withGrade].
class Student {
  const Student({required this.id, required this.name, required this.grade})
    : assert(grade >= minGrade && grade <= maxGrade);

  /// Stable identity, independent of the name and of the shown order.
  final int id;
  final String name;

  /// Grade in hundredths.
  final int grade;

  bool get passed => grade >= passMark;

  Student withGrade(int newGrade) => Student(id: id, name: name, grade: newGrade);
}

/// [grade] moved by [delta] hundredths, held inside [minGrade]..[maxGrade].
int adjustGrade(int grade, int delta) =>
    (grade + delta).clamp(minGrade, maxGrade);

/// Average rounded to one decimal, returned in tenths (66.25 -> 663); null for no grades.
/// Integer maths, half rounds up: round(sum / (n * 10)) = (2 * sum + n * 10) ~/ (2 * n * 10).
int? averageTenths(Iterable<int> grades) {
  var sum = 0;
  var count = 0;
  for (final g in grades) {
    sum += g;
    count++;
  }
  if (count == 0) return null;
  return (2 * sum + count * 10) ~/ (2 * count * 10);
}

/// Hundredths as text with no trailing zeros: 9200 -> "92", 9210 -> "92.1", 9201 -> "92.01".
String formatGrade(int hundredths) {
  final whole = hundredths ~/ 100;
  final frac = hundredths % 100;
  if (frac == 0) return '$whole';
  if (frac % 10 == 0) return '$whole.${frac ~/ 10}';
  return '$whole.${frac.toString().padLeft(2, '0')}';
}

/// Tenths as text with one decimal (663 -> "66.3"); "-" when there is no average.
String formatAverage(int? tenths) =>
    tenths == null ? '-' : '${tenths ~/ 10}.${tenths % 10}';

/// Orders the list can be shown in.
enum SortMode { gradeDesc, gradeAsc, name }

/// A sorted copy (the input is untouched). Ties fall back to name, then [Student.id],
/// so rows never swap places at random when grades are equal.
List<Student> sortStudents(List<Student> students, SortMode mode) {
  int byNameThenId(Student a, Student b) {
    final c = a.name.compareTo(b.name);
    return c != 0 ? c : a.id.compareTo(b.id);
  }

  final list = [...students];
  list.sort((a, b) {
    final primary = switch (mode) {
      SortMode.gradeDesc => b.grade.compareTo(a.grade),
      SortMode.gradeAsc => a.grade.compareTo(b.grade),
      SortMode.name => 0,
    };
    return primary != 0 ? primary : byNameThenId(a, b);
  });
  return list;
}
