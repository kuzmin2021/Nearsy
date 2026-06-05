import '../database.dart';

class UserPhotosTable extends SupabaseTable<UserPhotosRow> {
  @override
  String get tableName => 'user_photos';

  @override
  UserPhotosRow createRow(Map<String, dynamic> data) => UserPhotosRow(data);
}

class UserPhotosRow extends SupabaseDataRow {
  UserPhotosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserPhotosTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  int? get slot => getField<int>('slot');
  set slot(int? value) => setField<int>('slot', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);
}
