SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict bJb2IfiyZbCWlRKUFqdXyzKPxMqXSFpZigaqvsmmUQMve2IiVFsEvNakZ9OnjPk

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', '969594bc-8b19-47c3-b8e9-cde2200aec03', '{"action":"user_signedup","actor_id":"828e673d-606d-4018-9e11-e32a6fc009cc","actor_username":"ak@test.ru","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2026-06-08 16:36:18.222013+00', ''),
	('00000000-0000-0000-0000-000000000000', '286a2b67-6374-4d86-8a26-2c0aa8c47cc4', '{"action":"login","actor_id":"828e673d-606d-4018-9e11-e32a6fc009cc","actor_username":"ak@test.ru","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2026-06-08 16:36:18.242883+00', '');


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', 'authenticated', 'authenticated', 'alex@test.ru', '$2a$10$gNOCK2x0hZ4eeXJPdXAXPuxvrkBLI13hN9eTDQ21lbX9Z2nFcabFG', '2026-05-07 09:43:00.255013+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-05-07 09:43:00.262452+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5", "email": "alex@test.ru", "email_verified": true, "phone_verified": false}', NULL, '2026-05-07 09:42:59.897712+00', '2026-05-07 09:43:00.274375+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'authenticated', 'authenticated', 'test@test.ru', '$2a$10$pAF/MGHJK/ZCqhvOD8ciIuiFOB9WX9fcFBSeUgH5MfHRcFjE3DjJ.', '2026-05-07 09:43:17.657183+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-05-07 09:43:31.836292+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "e2f3c6e1-f34c-43e1-82c7-517a494e892d", "email": "test@test.ru", "email_verified": true, "phone_verified": false}', NULL, '2026-05-07 09:43:17.615271+00', '2026-05-26 21:14:18.091354+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', 'authenticated', 'authenticated', 'super@test.ru', '$2a$10$eTt6TyR932k4x3LnNcAzCOwmJRJ891n/jGEdvlrxGxR5jt5inq1n6', '2026-06-03 17:57:59.906691+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-06-04 00:03:07.119217+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "6450bd60-5c7d-4e6c-afc0-34ef1b2ec273", "email": "super@test.ru", "email_verified": true, "phone_verified": false}', NULL, '2026-06-03 17:57:59.656344+00', '2026-06-04 00:03:07.138543+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '3c04af45-d72a-4305-9f75-2bcdcd3032ca', 'authenticated', 'authenticated', 'test@test.com', '$2a$10$aC4X41kt/jluXYO2j/gpXe8kHJUnatnfqUHEUd4d4/DFBPawYFjMa', '2026-05-05 20:11:41.304175+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-05-05 20:11:41.313626+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "3c04af45-d72a-4305-9f75-2bcdcd3032ca", "email": "test@test.com", "email_verified": true, "phone_verified": false}', NULL, '2026-05-05 20:11:41.011102+00', '2026-05-07 08:58:58.615734+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '572db0ac-65d2-4d93-bc80-e331e560cdff', 'authenticated', 'authenticated', 'su@test.ru', '$2a$10$Xnpi5FHY3tELxOZeXlvykOqKu2iTXMbZ3arZPokqz0gX0GZqcBTQC', '2026-06-04 21:09:36.526735+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-06-04 21:10:10.746978+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "572db0ac-65d2-4d93-bc80-e331e560cdff", "email": "su@test.ru", "email_verified": true, "phone_verified": false}', NULL, '2026-06-04 21:09:36.13863+00', '2026-06-04 21:10:10.760795+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '828e673d-606d-4018-9e11-e32a6fc009cc', 'authenticated', 'authenticated', 'ak@test.ru', '$2a$10$zJnHzNUN1MB665g43vU7f.4GPmLXVwjujLYkFYW4F.dCwWIgw2s76', '2026-06-08 16:36:18.223887+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-06-08 16:36:18.245526+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "828e673d-606d-4018-9e11-e32a6fc009cc", "email": "ak@test.ru", "email_verified": true, "phone_verified": false}', NULL, '2026-06-08 16:36:18.201511+00', '2026-06-08 16:36:18.254007+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('3c04af45-d72a-4305-9f75-2bcdcd3032ca', '3c04af45-d72a-4305-9f75-2bcdcd3032ca', '{"sub": "3c04af45-d72a-4305-9f75-2bcdcd3032ca", "email": "test@test.com", "email_verified": false, "phone_verified": false}', 'email', '2026-05-05 20:11:41.299931+00', '2026-05-05 20:11:41.299995+00', '2026-05-05 20:11:41.299995+00', '6d93f4e6-cf8f-43cc-965a-94f054553318'),
	('e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', '{"sub": "e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5", "email": "alex@test.ru", "email_verified": false, "phone_verified": false}', 'email', '2026-05-07 09:43:00.246515+00', '2026-05-07 09:43:00.246568+00', '2026-05-07 09:43:00.246568+00', '530eabfe-8226-46f6-8ea5-f9844ad3601a'),
	('e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{"sub": "e2f3c6e1-f34c-43e1-82c7-517a494e892d", "email": "test@test.ru", "email_verified": false, "phone_verified": false}', 'email', '2026-05-07 09:43:17.654063+00', '2026-05-07 09:43:17.654128+00', '2026-05-07 09:43:17.654128+00', '1aaabf1f-ed10-499e-a8fd-306e913da327'),
	('6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '{"sub": "6450bd60-5c7d-4e6c-afc0-34ef1b2ec273", "email": "super@test.ru", "email_verified": false, "phone_verified": false}', 'email', '2026-06-03 17:57:59.899817+00', '2026-06-03 17:57:59.899881+00', '2026-06-03 17:57:59.899881+00', 'c38453e5-4444-488d-bc7e-4415b9c6b13e'),
	('572db0ac-65d2-4d93-bc80-e331e560cdff', '572db0ac-65d2-4d93-bc80-e331e560cdff', '{"sub": "572db0ac-65d2-4d93-bc80-e331e560cdff", "email": "su@test.ru", "email_verified": false, "phone_verified": false}', 'email', '2026-06-04 21:09:36.516607+00', '2026-06-04 21:09:36.516667+00', '2026-06-04 21:09:36.516667+00', 'fd68b509-4d17-44c1-a514-86e8f1b15e87'),
	('828e673d-606d-4018-9e11-e32a6fc009cc', '828e673d-606d-4018-9e11-e32a6fc009cc', '{"sub": "828e673d-606d-4018-9e11-e32a6fc009cc", "email": "ak@test.ru", "email_verified": false, "phone_verified": false}', 'email', '2026-06-08 16:36:18.215391+00', '2026-06-08 16:36:18.215482+00', '2026-06-08 16:36:18.215482+00', 'fe43f485-3178-4bb6-9882-71bb9755aacc');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('d0ed6e74-797d-447c-89b5-0efcdc0d561e', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '2026-06-03 22:04:40.965821+00', '2026-06-03 22:04:40.965821+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '103.6.170.37', NULL, NULL, NULL, NULL, NULL),
	('26804a09-0280-4af5-b364-eaa2c0b61aa8', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '2026-06-03 17:58:47.666005+00', '2026-06-03 22:57:12.661064+00', NULL, 'aal1', NULL, '2026-06-03 22:57:12.660948', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '103.6.170.37', NULL, NULL, NULL, NULL, NULL),
	('07e8f172-5495-45dc-8a7b-f0e17a99f209', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '2026-06-03 23:06:57.06182+00', '2026-06-03 23:06:57.06182+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '103.6.170.37', NULL, NULL, NULL, NULL, NULL),
	('6303e6fd-29e8-41b4-819e-1ad2579dadb9', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '2026-06-04 00:03:07.120374+00', '2026-06-04 00:03:07.120374+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '103.6.170.37', NULL, NULL, NULL, NULL, NULL),
	('ad736c6e-3dc4-46aa-96bc-0dcbdea976ee', '572db0ac-65d2-4d93-bc80-e331e560cdff', '2026-06-04 21:09:36.537434+00', '2026-06-04 21:09:36.537434+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '31.134.187.239', NULL, NULL, NULL, NULL, NULL),
	('cedde17a-49ba-49b6-bda1-96c387d66b04', '572db0ac-65d2-4d93-bc80-e331e560cdff', '2026-06-04 21:10:10.748197+00', '2026-06-04 21:10:10.748197+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '31.134.187.239', NULL, NULL, NULL, NULL, NULL),
	('8af048ed-d464-4dc3-accb-dd1bb129974e', 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', '2026-05-07 09:43:00.263671+00', '2026-05-07 09:43:00.263671+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '203.96.177.53', NULL, NULL, NULL, NULL, NULL),
	('a3ef1fd0-65a7-40bb-8ec8-289f175e986a', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-07 09:43:17.663647+00', '2026-05-07 09:43:17.663647+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '203.96.177.53', NULL, NULL, NULL, NULL, NULL),
	('f9b8d913-716a-4e00-832a-7a1bcddb32ef', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-07 09:43:31.836407+00', '2026-05-26 21:14:18.107772+00', NULL, 'aal1', NULL, '2026-05-26 21:14:18.10766', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '194.62.99.121', NULL, NULL, NULL, NULL, NULL),
	('383081d8-dd9a-408c-862c-de49d4be029f', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '2026-06-03 17:57:59.921236+00', '2026-06-03 17:57:59.921236+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '31.134.187.239', NULL, NULL, NULL, NULL, NULL),
	('e5c7469c-63ae-4cfa-8dc4-9a07f0b6539d', '828e673d-606d-4018-9e11-e32a6fc009cc', '2026-06-08 16:36:18.245695+00', '2026-06-08 16:36:18.245695+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '172.19.0.1', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('8af048ed-d464-4dc3-accb-dd1bb129974e', '2026-05-07 09:43:00.27604+00', '2026-05-07 09:43:00.27604+00', 'password', '8ef5b9e7-9167-4ce5-a4e9-4a9be9399dc4'),
	('a3ef1fd0-65a7-40bb-8ec8-289f175e986a', '2026-05-07 09:43:17.669113+00', '2026-05-07 09:43:17.669113+00', 'password', 'c6ebf22a-f54c-499a-8a7d-5af757986a7c'),
	('f9b8d913-716a-4e00-832a-7a1bcddb32ef', '2026-05-07 09:43:31.859561+00', '2026-05-07 09:43:31.859561+00', 'password', 'f5dae486-bd95-41ae-bc78-163f4306046f'),
	('383081d8-dd9a-408c-862c-de49d4be029f', '2026-06-03 17:57:59.942588+00', '2026-06-03 17:57:59.942588+00', 'password', 'f5fd89a2-f46b-4efa-a513-905ac29b0c1f'),
	('26804a09-0280-4af5-b364-eaa2c0b61aa8', '2026-06-03 17:58:47.674442+00', '2026-06-03 17:58:47.674442+00', 'password', '740e700d-7d08-4863-af0a-976666ddf7c5'),
	('d0ed6e74-797d-447c-89b5-0efcdc0d561e', '2026-06-03 22:04:41.001226+00', '2026-06-03 22:04:41.001226+00', 'password', '3f87a87a-916f-4a19-a380-097fbf3b68b4'),
	('07e8f172-5495-45dc-8a7b-f0e17a99f209', '2026-06-03 23:06:57.078888+00', '2026-06-03 23:06:57.078888+00', 'password', '991a9cd9-b0cc-4c72-bde0-88eea28375a1'),
	('6303e6fd-29e8-41b4-819e-1ad2579dadb9', '2026-06-04 00:03:07.140758+00', '2026-06-04 00:03:07.140758+00', 'password', '13617b81-de02-4bc7-b554-2a750346024a'),
	('ad736c6e-3dc4-46aa-96bc-0dcbdea976ee', '2026-06-04 21:09:36.576927+00', '2026-06-04 21:09:36.576927+00', 'password', '58b5561a-a922-4ed3-b366-f1dba5798ec4'),
	('cedde17a-49ba-49b6-bda1-96c387d66b04', '2026-06-04 21:10:10.762583+00', '2026-06-04 21:10:10.762583+00', 'password', '18a44828-93e0-4601-a932-91bfd51bb890'),
	('e5c7469c-63ae-4cfa-8dc4-9a07f0b6539d', '2026-06-08 16:36:18.255898+00', '2026-06-08 16:36:18.255898+00', 'password', '6dcd6aea-e040-42a7-b054-74dd892dc272');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 34, '6ts6cuvhlz4g', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 03:06:09.013765+00', '2026-05-08 04:10:22.543666+00', 'grdfhxytip2x', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 35, 'rw3spyeuigjk', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 04:10:22.556935+00', '2026-05-08 06:06:44.990321+00', '6ts6cuvhlz4g', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 36, 'fh6zlxp2me7l', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 06:06:44.999051+00', '2026-05-08 09:39:32.381956+00', 'rw3spyeuigjk', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 37, 'mx66hv3ldcvv', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 09:39:32.395483+00', '2026-05-08 10:39:48.662438+00', 'fh6zlxp2me7l', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 38, 'hhkbmxg3y2ac', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 10:39:48.674312+00', '2026-05-08 11:39:12.938653+00', 'mx66hv3ldcvv', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 39, 'ew2gcbixcwhw', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 11:39:12.950556+00', '2026-05-08 12:38:48.437954+00', 'hhkbmxg3y2ac', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 40, 'dnezmiwewcjn', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 12:38:48.445095+00', '2026-05-08 13:38:48.142438+00', 'ew2gcbixcwhw', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 41, 'vnmqdplv4pq6', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-08 13:38:48.152085+00', '2026-05-12 14:44:30.524519+00', 'dnezmiwewcjn', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 42, 'gotwlczgtpol', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 14:44:30.551483+00', '2026-05-12 15:43:59.440616+00', 'vnmqdplv4pq6', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 43, 'y3utkkahjqze', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 15:43:59.451462+00', '2026-05-12 16:43:26.043489+00', 'gotwlczgtpol', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 44, 'd3pppc7tcjhu', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 16:43:26.058128+00', '2026-05-12 19:19:52.535645+00', 'y3utkkahjqze', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 45, 'aqzzmqd6cza6', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 19:19:52.554551+00', '2026-05-12 20:19:16.899139+00', 'd3pppc7tcjhu', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 46, 'l3o2eui2y4ht', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 20:19:16.909224+00', '2026-05-12 21:18:42.917902+00', 'aqzzmqd6cza6', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 47, 'tvail4yxkn4m', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 21:18:42.929209+00', '2026-05-12 22:18:56.814428+00', 'l3o2eui2y4ht', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 48, 'psql4ykgi673', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 22:18:56.825684+00', '2026-05-12 23:18:57.201097+00', 'tvail4yxkn4m', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 49, 'ejt7rv2cwser', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-12 23:18:57.206046+00', '2026-05-13 06:15:16.474966+00', 'psql4ykgi673', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 50, 'uoyktzfb7ih3', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 06:15:16.481049+00', '2026-05-13 07:14:58.807941+00', 'ejt7rv2cwser', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 51, 'ptdeylcmr3dj', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 07:14:58.818549+00', '2026-05-13 08:14:59.225508+00', 'uoyktzfb7ih3', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 52, '3tpvbcxg2fuk', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 08:14:59.238207+00', '2026-05-13 09:14:57.277734+00', 'ptdeylcmr3dj', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 53, 'fknhhyy7idwd', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 09:14:57.290086+00', '2026-05-13 10:14:58.56045+00', '3tpvbcxg2fuk', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 54, 'oot4sy4fnguw', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 10:14:58.568985+00', '2026-05-13 11:56:02.656262+00', 'fknhhyy7idwd', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 22, 'hzydrtg7kzc6', 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', false, '2026-05-07 09:43:00.271376+00', '2026-05-07 09:43:00.271376+00', NULL, '8af048ed-d464-4dc3-accb-dd1bb129974e'),
	('00000000-0000-0000-0000-000000000000', 23, 'hnqt6jedaari', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', false, '2026-05-07 09:43:17.667097+00', '2026-05-07 09:43:17.667097+00', NULL, 'a3ef1fd0-65a7-40bb-8ec8-289f175e986a'),
	('00000000-0000-0000-0000-000000000000', 24, '5qorkja3ls7z', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 09:43:31.852687+00', '2026-05-07 10:43:07.275569+00', NULL, 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 55, 'nho32jzic7gh', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 11:56:02.666402+00', '2026-05-13 13:02:21.099111+00', 'oot4sy4fnguw', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 25, 'uxu5lw7aznej', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 10:43:07.283209+00', '2026-05-07 11:42:58.455468+00', '5qorkja3ls7z', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 26, 'doul66yc4y7v', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 11:42:58.463018+00', '2026-05-07 12:42:58.759211+00', 'uxu5lw7aznej', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 56, 'xi2sdn4o57op', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 13:02:21.111888+00', '2026-05-13 14:33:47.404611+00', 'nho32jzic7gh', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 27, 'zp2kcq42tzko', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 12:42:58.768084+00', '2026-05-07 13:45:54.204978+00', 'doul66yc4y7v', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 28, 'yzmbvapa64ds', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 13:45:54.209671+00', '2026-05-07 15:09:25.238923+00', 'zp2kcq42tzko', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 57, '2xwm2fwvv3vl', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 14:33:47.417432+00', '2026-05-13 15:38:08.346725+00', 'xi2sdn4o57op', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 29, 'gzdepwotmyeo', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 15:09:25.24659+00', '2026-05-07 18:50:02.547652+00', 'yzmbvapa64ds', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 30, 'reqwdjwz2432', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 18:50:02.568477+00', '2026-05-07 19:49:49.658819+00', 'gzdepwotmyeo', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 58, 'gmdupmi6dbmp', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 15:38:08.363278+00', '2026-05-13 19:19:31.272772+00', '2xwm2fwvv3vl', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 31, 'ihstkb7ej3ek', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 19:49:49.669182+00', '2026-05-07 20:49:49.879532+00', 'reqwdjwz2432', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 32, 'p2skkezc6yyq', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 20:49:49.893978+00', '2026-05-07 21:49:52.770195+00', 'ihstkb7ej3ek', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 59, 'nrrtwbr4pkla', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 19:19:31.282951+00', '2026-05-13 20:24:41.815669+00', 'gmdupmi6dbmp', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 33, 'grdfhxytip2x', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-07 21:49:52.775952+00', '2026-05-08 03:06:08.99869+00', 'p2skkezc6yyq', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 60, 'nhqa46ippuze', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 20:24:41.822832+00', '2026-05-13 21:24:57.64532+00', 'nrrtwbr4pkla', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 61, 'bor3bbnmgxwf', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 21:24:57.650642+00', '2026-05-13 22:24:23.002365+00', 'nhqa46ippuze', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 62, 'ix4dahnhvxvl', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 22:24:23.008874+00', '2026-05-13 23:29:21.139142+00', 'bor3bbnmgxwf', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 63, 'wrm3hthy2kz2', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-13 23:29:21.152201+00', '2026-05-14 06:09:56.595009+00', 'ix4dahnhvxvl', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 64, 'x64clzckgqf4', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-14 06:09:56.613327+00', '2026-05-22 12:39:45.08094+00', 'wrm3hthy2kz2', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 65, 'v5atfa7kx4l3', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-22 12:39:45.098909+00', '2026-05-22 13:39:51.250622+00', 'x64clzckgqf4', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 66, 'xkm7fsrxlbwh', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-22 13:39:51.255626+00', '2026-05-22 19:59:52.798391+00', 'v5atfa7kx4l3', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 67, '5p4hle5rtwfc', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-22 19:59:52.811478+00', '2026-05-22 20:59:28.592523+00', 'xkm7fsrxlbwh', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 68, 'veh45xwwyw5c', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-22 20:59:28.607156+00', '2026-05-22 21:59:29.136511+00', '5p4hle5rtwfc', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 69, '2z6ji4mtg2mn', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-22 21:59:29.153215+00', '2026-05-22 23:00:35.030103+00', 'veh45xwwyw5c', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 70, 'j5qhhosyczvq', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-22 23:00:35.041067+00', '2026-05-23 00:00:01.535868+00', '2z6ji4mtg2mn', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 71, 'merakp6ev3gu', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 00:00:01.542264+00', '2026-05-23 00:59:31.422904+00', 'j5qhhosyczvq', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 98, '2ivchulzpxlk', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', true, '2026-06-03 20:57:11.778906+00', '2026-06-03 21:57:02.261157+00', 'ibfnywutx2ug', '26804a09-0280-4af5-b364-eaa2c0b61aa8'),
	('00000000-0000-0000-0000-000000000000', 72, 'uiwvz5ub4xt4', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 00:59:31.428261+00', '2026-05-23 01:59:01.42354+00', 'merakp6ev3gu', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 100, 'gedsn4is7phb', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', false, '2026-06-03 22:04:40.9893+00', '2026-06-03 22:04:40.9893+00', NULL, 'd0ed6e74-797d-447c-89b5-0efcdc0d561e'),
	('00000000-0000-0000-0000-000000000000', 73, '4ertlk66ihxb', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 01:59:01.430632+00', '2026-05-23 02:58:31.37436+00', 'uiwvz5ub4xt4', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 99, '6bygy3kwcip3', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', true, '2026-06-03 21:57:02.272557+00', '2026-06-03 22:57:12.641228+00', '2ivchulzpxlk', '26804a09-0280-4af5-b364-eaa2c0b61aa8'),
	('00000000-0000-0000-0000-000000000000', 74, 'biefcjbaoc5s', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 02:58:31.386004+00', '2026-05-23 03:58:01.223821+00', '4ertlk66ihxb', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 101, 'vpakcubvfzwj', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', false, '2026-06-03 22:57:12.647833+00', '2026-06-03 22:57:12.647833+00', '6bygy3kwcip3', '26804a09-0280-4af5-b364-eaa2c0b61aa8'),
	('00000000-0000-0000-0000-000000000000', 75, 'q3ywetkvbchy', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 03:58:01.229785+00', '2026-05-23 04:57:28.286746+00', 'biefcjbaoc5s', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 102, 'pq5woopxwj4k', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', false, '2026-06-03 23:06:57.071665+00', '2026-06-03 23:06:57.071665+00', NULL, '07e8f172-5495-45dc-8a7b-f0e17a99f209'),
	('00000000-0000-0000-0000-000000000000', 76, 'dlvp5rrif6s2', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 04:57:28.30069+00', '2026-05-23 05:56:50.040716+00', 'q3ywetkvbchy', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 103, 'ht7g4tcff2lg', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', false, '2026-06-04 00:03:07.135015+00', '2026-06-04 00:03:07.135015+00', NULL, '6303e6fd-29e8-41b4-819e-1ad2579dadb9'),
	('00000000-0000-0000-0000-000000000000', 77, 'otju5fpk3eep', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-23 05:56:50.04932+00', '2026-05-25 13:49:49.354498+00', 'dlvp5rrif6s2', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 104, '56cbrekriptz', '572db0ac-65d2-4d93-bc80-e331e560cdff', false, '2026-06-04 21:09:36.557461+00', '2026-06-04 21:09:36.557461+00', NULL, 'ad736c6e-3dc4-46aa-96bc-0dcbdea976ee'),
	('00000000-0000-0000-0000-000000000000', 78, 'akyzrl6a7s42', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 13:49:49.373674+00', '2026-05-25 14:50:01.71636+00', 'otju5fpk3eep', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 105, 'l7axsleczyna', '572db0ac-65d2-4d93-bc80-e331e560cdff', false, '2026-06-04 21:10:10.75974+00', '2026-06-04 21:10:10.75974+00', NULL, 'cedde17a-49ba-49b6-bda1-96c387d66b04'),
	('00000000-0000-0000-0000-000000000000', 79, 'o67s5cukqcbn', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 14:50:01.727474+00', '2026-05-25 15:50:02.116268+00', 'akyzrl6a7s42', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 80, 'rsurxcwgynvm', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 15:50:02.122677+00', '2026-05-25 17:07:59.037457+00', 'o67s5cukqcbn', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 81, 'c6s7rciispot', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 17:07:59.048433+00', '2026-05-25 18:07:21.534487+00', 'rsurxcwgynvm', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 82, 'p4xo6twqfnjc', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 18:07:21.543328+00', '2026-05-25 19:06:48.236745+00', 'c6s7rciispot', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 83, 'b26g63vqlotl', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 19:06:48.248327+00', '2026-05-25 20:06:12.8582+00', 'p4xo6twqfnjc', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 84, 'c4kotjrjhpve', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 20:06:12.867978+00', '2026-05-25 21:05:34.170386+00', 'b26g63vqlotl', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 85, '3y7n5jq3hp5d', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 21:05:34.180047+00', '2026-05-25 22:05:37.784281+00', 'c4kotjrjhpve', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 86, 'ezl54okqrjqk', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 22:05:37.799643+00', '2026-05-25 23:06:39.092899+00', '3y7n5jq3hp5d', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 87, 'l4hfq5ao2sxr', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-25 23:06:39.110405+00', '2026-05-26 16:06:35.367467+00', 'ezl54okqrjqk', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 88, '2cley6u3d4ow', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-26 16:06:35.393236+00', '2026-05-26 17:07:24.15077+00', 'l4hfq5ao2sxr', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 89, '5r46sylyeuxf', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-26 17:07:24.158998+00', '2026-05-26 18:07:17.909764+00', '2cley6u3d4ow', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 90, 'jt54nfizwerm', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-26 18:07:17.92329+00', '2026-05-26 19:14:35.63308+00', '5r46sylyeuxf', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 91, '664av6d7r2ex', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-26 19:14:35.644926+00', '2026-05-26 20:14:04.300156+00', 'jt54nfizwerm', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 92, 'ck2kxec26k4t', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', true, '2026-05-26 20:14:04.316758+00', '2026-05-26 21:14:18.07276+00', '664av6d7r2ex', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 93, 'ocnncb6g44m7', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', false, '2026-05-26 21:14:18.084838+00', '2026-05-26 21:14:18.084838+00', 'ck2kxec26k4t', 'f9b8d913-716a-4e00-832a-7a1bcddb32ef'),
	('00000000-0000-0000-0000-000000000000', 94, 'wtvkopjz23gm', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', false, '2026-06-03 17:57:59.928297+00', '2026-06-03 17:57:59.928297+00', NULL, '383081d8-dd9a-408c-862c-de49d4be029f'),
	('00000000-0000-0000-0000-000000000000', 95, 'btbmhrc5rouq', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', true, '2026-06-03 17:58:47.670942+00', '2026-06-03 18:58:11.988763+00', NULL, '26804a09-0280-4af5-b364-eaa2c0b61aa8'),
	('00000000-0000-0000-0000-000000000000', 96, 'l3nivndexur5', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', true, '2026-06-03 18:58:12.000707+00', '2026-06-03 19:57:41.899479+00', 'btbmhrc5rouq', '26804a09-0280-4af5-b364-eaa2c0b61aa8'),
	('00000000-0000-0000-0000-000000000000', 97, 'ibfnywutx2ug', '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', true, '2026-06-03 19:57:41.907912+00', '2026-06-03 20:57:11.768949+00', 'l3nivndexur5', '26804a09-0280-4af5-b364-eaa2c0b61aa8'),
	('00000000-0000-0000-0000-000000000000', 106, 'tqxwtxhpafeq', '828e673d-606d-4018-9e11-e32a6fc009cc', false, '2026-06-08 16:36:18.250638+00', '2026-06-08 16:36:18.250638+00', NULL, 'e5c7469c-63ae-4cfa-8dc4-9a07f0b6539d');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: conversation_reads; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."profiles" ("id", "user_id", "display_name", "email", "catchphrase", "avatar_url", "updated_at", "gender", "birthday", "languages", "height", "work", "education", "kids", "relationship_type", "body_type", "exercise", "drinking", "smoking", "description", "location_label", "height_cm", "religion", "is_metric", "deleted_at", "is_hidden", "location_mode", "location", "created_at", "family_plans", "is_verified", "verification_status", "is_onboarded") VALUES
	(8, '3c04af45-d72a-4305-9f75-2bcdcd3032ca', '', 'test@test.com', '??????????????????\??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????', NULL, '2026-05-06 00:22:01.698+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, false, 'while_using', NULL, '2026-05-05 20:11:41.004491+00', NULL, false, 'pending', true),
	(9, 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', '', 'alex@test.ru', NULL, NULL, '2026-05-07 09:42:59.897384+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, false, 'while_using', NULL, '2026-05-07 09:42:59.897384+00', NULL, false, 'pending', false),
	(11, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '????????????', 'test@test.ru', '??????????????????????', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/1779833225026/serj.jpg', '2026-05-07 09:43:17.614295+00', 'woman', '2006-03-03', '{english,russian}', '1710', '??????????????????????', 'high_school', 'true', 'something_serious', 'slim', 'regularly', 'yes', 'sometimes', '????????1', '', 1710, 'agnostic', false, NULL, false, 'while_using', NULL, '2026-05-07 09:43:17.614295+00', NULL, false, 'pending', true),
	(150, '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', '', 'super@test.ru', '', NULL, '2026-06-03 17:57:59.656006+00', 'other', '2006-01-05', '{english,russian}', NULL, '????????????', 'high_school', NULL, NULL, NULL, NULL, 'yes', 'yes', 'dfgdfg', NULL, NULL, NULL, true, NULL, false, 'while_using', NULL, '2026-06-03 17:57:59.656006+00', NULL, false, 'pending', false),
	(171, '572db0ac-65d2-4d93-bc80-e331e560cdff', 'jgjghk', 'su@test.ru', NULL, NULL, '2026-06-04 21:09:36.138306+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, false, 'while_using', NULL, '2026-06-04 21:09:36.138306+00', NULL, false, 'pending', true),
	(174, '828e673d-606d-4018-9e11-e32a6fc009cc', 'Алексей', 'ak@test.ru', 'Лучший', 'http://thecashcow.xyz:8000/storage/v1/object/public/user_photos/828e673d-606d-4018-9e11-e32a6fc009cc/1780937010698/serj.jpg', '2026-06-08 16:36:18.386554+00', 'man', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 'visible', NULL, '2026-06-08 16:36:18.386554+00', NULL, false, NULL, false);


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--



--
-- Data for Name: swipe_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."swipe_events" ("id", "user_id", "target_user_id", "action", "created_at") VALUES
	(1, '828e673d-606d-4018-9e11-e32a6fc009cc', '572db0ac-65d2-4d93-bc80-e331e560cdff', 'like', '2026-06-08 16:44:05.199044+00');


--
-- Data for Name: user_feed_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."user_photos" ("id", "user_id", "photo_url", "photo_path", "storage_path", "slot", "position", "is_main", "deleted_at", "used", "created_at", "order") VALUES
	(24, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:19.177000', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:19.177000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:19.177000', 1, 1, false, NULL, true, '2026-05-26 22:07:21.050599+00', 1),
	(25, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:29.011000', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:29.011000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:29.011000', 2, 2, false, NULL, true, '2026-05-26 22:07:31.072417+00', 2),
	(26, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:40.523000', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:40.523000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:40.523000', 3, 3, false, NULL, true, '2026-05-26 22:07:42.519344+00', 3),
	(27, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:59.543000', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:07:59.543000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:59.543000', 4, 4, false, NULL, true, '2026-05-26 22:08:01.547821+00', 4),
	(28, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:08:11.403000', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:08:11.403000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:08:11.403000', 5, 5, false, NULL, true, '2026-05-26 22:08:14.372393+00', 5),
	(29, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:08:24.283000', 'https://mkmyybajywmljytduftp.supabase.co/storage/v1/object/public/user_photos/e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27%2001:08:24.283000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:08:24.283000', 6, 6, false, NULL, true, '2026-05-26 22:08:26.678576+00', 6),
	(30, '828e673d-606d-4018-9e11-e32a6fc009cc', 'http://thecashcow.xyz:8000/storage/v1/object/public/user_photos/828e673d-606d-4018-9e11-e32a6fc009cc/2026-06-08%2019:43:38.182000', 'http://thecashcow.xyz:8000/storage/v1/object/public/user_photos/828e673d-606d-4018-9e11-e32a6fc009cc/2026-06-08%2019:43:38.182000', '828e673d-606d-4018-9e11-e32a6fc009cc/2026-06-08 19:43:38.182000', 1, 1, false, NULL, false, '2026-06-08 16:43:38.282583+00', 1);


--
-- Data for Name: user_preferences; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."user_preferences" ("id", "user_id", "min_age", "max_age", "max_distance_km", "preferred_genders", "location", "updated_at", "languages", "kids", "smoking", "drinking", "relationship_type", "height_min_cm", "height_max_cm", "religions", "education", "exercise", "body_types") VALUES
	(1, '3c04af45-d72a-4305-9f75-2bcdcd3032ca', 18, 60, 50, '{Woman,Man,Other}', NULL, '2026-05-05 20:11:41.004491+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(2, 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', 18, 60, 50, '{Woman,Man,Other}', NULL, '2026-05-07 09:42:59.897384+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(3, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', 18, 60, 50, '{Woman,Man,Other}', NULL, '2026-05-07 09:43:17.614295+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(4, '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', 18, 60, 50, '{Woman,Man,Other}', NULL, '2026-06-03 17:57:59.656006+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(5, '572db0ac-65d2-4d93-bc80-e331e560cdff', 18, 60, 50, '{Woman,Man,Other}', NULL, '2026-06-04 21:09:36.138306+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: user_seen_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."user_settings" ("id", "user_id", "is_hidden", "updated_at", "push_matches", "push_messages", "push_liked_you", "email_matches", "email_messages", "email_liked_you", "chat_mode") VALUES
	(1, '3c04af45-d72a-4305-9f75-2bcdcd3032ca', false, '2026-05-05 20:11:41.004491+00', true, true, true, false, false, false, 'matched_only'),
	(2, 'e82acd8b-b8bf-4f97-99a3-c09ac58f4bc5', false, '2026-05-07 09:42:59.897384+00', true, true, true, false, false, false, 'matched_only'),
	(3, 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', false, '2026-05-07 09:43:17.614295+00', true, true, true, false, false, false, 'matched_only'),
	(4, '6450bd60-5c7d-4e6c-afc0-34ef1b2ec273', false, '2026-06-03 17:57:59.656006+00', true, true, true, false, false, false, 'matched_only'),
	(5, '572db0ac-65d2-4d93-bc80-e331e560cdff', false, '2026-06-04 21:09:36.138306+00', true, true, true, false, false, false, 'matched_only'),
	(6, '828e673d-606d-4018-9e11-e32a6fc009cc', false, '2026-06-08 16:36:18.201051+00', true, true, true, true, true, true, 'friends');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id", "type") VALUES
	('profile-photos', 'profile-photos', NULL, '2026-05-04 20:59:42.89202+00', '2026-05-04 20:59:42.89202+00', true, false, NULL, NULL, NULL, 'STANDARD'),
	('user_photos', 'user_photos', NULL, '2026-05-12 14:47:07.359446+00', '2026-05-12 14:57:38.647919+00', true, false, NULL, NULL, NULL, 'STANDARD');


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") VALUES
	('cb27d066-9df9-4ffb-9882-54cd42ba40a8', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1778599486692/28f683bf4b.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 15:24:49.443334+00', '2026-05-12 15:24:49.443334+00', '2026-05-12 15:24:49.443334+00', '{"eTag": "\"7dde72530c8702877564e92f6b94f034\"", "size": 217566, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T15:24:50.000Z", "contentLength": 217566, "httpStatusCode": 200}', 'f520fcef-abc7-4ff6-ace9-88d04fd04c15', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('e5ddb903-4a54-4664-a5a9-31b50e753bfb', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1778599505551/7054d9.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 15:25:07.204293+00', '2026-05-12 15:25:07.204293+00', '2026-05-12 15:25:07.204293+00', '{"eTag": "\"a87bbd6584218a9de976cc7fda7ca059\"", "size": 235726, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T15:25:08.000Z", "contentLength": 235726, "httpStatusCode": 200}', 'c98b2a1a-1e99-4347-ab2e-1e97b49ff8e8', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('60f92ac7-806d-4c13-a74b-773f42625445', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 20:12:16.110000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 17:12:17.620178+00', '2026-05-12 17:12:17.620178+00', '2026-05-12 17:12:17.620178+00', '{"eTag": "\"b83e13e1a66e9ab0fe891763fb026652\"", "size": 90158, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T17:12:18.000Z", "contentLength": 90158, "httpStatusCode": 200}', 'e921db92-3f1a-4507-9ad7-af16c479996d', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('58dd9c93-9af7-4d1a-a46d-313c72ec659c', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1778613734797/7054d9.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 19:22:16.531277+00', '2026-05-12 19:22:16.531277+00', '2026-05-12 19:22:16.531277+00', '{"eTag": "\"a87bbd6584218a9de976cc7fda7ca059\"", "size": 235726, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T19:22:17.000Z", "contentLength": 235726, "httpStatusCode": 200}', 'cbfdfa2f-08aa-4b6e-9a26-7dfc2878f70f', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('2653372d-4a74-452d-825f-c5051267c65f', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 22:43:45.337000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 19:43:49.128135+00', '2026-05-12 19:43:49.128135+00', '2026-05-12 19:43:49.128135+00', '{"eTag": "\"24a12d89a70068a9e21a14742c1d38ae\"", "size": 85451, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T19:43:50.000Z", "contentLength": 85451, "httpStatusCode": 200}', 'd6d880da-0f2e-486d-a230-1e257a7c8ad6', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('9545916a-30f1-438f-b4dc-b77535ff5930', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 22:44:11.720000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 19:44:13.143425+00', '2026-05-12 19:44:13.143425+00', '2026-05-12 19:44:13.143425+00', '{"eTag": "\"cbc4146beba989a30919958ebe36555c\"", "size": 108080, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T19:44:14.000Z", "contentLength": 108080, "httpStatusCode": 200}', '81aa1e4f-64a8-418f-85c8-24b9688d6850', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('ba584f58-12e7-4fdc-8486-dbb351ecf38f', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 22:58:22.982000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 19:58:24.387182+00', '2026-05-12 19:58:24.387182+00', '2026-05-12 19:58:24.387182+00', '{"eTag": "\"cbc4146beba989a30919958ebe36555c\"", "size": 108080, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T19:58:25.000Z", "contentLength": 108080, "httpStatusCode": 200}', '2590f0a6-5fd2-4084-bd63-621e3916c49b', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('c0acd0fd-2730-4d1d-8de7-fe8ca8223f7c', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 23:19:57.971000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 20:19:59.255792+00', '2026-05-12 20:19:59.255792+00', '2026-05-12 20:19:59.255792+00', '{"eTag": "\"12196390e03c339267f3c691b825b731\"", "size": 20014, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T20:20:00.000Z", "contentLength": 20014, "httpStatusCode": 200}', '191848fc-2aea-42d9-8df1-2ab54360e0f0', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('a1cc383b-fc0f-4fd8-8c9c-ac9c149a98d2', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 23:20:07.687000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 20:20:08.511211+00', '2026-05-12 20:20:08.511211+00', '2026-05-12 20:20:08.511211+00', '{"eTag": "\"b83e13e1a66e9ab0fe891763fb026652\"", "size": 90158, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T20:20:09.000Z", "contentLength": 90158, "httpStatusCode": 200}', '72b3e44c-194c-4f70-8001-fa2001aede0b', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('e08df393-3e10-45f1-b410-3300db3d52c9', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 23:20:16.918000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 20:20:18.069289+00', '2026-05-12 20:20:18.069289+00', '2026-05-12 20:20:18.069289+00', '{"eTag": "\"9aedb36c5d198dc25347e2a65a7f321b\"", "size": 132119, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T20:20:18.000Z", "contentLength": 132119, "httpStatusCode": 200}', '210de82b-6347-4894-898c-af83924ab47a', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('e3c6521a-7a4e-47c0-9c11-84edd5c7ceb4', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 23:20:37.908000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 20:20:39.07997+00', '2026-05-12 20:20:39.07997+00', '2026-05-12 20:20:39.07997+00', '{"eTag": "\"cbc4146beba989a30919958ebe36555c\"", "size": 108080, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T20:20:39.000Z", "contentLength": 108080, "httpStatusCode": 200}', '76a07bdb-5cc9-4dcc-a807-da82b6638f59', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('a3b83594-3e5a-40ba-90f2-c8474e9d07b3', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-12 23:20:53.781000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 20:20:55.628991+00', '2026-05-12 20:20:55.628991+00', '2026-05-12 20:20:55.628991+00', '{"eTag": "\"7dde72530c8702877564e92f6b94f034\"", "size": 217566, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T20:20:56.000Z", "contentLength": 217566, "httpStatusCode": 200}', 'bb28e901-ac64-4ff8-a413-6c08437eb14d', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('b22dcbf5-4c98-410a-96a9-fb48cca598cc', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1778617267445/28f683bf4b.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 20:21:08.871035+00', '2026-05-12 20:21:08.871035+00', '2026-05-12 20:21:08.871035+00', '{"eTag": "\"7dde72530c8702877564e92f6b94f034\"", "size": 217566, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T20:21:09.000Z", "contentLength": 217566, "httpStatusCode": 200}', 'b9c5ac5c-3379-4fd2-ba23-bbb5f664834d', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('881a9cc5-e640-4d34-b0dc-f5b21d46b74e', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-13 01:04:37.645000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-12 22:04:39.454286+00', '2026-05-12 22:04:39.454286+00', '2026-05-12 22:04:39.454286+00', '{"eTag": "\"b83e13e1a66e9ab0fe891763fb026652\"", "size": 90158, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-12T22:04:40.000Z", "contentLength": 90158, "httpStatusCode": 200}', '9440312f-78df-4024-963e-890a3ca37ddd', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('d3e24d71-4dca-4177-9bd5-12948a355d07', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1778688285870/28f683bf4b.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-13 16:04:47.787476+00', '2026-05-13 16:04:47.787476+00', '2026-05-13 16:04:47.787476+00', '{"eTag": "\"7dde72530c8702877564e92f6b94f034\"", "size": 217566, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-13T16:04:48.000Z", "contentLength": 217566, "httpStatusCode": 200}', '79308d8b-b539-4868-8733-aacc6f6fed5c', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('febad232-003d-4d9a-82c9-2fb36faee081', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-25 23:19:36.710000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-25 20:19:38.074447+00', '2026-05-25 20:19:38.074447+00', '2026-05-25 20:19:38.074447+00', '{"eTag": "\"10b5158c51a63c166cc55f8ed81dc62b\"", "size": 102196, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-25T20:19:39.000Z", "contentLength": 102196, "httpStatusCode": 200}', 'd4c1f97a-d4eb-44de-b467-d28b1c2e4625', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('e89dfe28-5160-4b9a-8295-aa04297b2530', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-25 23:19:50.328000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-25 20:19:51.540826+00', '2026-05-25 20:19:51.540826+00', '2026-05-25 20:19:51.540826+00', '{"eTag": "\"24a12d89a70068a9e21a14742c1d38ae\"", "size": 85451, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-25T20:19:52.000Z", "contentLength": 85451, "httpStatusCode": 200}', 'b2affc4d-6217-41b3-b3fa-30bd3f9ddda8', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('4946913d-0587-4023-915f-7e048ab09fd8', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1779747988567/7054d9.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-25 22:26:30.369837+00', '2026-05-25 22:26:30.369837+00', '2026-05-25 22:26:30.369837+00', '{"eTag": "\"a87bbd6584218a9de976cc7fda7ca059\"", "size": 235726, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-25T22:26:31.000Z", "contentLength": 235726, "httpStatusCode": 200}', 'a6fa345a-5f4c-41ff-ae4e-9a4fe1eff7d4', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('f0e56456-5d75-4d5b-b108-98f1ee848a55', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/1779833225026/serj.jpg', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:07:06.098711+00', '2026-05-26 22:07:06.098711+00', '2026-05-26 22:07:06.098711+00', '{"eTag": "\"12196390e03c339267f3c691b825b731\"", "size": 20014, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:07:07.000Z", "contentLength": 20014, "httpStatusCode": 200}', 'b014c620-781f-443e-919b-181cf186d194', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('a5b1d680-d432-405c-9bbd-22ef63b91434', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:19.177000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:07:20.187229+00', '2026-05-26 22:07:20.187229+00', '2026-05-26 22:07:20.187229+00', '{"eTag": "\"cbc4146beba989a30919958ebe36555c\"", "size": 108080, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:07:21.000Z", "contentLength": 108080, "httpStatusCode": 200}', '52f84690-cd8d-486d-a43f-cb9800b35a12', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('8f967974-7d53-4b21-bb7a-448c034d3765', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:29.011000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:07:30.569528+00', '2026-05-26 22:07:30.569528+00', '2026-05-26 22:07:30.569528+00', '{"eTag": "\"9aedb36c5d198dc25347e2a65a7f321b\"", "size": 132119, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:07:31.000Z", "contentLength": 132119, "httpStatusCode": 200}', '76424458-d488-40b9-8ddc-496b0de2b82e', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('c39edcff-d4d2-41be-8567-47f295f4d0f1', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:08:11.403000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:08:13.946232+00', '2026-05-26 22:08:13.946232+00', '2026-05-26 22:08:13.946232+00', '{"eTag": "\"a87bbd6584218a9de976cc7fda7ca059\"", "size": 235726, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:08:14.000Z", "contentLength": 235726, "httpStatusCode": 200}', 'd8e3a483-75f7-48c6-88ce-3077606552e0', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('6e735e2f-8445-4aab-96c5-1dfe652449d8', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:40.523000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:07:41.970939+00', '2026-05-26 22:07:41.970939+00', '2026-05-26 22:07:41.970939+00', '{"eTag": "\"24a12d89a70068a9e21a14742c1d38ae\"", "size": 85451, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:07:42.000Z", "contentLength": 85451, "httpStatusCode": 200}', 'f7ea115c-5265-4b1e-931c-b7346cb1a3da', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('b4a45c3e-3a00-43af-83f9-3a9f16fa0fb6', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:07:59.543000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:08:01.088579+00', '2026-05-26 22:08:01.088579+00', '2026-05-26 22:08:01.088579+00', '{"eTag": "\"6aa4b14230a98ac6f492306651eb245e\"", "size": 123991, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:08:02.000Z", "contentLength": 123991, "httpStatusCode": 200}', '7b158702-d7a2-44d9-aa0a-88b95ee95445', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('dac01df4-0916-4fc9-ac41-3a85dbf9670e', 'user_photos', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d/2026-05-27 01:08:24.283000', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '2026-05-26 22:08:26.273105+00', '2026-05-26 22:08:26.273105+00', '2026-05-26 22:08:26.273105+00', '{"eTag": "\"7dde72530c8702877564e92f6b94f034\"", "size": 217566, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-05-26T22:08:27.000Z", "contentLength": 217566, "httpStatusCode": 200}', 'f3bd7941-6e4e-47a3-bfad-adf5744b37b6', 'e2f3c6e1-f34c-43e1-82c7-517a494e892d', '{}'),
	('08259ebc-bb41-426c-aff7-67500f6f8083', 'user_photos', '828e673d-606d-4018-9e11-e32a6fc009cc/1780937010698/serj.jpg', '828e673d-606d-4018-9e11-e32a6fc009cc', '2026-06-08 16:43:30.762088+00', '2026-06-08 16:43:30.762088+00', '2026-06-08 16:43:30.762088+00', '{"eTag": "\"12196390e03c339267f3c691b825b731\"", "size": 20014, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-06-08T16:43:30.745Z", "contentLength": 20014, "httpStatusCode": 200}', '80e39cc8-5475-4fc3-bbf1-2aada8f3fe2e', '828e673d-606d-4018-9e11-e32a6fc009cc', '{}'),
	('73c3405d-f3f5-42c2-be2a-5b3809050c58', 'user_photos', '828e673d-606d-4018-9e11-e32a6fc009cc/2026-06-08 19:43:38.182000', '828e673d-606d-4018-9e11-e32a6fc009cc', '2026-06-08 16:43:38.240236+00', '2026-06-08 16:43:38.240236+00', '2026-06-08 16:43:38.240236+00', '{"eTag": "\"a87bbd6584218a9de976cc7fda7ca059\"", "size": 235726, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-06-08T16:43:38.225Z", "contentLength": 235726, "httpStatusCode": 200}', '427cf086-957b-4bf1-905f-3e66951edde8', '828e673d-606d-4018-9e11-e32a6fc009cc', '{}');


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 106, true);


--
-- Name: blocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."blocks_id_seq"', 1, false);


--
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."conversations_id_seq"', 1, false);


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."feedback_id_seq"', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."messages_id_seq"', 1, false);


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."profiles_id_seq"', 181, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."reports_id_seq"', 1, false);


--
-- Name: swipe_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."swipe_events_id_seq"', 1, true);


--
-- Name: user_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."user_photos_id_seq"', 30, true);


--
-- Name: user_preferences_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."user_preferences_id_seq"', 5, true);


--
-- Name: user_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."user_settings_id_seq"', 6, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

-- \unrestrict bJb2IfiyZbCWlRKUFqdXyzKPxMqXSFpZigaqvsmmUQMve2IiVFsEvNakZ9OnjPk

RESET ALL;
