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
}