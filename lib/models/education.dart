import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

/// Education record synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.institutionName,
    required this.startingYear,
    this.endYear,
    required this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  @JsonKey(defaultValue: '')
  final String institutionName; // JSON key: institution_name
  final int startingYear; // JSON key: starting_year
  final int? endYear; // JSON key: end_year (null while ongoing)

  @JsonKey(defaultValue: '')
  final String description;

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}

// if there are changes to the model,
// run `dart run build_runner build --delete-conflicting-outputs`