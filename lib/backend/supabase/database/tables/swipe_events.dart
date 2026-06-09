import '../database.dart';

class SwipeEventsTable extends SupabaseTable<SwipeEventsRow> {
  @override
  String get tableName => 'swipe_events';

  @override
  SwipeEventsRow createRow(Map<String, dynamic> data) => SwipeEventsRow(data);
}

class SwipeEventsRow extends SupabaseDataRow {
  SwipeEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SwipeEventsTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get targetUserId => getField<String>('target_user_id')!;
  set targetUserId(String value) => setField<String>('target_user_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
