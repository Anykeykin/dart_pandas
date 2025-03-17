# DartPandas

**DartPandas** is a Dart library for working with tabular data, inspired by the famous `pandas` library from Python. It provides convenient tools for processing, analyzing, and visualizing data directly in your Dart applications. DartPandas is perfect for developers who want to use Dart for data analysis but don't want to sacrifice the convenience and power offered by `pandas`.

---

## Key Features

- **DataFrame**: A two-dimensional table with named columns and rows.
- **Data Reading and Writing**: Support for CSV, JSON files.
- **Filtering and Sorting**: Filter data based on conditions and sort by values or index.
- **Aggregation and Statistics**: Sum, mean, min, max, standard deviation, variance.
- **Grouping Data**: Group data by specific columns and apply aggregation functions.
- **Text Processing**: Basic text operations like uppercase, lowercase, and substring replacement.
- **Integration with Flutter**: Easily visualize data using Flutter charts.

---

## Installation

Add `dart_pandas` to your `pubspec.yaml` file:

```yaml
dependencies:
  dart_pandas: ^0.2.2
```

Then run:

```bash
flutter pub get
```

## Usage

Creating a DataFrame

```dart
import 'package:dart_pandas/dart_pandas.dart';

void main() {
  // Create a DataFrame
  final df = DataFrame({
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35],
    'salary': [50000, 60000, 70000],
  });

  // Print the DataFrame
  df.printDataFrame();
}
```

Filtering Data

```dart
final filteredDf = df.filter((row) => row['age'] > 30);
filteredDf.printDataFrame();
```

Sorting Data

```dart
final sortedDf = df.sort('salary', ascending: false);
sortedDf.printDataFrame();
```

Aggregating Data

```dart
final averageSalary = df.mean('salary');
print('Average Salary: $averageSalary');
```

Grouping Data

```dart
final groupedDf = df.groupBy('department');
groupedDf.forEach((key, value) {
  print('Department: $key');
  value.printDataFrame();
});
```