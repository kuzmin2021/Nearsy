-- Auth-only access to user_photos bucket (authenticated upload/read/delete)

-- Upload: only authenticated users can upload
CREATE POLICY "Auth users can upload user_photos"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'user_photos');

-- Read: only authenticated users can read (displayed via signed URLs)
CREATE POLICY "Auth users can read user_photos"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'user_photos');

-- Delete: users can only delete their own folder files
CREATE POLICY "Users can delete own user_photos"
ON storage.objects FOR DELETE TO authenticated
USING (
  bucket_id = 'user_photos'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
