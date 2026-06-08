import '../database.dart';

class ProfilesTable extends SupabaseTable<ProfilesRow> {
  @override
  String get tableName => 'profiles';

  @override
  ProfilesRow createRow(Map<String, dynamic> data) => ProfilesRow(data);
}

class ProfilesRow extends SupabaseDataRow {
  ProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProfilesTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get displayName => getField<String>('display_name');
  set displayName(String? value) => setField<String>('display_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get catchphrase => getField<String>('catchphrase');
  set catchphrase(String? value) => setField<String>('catchphrase', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  String? get birthday => getField<String>('birthday');
  set birthday(String? value) => setField<String>('birthday', value);

  String? get languages => getField<String>('languages');
  set languages(String? value) => setField<String>('languages', value);

  String? get height => getField<String>('height');
  set height(String? value) => setField<String>('height', value);

  String? get work => getField<String>('work');
  set work(String? value) => setField<String>('work', value);

  String? get education => getField<String>('education');
  set education(String? value) => setField<String>('education', value);

  String? get kids => getField<String>('kids');
  set kids(String? value) => setField<String>('kids', value);

  String? get relationshipType => getField<String>('relationship_type');
  set relationshipType(String? value) =>
      setField<String>('relationship_type', value);

  String? get bodyType => getField<String>('body_type');
  set bodyType(String? value) => setField<String>('body_type', value);

  String? get exercise => getField<String>('exercise');
  set exercise(String? value) => setField<String>('exercise', value);

  String? get drinking => getField<String>('drinking');
  set drinking(String? value) => setField<String>('drinking', value);

  String? get smoking => getField<String>('smoking');
  set smoking(String? value) => setField<String>('smoking', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get locationLabel => getField<String>('location_label');
  set locationLabel(String? value) => setField<String>('location_label', value);

  int? get heightCm => getField<int>('height_cm');
  set heightCm(int? value) => setField<int>('height_cm', value);

  String? get religion => getField<String>('religion');
  set religion(String? value) => setField<String>('religion', value);

  bool? get isMetric => getField<bool>('is_metric');
  set isMetric(bool? value) => setField<bool>('is_metric', value);
}
