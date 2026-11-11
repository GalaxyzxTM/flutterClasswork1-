import 'package:flutter/material.dart';

import 'grades.dart';

/// App name, shown in the window/tab title.
const String appTitle = 'ציונים';

/// Class list shown at start (grades in hundredths).
const List<Student> initialStudents = [
  Student(id: 1, name: 'נועה', grade: 9200),
  Student(id: 2, name: 'דנה', grade: 7100),
  Student(id: 3, name: 'יוסף', grade: 5400),
  Student(id: 4, name: 'עומר', grade: 4800),
];

/// Hebrew labels for the sort menu.
const Map<SortMode, String> sortLabels = {
  SortMode.gradeDesc: 'ציון: מהגבוה לנמוך',
  SortMode.gradeAsc: 'ציון: מהנמוך לגבוה',
  SortMode.name: 'שם (א-ת)',
};

void main() {
  runApp(const GradesApp());
}

/// Root widget: theme, right-to-left layout, and the grades screen.
class GradesApp extends StatelessWidget {
  const GradesApp({super.key, this.students = initialStudents});

  /// Starting list; tests pass their own.
  final List<Student> students;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      // Whole palette derived from one seed colour; change the seed to re-theme the app.
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      // Hebrew UI: the whole app lays out right-to-left (title right, actions left),
      // without pulling in the localizations package.
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: GradesPage(students: students),
    );
  }
}

/// The class list: average in the app bar, one row per student with a pass/fail mark
/// and -/+ buttons that move the grade by 0.01.
class GradesPage extends StatefulWidget {
  const GradesPage({super.key, required this.students});

  final List<Student> students;

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late List<Student> _students = [...widget.students];

  /// Highest grade first, as in the original list.
  SortMode _sort = SortMode.gradeDesc;

  /// Replaces the student with [id] by a copy whose grade moved by [delta] (clamped).
  void _changeGrade(int id, int delta) {
    setState(() {
      _students = [
        for (final s in _students)
          s.id == id ? s.withGrade(adjustGrade(s.grade, delta)) : s,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sorted fresh on every build, so a row moves as soon as its grade passes another.
    final shown = sortStudents(_students, _sort);
    final average = formatAverage(averageTenths(_students.map((s) => s.grade)));

    return Scaffold(
      appBar: AppBar(
        title: Text('ממוצע: $average'),
        actions: [_sortMenu(), const SizedBox(width: 8)],
      ),
      body: ListView.builder(
        itemCount: shown.length,
        itemBuilder: (context, i) => _studentRow(shown[i]),
      ),
    );
  }

  /// Round sort button; its menu ticks the current order.
  Widget _sortMenu() {
    return MenuAnchor(
      menuChildren: [
        for (final mode in SortMode.values)
          MenuItemButton(
            leadingIcon: Icon(mode == _sort ? Icons.check : null),
            onPressed: () => setState(() => _sort = mode),
            child: Text(sortLabels[mode]!),
          ),
      ],
      builder: (context, controller, _) => IconButton.filledTonal(
        icon: const Icon(Icons.sort),
        tooltip: 'מיון',
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }

  /// One row; in RTL the mark sits on the right and the buttons on the left (+ outermost).
  Widget _studentRow(Student s) {
    return ListTile(
      key: ValueKey('student-${s.id}'),
      leading: s.passed
          ? const Icon(Icons.check_circle, color: Colors.green, semanticLabel: 'עבר')
          : const Icon(Icons.cancel, color: Colors.red, semanticLabel: 'נכשל'),
      title: Text(s.name),
      subtitle: Text('ציון: ${formatGrade(s.grade)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: ValueKey('minus-${s.id}'),
            icon: const Icon(Icons.remove),
            tooltip: 'הורדת 0.01',
            // Disabled at the floor, so a tap never looks like it did nothing.
            onPressed: s.grade > minGrade
                ? () => _changeGrade(s.id, -gradeStep)
                : null,
          ),
          IconButton(
            key: ValueKey('plus-${s.id}'),
            icon: const Icon(Icons.add),
            tooltip: 'הוספת 0.01',
            onPressed: s.grade < maxGrade
                ? () => _changeGrade(s.id, gradeStep)
                : null,
          ),
        ],
      ),
    );
  }
}
