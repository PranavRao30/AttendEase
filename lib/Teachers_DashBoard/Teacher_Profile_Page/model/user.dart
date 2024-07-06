class User1 {
  final int slno;
  final String firstName;
  final int total_attended;
  final int total_conducted;
  final double percentage;

  const User1({
    required this.slno,
    required this.firstName,
    required this.total_attended,
    required this.total_conducted,
    required this.percentage,
  });

  // Used to modify the changes in the field
  User1 copy({
    int? slno,
    String? firstName,
    int? total_attended,
    int? total_conducted,
    double? percentage,
  }) =>
      User1(
        slno: slno ?? this.slno,
        firstName: firstName ?? this.firstName,
        total_attended: total_attended ?? this.total_attended,
        total_conducted: total_conducted ?? this.total_conducted,
        percentage: percentage ?? this.percentage,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User1 &&
          runtimeType == other.runtimeType &&
          slno == other.slno &&
          firstName == other.firstName &&
          total_attended == other.total_attended &&
          total_conducted == other.total_conducted &&
          percentage == other.percentage;

  @override
  int get hashCode =>
      slno.hashCode ^
      firstName.hashCode ^
      total_attended.hashCode ^
      total_conducted.hashCode ^
      percentage.hashCode;
}
