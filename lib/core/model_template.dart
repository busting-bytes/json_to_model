import 'package:json_to_model/core/json_model.dart';

class ModelTemplates {
  static String Function(JsonModel) fromJsonModel =
      (JsonModel data) => ModelTemplates.defaultTemplate(
            imports: data.imports,
            fileName: data.fileName,
            className: data.className,
            declaration: data.declaration,
            enums: data.enums,
            enumConverters: data.enumConverters,
          );

  static String defaultTemplate({
    imports,
    fileName,
    className,
    declaration,
    enums,
    enumConverters,
  }) =>
      """
import 'package:json_annotation/json_annotation.dart';

${imports ?? '/*TODO: imports*/'}

${fileName != null ? "part '$fileName.g.dart';" : "/*TODO: fileName*/"}

@JsonSerializable()
class ${className ?? '/*TODO: className*/'} {
      ${className ?? '/*TODO: className*/'}();

  ${declaration ?? '/*TODO: declaration*/'}

  factory ${className ?? '/*TODO: className*/'}.fromJson(Map<String,dynamic> json) => _\$${className ?? '/*TODO: className*/'}FromJson(json);
  Map<String, dynamic> toJson() => _\$${className ?? '/*TODO: className*/'}ToJson(this);
  
${enumConverters}
}

${enums}
""";

  static String indented(String content, {int indent}) {
    indent = indent ?? 1;
    var indentString = (List(indent)..fillRange(0, indent, '  ')).join('');

    content = content.replaceAll('\n', '\n$indentString');

    return '$indentString$content';
  }
}
