import '/backend/supabase/supabase.dart';

List<String> photoCompactGridSlots(List<String> urls) {
  final slots = <String>[...urls];
  final visibleSlots = slots.length < 3 ? 3 : 6;
  if (slots.length < 6) {
    slots.add('__add_photo__');
  }
  while (slots.length < visibleSlots) {
    slots.add('__empty_photo__');
  }
  return slots;
}

bool isFilledPhotoSlot(String? slot) {
  final value = (slot ?? '').trim();
  return value.isNotEmpty &&
      value != '__add_photo__' &&
      value != '__empty_photo__';
}
