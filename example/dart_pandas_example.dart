import 'package:dart_pandas/dart_pandas.dart';

void main() {
  // Create DataFrame from CSV
  final df = DataFrame.fromCsv('Your csv path.csv');
  df.printDataFrame();

  // Filtration data
  final filteredDf = df.filter('age', (age) => age > 30);
  filteredDf.printDataFrame();

  // Sort data
  final sortedDf = df.sort('age', ascending: false);
  sortedDf.printDataFrame();

  // Data arithmetic
  print('Sum of salary: ${df.sum('salary')}');
  print('Mean of salary: ${df.mean('salary')}');

  // Group data
  final groupedDf = df.groupBy('department');
  groupedDf.forEach((key, value) {
    print('Department: $key');
    value.printDataFrame();
  });
}
