import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

class DataFrame {
  final List<String> columns;
  final List<List<dynamic>> data;

  DataFrame({required this.columns, required this.data}) {
    if (data.any((row) => row.length != columns.length)) {
      throw ArgumentError("All rows must have the same length as columns.");
    }
  }

  void printDataFrame() {
    print(columns.join(' | '));
    for (var row in data) {
      print(row.join(' | '));
    }
  }

  static DataFrame fromCsv(String filePath) {
    final file = File(filePath).readAsStringSync();
    final rows = const CsvToListConverter().convert(file);

    final columns = rows[0].cast<String>();
    final data = rows.sublist(1);

    return DataFrame(columns: columns, data: data);
  }

  DataFrame filter(String column, bool Function(dynamic) condition) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError("Column '$column' not found.");
    }

    final filteredData =
        data.where((row) => condition(row[columnIndex])).toList();
    return DataFrame(columns: columns, data: filteredData);
  }

  DataFrame sort(String column, {bool ascending = true}) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError("Column '$column' not found.");
    }

    final sortedData = List<List<dynamic>>.from(data)
      ..sort((a, b) {
        final aValue = a[columnIndex];
        final bValue = b[columnIndex];
        if (aValue == bValue) return 0;
        return (aValue.compareTo(bValue) * (ascending ? 1 : -1));
      });

    return DataFrame(columns: columns, data: sortedData);
  }

  dynamic sum(String column) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError("Column '$column' not found.");
    }

    num total = 0;
    for (var row in data) {
      total += row[columnIndex] as num;
    }
    return total;
  }

  dynamic mean(String column) {
    final count = data.length;
    return count == 0 ? 0 : sum(column) / count;
  }

  dynamic min(String column) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError("Column '$column' not found.");
    }

    return data
        .map((row) => row[columnIndex] as num)
        .reduce((a, b) => a < b ? a : b);
  }

  dynamic max(String column) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError("Column '$column' not found.");
    }

    return data
        .map((row) => row[columnIndex] as num)
        .reduce((a, b) => a > b ? a : b);
  }

  Map<dynamic, DataFrame> groupBy(String column) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex == -1) {
      throw ArgumentError("Column '$column' not found.");
    }

    final groups = <dynamic, List<List<dynamic>>>{};
    for (var row in data) {
      final key = row[columnIndex];
      groups.putIfAbsent(key, () => []).add(row);
    }

    return groups.map((key, value) =>
        MapEntry(key, DataFrame(columns: columns, data: value)));
  }

  static DataFrame fromJson(String jsonString) {
    final data = jsonDecode(jsonString);
    return DataFrame(columns: data['columns'], data: data['data']);
  }

  String toJson() {
    return jsonEncode({'columns': columns, 'data': data});
  }

  void toCsv(String filePath) {
    final csv = const ListToCsvConverter().convert(data);
    File(filePath).writeAsStringSync(csv);
  }

  DataFrame dropna() {
    final cleanedData =
        data.where((row) => !row.any((cell) => cell == null)).toList();
    return DataFrame(columns: columns, data: cleanedData);
  }

  DataFrame fillna(dynamic value) {
    final filledData =
        data.map((row) => row.map((cell) => cell ?? value).toList()).toList();
    return DataFrame(columns: columns, data: filledData);
  }

  DataFrame dropDuplicates() {
    final uniqueData = data.toSet().toList();
    return DataFrame(columns: columns, data: uniqueData);
  }

  List<List<dynamic>> head(int n) {
    return data.sublist(0, n);
  }

  List<List<dynamic>> tail(int n) {
    return data.sublist(data.length - n);
  }

  void info() {
    print('Columns: $columns');
    print('Data types: ${data[0].map((value) => value.runtimeType)}');
    print('Number of rows: ${data.length}');
  }

  void describe() {
    for (var i = 0; i < columns.length; i++) {
      if (data[0][i] is num) {
        final values = data.map((row) => row[i] as num).toList();
        print('Column: ${columns[i]}');
        print('Mean: ${values.reduce((a, b) => a + b) / values.length}');
        print('Min: ${values.reduce((a, b) => a < b ? a : b)}');
        print('Max: ${values.reduce((a, b) => a > b ? a : b)}');
      }
    }
  }

  DataFrame concat(List<DataFrame> dataFrames) {
    final columns = dataFrames.first.columns;
    final data = dataFrames.expand((df) => df.data).toList();
    return DataFrame(columns: columns, data: data);
  }

  List<int> get shape => [data.length, columns.length];

  void upper(String column) {
    final index = columns.indexOf(column);
    if (index == -1) throw ArgumentError('Column not found.');
    for (var row in data) {
      if (row[index] is String) {
        row[index] = (row[index] as String).toUpperCase();
      }
    }
  }

  void lower(String column) {
    final index = columns.indexOf(column);
    if (index == -1) throw ArgumentError('Column not found.');
    for (var row in data) {
      if (row[index] is String) {
        row[index] = (row[index] as String).toLowerCase();
      }
    }
  }
}
