# Supabase Integration

## Overview
The mobile app is now connected to Supabase, the same backend used by the web application.

## Configuration

### Supabase Credentials
Located in `lib/config/supabase_config.dart`:
- **URL**: https://ehwcukgswuhjdcgjnruv.supabase.co
- **Anon Key**: (stored in config file)

### Initialization
Supabase is initialized in `lib/main.dart` before the app starts:
```dart
await Supabase.initialize(
  url: SupabaseConfig.supabaseUrl,
  anonKey: SupabaseConfig.supabaseAnonKey,
);
```

## Services

### SupabaseService (`lib/services/supabase_service.dart`)
Central service for all Supabase operations:

#### Authentication
- `signIn()` - Sign in with email/password
- `signUp()` - Create new account with metadata (role, name, etc.)
- `signOut()` - Log out current user
- `currentUser` - Get current authenticated user
- `authStateChanges` - Stream of auth state changes

#### Classrooms
- `getClassrooms()` - Fetch available classrooms for date/time
- `bookClassroom()` - Book a classroom

#### Notifications
- `getNotifications()` - Fetch notifications (with filters)
- `postNotification()` - Create new notification

#### Events
- `getEvents()` - Fetch all events
- `createEvent()` - Create new event

## Providers (State Management)

All providers have been updated to use Supabase:

### UserProvider
- `login()` - Authenticate with Supabase
- `signUp()` - Register new user
- `logout()` - Sign out from Supabase
- `initializeAuth()` - Load current auth state

### ClassroomProvider
- `getAvailableClassrooms()` - Fetch from Supabase
- `bookClassroom()` - Save booking to Supabase

### NotificationProvider
- `fetchNotifications()` - Load from Supabase
- `postNotification()` - Create in Supabase
- `toggleLike()` - Update locally (TODO: sync to Supabase)

### EventProvider
- `fetchEvents()` - Load from Supabase
- `createEvent()` - Save to Supabase

## Database Schema Required

Your Supabase database should have these tables:

### users (via Supabase Auth)
- Metadata fields: `role`, `name`, `roll_number`

### classrooms
- `id` (uuid)
- `name` (text)
- `date` (timestamp)
- `time_slot` (text)
- `is_available` (boolean)

### bookings
- `id` (uuid)
- `classroom_id` (uuid, foreign key)
- `user_id` (uuid, foreign key)
- `date` (timestamp)
- `time_slot` (text)
- `created_at` (timestamp)

### notifications
- `id` (uuid)
- `title` (text)
- `message` (text)
- `is_priority` (boolean)
- `user_id` (uuid, nullable)
- `is_liked` (boolean)
- `created_at` (timestamp)

### events
- `id` (uuid)
- `title` (text)
- `description` (text)
- `date` (timestamp)
- `image_url` (text, nullable)
- `created_at` (timestamp)

## Changes from Backend Folder

The Node.js backend folder has been removed. All API calls now go directly to Supabase:

**Before**: Mobile → Node.js Backend → Database
**After**: Mobile → Supabase (Auth + Database + APIs)

## Benefits

1. **Unified Backend**: Web and mobile use the same Supabase instance
2. **Real-time**: Can add real-time subscriptions for live updates
3. **Authentication**: Built-in auth with JWT tokens
4. **Security**: Row-level security policies in Supabase
5. **Simplified**: No need to maintain separate Node.js server

## Next Steps

1. Set up Supabase database tables (see schema above)
2. Configure Row Level Security (RLS) policies
3. Test authentication flow
4. Implement real-time subscriptions if needed
5. Add error handling and loading states in UI
