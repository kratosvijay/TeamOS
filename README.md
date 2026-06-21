# TeamOS

TeamOS is an enterprise-grade, all-in-one collaboration and productivity platform designed to unify workspace tasks, real-time messaging, and high-fidelity video meetings. Synthesizing the power of platforms like **Jira, Slack, Microsoft Teams, and Confluence**, TeamOS coordinates agile project delivery with immediate team interactions.

---

## 🚀 Technology Stack

### Backend (NestJS Monolithic Modular)
* **Core Framework**: NestJS (TypeScript)
* **Database & ORM**: PostgreSQL with Prisma ORM
* **Realtime Server**: Socket.IO for WebSockets and room isolation
* **Distributed Queueing**: Redis with BullMQ (delayed jobs, email queues, search indexing, and AI tasks)
* **Search Engine**: OpenSearch (full-text search across messages, tasks, and meeting artifacts)
* **Media & WebRTC Gateway**: LiveKit Server SDK (SFU WebRTC)
* **Object Storage**: MinIO (AWS S3-compatible cloud storage for meeting recordings and attachments)

### Frontend (Flutter Cross-Platform)
* **Framework**: Flutter 3.x (Dart)
* **State Management**: Riverpod & Flutter Hooks
* **Routing**: GoRouter
* **Data Serialization**: Freezed & JSON Serializable
* **UI**: Custom Vanilla CSS-inspired designs, fully responsive across Mobile, Tablet, and Desktop web dimensions

---

## 🗂 Project Structure

```
TeamOS/
├── README.md                          # Main project guide
├── backend/                           # NestJS Monolithic Backend
│   ├── prisma/
│   │   ├── schema.prisma              # PostgreSQL database models
│   │   └── migrations/                # Database migration logs
│   ├── src/
│   │   ├── app.module.ts              # Root application module
│   │   ├── main.ts                    # Server entrypoint
│   │   ├── common/                    # Guards, decorators, and interceptors
│   │   └── modules/                   # Monolithic business modules
│   │       ├── auth/                  # JWT, Refresh Tokens, OAuth (Google/Microsoft)
│   │       ├── workspace/             # Multi-tenant workspace architecture
│   │       ├── workspace-settings/    # Tenant-level settings & feature flags
│   │       ├── project/               # Project registries
│   │       ├── task/                  # Sprint ceremonies and task tracking engine
│   │       ├── chat/                  # Slack-style channels, DMs, thread replies, and pins
│   │       ├── livekit/               # WebRTC token claims and media controls
│   │       ├── storage/               # S3/MinIO upload/download gateways
│   │       ├── meeting/               # Google Meet-style waiting rooms, breakouts, and analytics
│   │       └── search/                # OpenSearch cluster synchronization
│   └── test/                          # Unit & integration testing suites
└── TeamOS-app/                        # Flutter Mobile & Desktop App
    ├── pubspec.yaml                   # Dart dependencies configuration
    └── lib/
        ├── main.dart                  # App runner
        ├── routes/
        │   └── app_router.dart        # Route map definitions
        └── features/                  # Feature-first architectures
            ├── auth/                  # Register/Login UI flows
            ├── workspace/             # Multi-workspace directory switcher
            ├── dashboard/             # Core layout & project feed metrics
            ├── tasks/                 # Kanban boards, custom fields, and task templates
            └── meetings/              # Active huddle frames, scheduler, outcomes logs
```

---

## ✨ Features Checklist

### 1. Authentication & Security (Phase 1-2)
- [x] JWT Authentication & stateless claims validation.
- [x] Refresh Token Rotation (RTR) to prevent session hijacking.
- [x] Device tracking, login audit trails, and IP logs.
- [x] Google & Microsoft OAuth code flow integration.

### 2. Tenant & Workspace management (Phase 3-4)
- [x] Multi-tenant workspace isolation.
- [x] Granular Role-Based Access Control (RBAC) (Owner, Moderator, Member, Guest).
- [x] Feature Flags & Workspace Settings to enable/disable documents, chats, AI, and meetings.

### 3. Agile Task Engine (Phase 5-7)
- [x] Multi-level hierarchy: `Epic ➔ Story ➔ Task / Bug ➔ Subtask`.
- [x] Kanban positioning system with float-based layout ordering (O(1) drag-and-drop moves).
- [x] Custom fields system (Number, Date, URL, Multi-select, Dropdowns).
- [x] Sprint ceremonies, task watchers, real-time mentions, and audit trails.

### 4. Realtime Chat Platform (Phase 8)
- [x] Slack-style public and private channels.
- [x] Direct messages and threaded discussions.
- [x] Emoji reactions and pinned messages.
- [x] Realtime typing indicators, read receipts, and presence status.

### 5. High-Fidelity Huddles & Meetings (Phase 9)
- [x] LiveKit audio/video SFU connection tokens.
- [x] Host moderator tools (Waiting room approvals, muting, breakout room setups).
- [x] Huddle recording exports compiled and uploaded directly to MinIO bucket.
- [x] Automated AI Meeting Summary, Insight extraction, and Key Points log.
- [x] OpenSearch indexing for global transcript and outcomes discovery.

---

## 🛠 Getting Started

### Prerequisites
* **Node.js**: v18 or higher
* **Flutter SDK**: v3.x
* **PostgreSQL**: v14+
* **Redis**: v6+
* **MinIO**: Running instance
* **LiveKit Server**: Running instance or Cloud Sandbox
* **OpenSearch**: Running instance

---

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install npm dependencies:
   ```bash
   npm install
   ```

3. Set up your environment variables:
   Create a `.env` file in the `backend` directory based on your infrastructure values:
   ```env
   DATABASE_URL="postgresql://postgres:postgres@localhost:5432/teamos?schema=public"
   REDIS_HOST="localhost"
   REDIS_PORT=6379
   JWT_ACCESS_SECRET="your-jwt-access-secret"
   JWT_REFRESH_SECRET="your-jwt-refresh-secret"
   MINIO_ENDPOINT="localhost"
   MINIO_PORT=9000
   MINIO_ACCESS_KEY="minioadmin"
   MINIO_SECRET_KEY="minioadmin"
   LIVEKIT_API_KEY="devkey"
   LIVEKIT_API_SECRET="secret"
   LIVEKIT_API_URL="http://localhost:7880"
   OPENAI_API_KEY="sk-..."
   OPENSEARCH_NODE="http://localhost:9200"
   ```

4. Run Prisma database migrations to apply the schema:
   ```bash
   npx prisma migrate dev
   ```

5. Seed initial data or start the server in watch mode:
   ```bash
   npm run start:dev
   ```

6. To verify unit tests:
   ```bash
   npm run test
   ```

---

### Frontend Setup

1. Navigate to the Flutter app directory:
   ```bash
   cd TeamOS-app
   ```

2. Fetch Dart dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Freezed/JSON serialization models:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run static analysis to verify code safety:
   ```bash
   flutter analyze
   ```

5. Run the application:
   ```bash
   flutter run -d <device_name>
   ```

---

## 🧪 Testing and Verification

* **Backend Tests**: Verified using Jest frameworks mock injections:
  ```bash
  npm run test
  ```
* **Frontend Analysis**: Validated compiler correctness with zero errors:
  ```bash
  flutter analyze
  ```
