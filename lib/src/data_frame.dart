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

  // Вывод DataFrame
  void printDataFrame() {
    print(columns.join(' | '));
    for (var row in data) {
      print(row.join(' | '));
    }
  }

  // Загрузка данных из CSV
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

    final filteredData = data.where((row) => condition(row[columnIndex])).toList();
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
}