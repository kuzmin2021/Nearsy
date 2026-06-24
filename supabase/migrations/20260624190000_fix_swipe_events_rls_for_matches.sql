CREATE POLICY "swipe_events_target_can_read" ON "public"."swipe_events"
FOR SELECT USING (auth.uid() = target_user_id);
