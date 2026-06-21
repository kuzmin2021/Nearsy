CREATE POLICY "conversations_insert_participant" ON "public"."conversations"
FOR INSERT WITH CHECK ((auth.uid() = user1) OR (auth.uid() = user2));
