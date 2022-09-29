import 'dart:convert';
import 'dart:io';

import 'package:json_to_model/core/json_model.dart';
import 'package:json_to_model/core/model_template.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Check if we can extend another class and add imports via @import', () {
    final content = json.decode(File('test/jsons/extends.json').readAsStringSync()) as Map<String, dynamic>;

    final jsonModel = JsonModel.fromMap(
      'extendsTest',
      content,
      relativePath: './',
      packageName: 'core',
      indexPath: 'index.dart',
    );

    final output = modelFromJsonModel(jsonModel);

    print(output);

    expect(output, contains("class ExtendsTest extends PageResponse<CategoryItem>  {"));
    expect(output, contains("import 'package:apn_http/apn_http';"));

    expect(output, contains("@override final PaginationInfo meta;"));
    expect(output, contains("@override final List<CategoryItem> data;"));
  });
}