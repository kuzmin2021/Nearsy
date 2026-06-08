# Lookaround MVP (Nearsy)

Tinder-подобное мобильное приложение для знакомств. «Meet near. Keep it easy.»

Flutter-проект, сгенерированный через FlutterFlow с кастомным фреймворком Floter.

## Стек

| Слой | Технологии |
|---|---|
| **Язык** | Dart (Flutter SDK >=3.0.0) |
| **Навигация** | GoRouter 12.x |
| **Бэкенд** | Supabase (PostgreSQL, Auth, Storage) |
| **Состояние** | Provider + ChangeNotifier |
| **UI** | flutter_card_swiper, cached_network_image, google_fonts |

## Запуск

```bash
flutter pub get
flutter run
# или для веба:
flutter run -d chrome
```

### Переменные окружения

Конфигурация через `--dart-define` (compile-time constants). См. `.env.example`.

```bash
flutter run \
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
  --dart-define=SUPABASE_ANON_KEY=sb_publishable_xxx
```

Для production — переопределить на реальный Supabase-проект.

---

## Локальный Supabase (Docker)

### Инициализация и запуск

```bash
# Предварительно: Docker должен быть запущен
npx supabase init        # первый раз
npx supabase start       # запустить контейнеры
```

### Доступы

| Сервис | URL |
|---|---|
| REST API | `http://127.0.0.1:54321` |
| Studio (UI) | `http://127.0.0.1:54323` |
| Postgres | `postgresql://postgres:postgres@127.0.0.1:54322/postgres` |
| Mailpit | `http://127.0.0.1:54324` |

### Ключи

| Ключ | Значение |
|---|---|
| Publishable (anon) | `sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH` |
| Secret (service_role) | `YOUR_SUPABASE_SECRET_KEY` |

### Схема базы данных

#### `profiles` (25 полей)
`id, user_id, display_name, email, catchphrase, avatar_url, updated_at, about, gender, birthday, location, location_label, languages, height, height_cm, is_metric, work, education, kids, relationship_type, beliefs, body_type, exercise, drinking, smoking, description, religion`

Row-Level Security: пользователи читают/создают/обновляют только свой профиль.

#### `user_photos` (5 полей)
`id, user_id, photo_url, slot, order`

Row-Level Security: CRUD для своих фото.

#### Storage bucket
- `user_photos` — публичный бакет для фото профиля

### Управление

```bash
npx supabase start         # запустить
npx supabase stop          # остановить
npx supabase status        # статус контейнеров
npx supabase db reset      # сбросить БД + переприменить миграции
npx supabase migration new # создать новую миграцию
```

### Отключённые сервисы
`edge_runtime`, `realtime`, `analytics` — не требуются для MVP и отключены в `supabase/config.toml` для стабильной работы на Windows + WSL2.

---

## Структура проекта

```
lib/
├── main.dart
├── app_state.dart
├── floter/               # FlutterFlow runtime (темы, i18n, навигация)
├── backend/supabase/     # Таблицы БД, CRUD
├── auth/supabase_auth/   # Email/phone аутентификация
├── pages/                # 7 основных экранов
├── profile_*_page/       # 14 редакторов атрибутов профиля
├── components/           # Common UI компоненты
│   └── editor/           # ProfileEditorShell, ProfileRadioSelector, etc.
├── services/             # Бизнес-логика (profile, photo, language)
├── core/config/          # AppConfig (Supabase URL/key)
└── custom_code/          # Кастомные экшены (FlutterFlow hooks)
```

## Тесты

```bash
flutter analyze   # статический анализ
flutter test      # тесты
```
