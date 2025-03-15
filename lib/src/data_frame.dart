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
}