-- Allow authenticated users to upload to chat_photos bucket
CREATE POLICY "Authenticated can upload chat_photos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'chat_photos');

-- Allow authenticated users to read chat_photos bucket
CREATE POLICY "Authenticated can read chat_photos"
ON storage.objects
FOR SELECT
TO authenticated
USING (bucket_id = 'chat_photos');

-- Users can only upload to their own folder within chat_photos
CREATE POLICY "Users can upload own chat photos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'chat_photos'
  AND (auth.uid())::text = (storage.foldername(name))[1]
);
