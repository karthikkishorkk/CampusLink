# CampusLink

CampusLink is a unified college communication and classroom management platform, consisting of a web admin portal and a cross-platform mobile app.

This README explains how to run the project locally (backend, web, and mobile) and how to configure Supabase for the project.

## Prerequisites

* **Node.js (18+)** and npm
* **Flutter SDK** (for the `mobile/` app) and Android/iOS toolchains
* **Supabase Account** (for a hosted project)
* **Supabase CLI** (for local development and database migrations)

## Repository Layout (Relevant Folders)

* `backend/` — Express backend scaffold using `supabase-js` (JWT verification, booking endpoints, service-level operations).
* `web/` — Next.js / React web admin front-end.
* `mobile/` — Flutter mobile app.

----

## Backend (Local Express Server)

1.  **Set Environment Variables:**
    The backend requires the Supabase Project URL and the `service_role` key to perform admin-level operations.

    You can copy the example file:
    ```bash
    cp backend/.env.example backend/.env
    ```

    Then edit `backend/.env` with your credentials:
    ```.env
    # Get from your Supabase project settings (API)
    SUPABASE_URL="[https://your-project-id.supabase.co](https://your-project-id.supabase.co)"
    SUPABASE_SERVICE_KEY="your-service-role-key"
    ```

2.  **Install Dependencies and Start:**
    ```bash
    cd backend
    npm install
    npm run dev   # nodemon (development)
    # or: npm start
    ```

3.  **Endpoints Available (Examples):**
    * `GET /health` — Health check
    * `POST /bookings` — Create a booking (requires Supabase JWT in `Authorization: Bearer <jwt>`)
    * `GET /bookings` — List bookings

**Notes:**
* The backend expects clients to authenticate with **Supabase Auth** and send their user's JWT. The backend can verify this token or use the **`service_role` key** for trusted operations.
* For file uploads (images, PDFs), prefer direct client uploads to **Supabase Storage** using the client SDKs. You can then store the file metadata in your **Supabase (Postgres) Database**.

----

## Web (Admin) — Local

1.  **Set Environment Variables:**
    The web client needs the *public* Supabase keys. Create a `.env.local` file in the `web/` directory.

    ```bash
    cp web/.env.example web/.env.local
    ```

    Then edit `web/.env.local` with your public credentials:
    ```.env
    # Get from your Supabase project settings (API)
    NEXT_PUBLIC_SUPABASE_URL="[https://your-project-id.supabase.co](https://your-project-id.supabase.co)"
    NEXT_PUBLIC_SUPABASE_ANON_KEY="your-public-anon-key"
    ```

2.  **Install Dependencies and Run:**
    ```bash
    cd web
    npm install
    npm run dev
    ```

3.  The admin UI is a Next.js app. It will be available at `http://localhost:3000`.

----

## Mobile (Flutter)

1.  **Install Flutter SDK** and ensure your device or emulator is available.

2.  **Configure Supabase Client:**
    The mobile app must be initialized with your public Supabase keys. Find the initialization code (likely in `mobile/lib/main.dart` or a services file) and provide your URL and `anon` key.

    ```dart
    // Example (mobile/lib/main.dart)
    await Supabase.initialize(
      url: '[https://your-project-id.supabase.co](https://your-project-id.supabase.co)',
      anonKey: 'your-public-anon-key',
    );
    ```

3.  **Get Dependencies and Run:**
    ```bash
    cd mobile
    flutter pub get
    flutter run   # or use your IDE (Android Studio / VS Code)
    ```

----

## Supabase Setup Notes

1.  **Create a Supabase Project:**
    This will provide you with a dedicated Postgres database, Auth, and Storage.

2.  **Local Development (Recommended):**
    Use the **Supabase CLI** to run the entire Supabase stack locally.
    ```bash
    # Run once to link your project
    supabase login
    supabase link --project-ref <your-project-id>

    # Start the local services
    supabase start
    ```
    This provides local URLs and keys, preventing you from using production data during development.

3.  **Database & Security:**
    * Define your database schema (e.g., in `supabase/migrations`).
    * **Crucially, enable Row Level Security (RLS)** on your tables (e.g., `bookings`, `documents`) to protect data.
* Set up **Storage Policies** to control who can upload or access files.
* Do not commit your `SUPABASE_SERVICE_KEY` to git.

----

## Common Commands

* **Run Backend (Dev):** `cd backend && npm run dev`
* **Run Web (Dev):** `cd web && npm run dev`
* **Run Mobile:** `cd mobile && flutter run`
* **Run Local Supabase Stack:** `supabase start`

## Cleaning Up Tracked Build Files (If Needed)

If you have accidentally committed `node_modules/`, `.next/`, or other build artifacts, run from the repo root:

```bash
git rm -r --cached node_modules || true
git rm -r --cached web/node_modules || true
git rm -r --cached web/.next || true
git rm -r --cached mobile/.dart_tool || true
git rm -r --cached mobile/build || true
git add .gitignore
git commit -m "chore: remove ignored build and dependency artifacts"
