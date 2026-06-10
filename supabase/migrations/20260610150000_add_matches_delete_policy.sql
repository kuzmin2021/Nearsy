CREATE POLICY matches_delete_participant ON public.matches FOR DELETE TO authenticated USING ((auth.uid() = user1) OR (auth.uid() = user2));

