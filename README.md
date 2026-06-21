# TeamOS Enterprise Operating System

TeamOS is a production-grade, all-in-one collaboration, productivity, automation, and ERP platform. Synthesizing the capabilities of platforms like **Jira, Slack, Microsoft Teams, Confluence, Salesforce, ServiceNow, and SAP**, TeamOS coordinates agile project delivery, real-time messaging, video meetings, business intelligence, visual workflow automations, and enterprise resource planning.

---

## 🚀 Technology Stack

### Backend (NestJS Monolithic Modular)
* **Core Framework**: NestJS (TypeScript)
* **Database & ORM**: PostgreSQL with Prisma ORM
* **Realtime Server**: Socket.IO for WebSockets and workspace isolation
* **Distributed Queueing**: Redis with BullMQ (delayed jobs, email queues, search indexing, and background tasks)
* **Search Engine**: OpenSearch (full-text search across messages, tasks, and meeting artifacts)
* **Media & WebRTC Gateway**: LiveKit Server SDK (SFU WebRTC)
* **Object Storage**: MinIO (AWS S3-compatible cloud storage for meeting recordings and attachments)

### Frontend (Flutter Cross-Platform)
* **Framework**: Flutter 3.x (Dart)
* **State Management**: Riverpod & Flutter Hooks
* **Routing**: GoRouter
* **Data Serialization**: Freezed & JSON Serializable
* **UI**: Custom premium responsive slate-blue UI, fully optimized for macOS, Windows, Web, and Mobile.

---

## 🗂 Project Structure

```
TeamOS/
├── README.md                          # Main project guide
├── backend/                           # NestJS Monolithic Backend
│   ├── prisma/
│   │   ├── schema.prisma              # PostgreSQL database models (26+ ERP & core entities)
│   │   └── seed.ts                    # Relational UAT demo data seeder script
│   ├── src/
│   │   ├── app.module.ts              # Root application module registering all 40+ modules
│   │   ├── main.ts                    # Server entrypoint with security filters, CORS & loggers
│   │   ├── common/                    # Guards (SSO, IP allowlist, RBAC), decorators & interceptors
│   │   └── modules/                   # Monolithic business modules
│   │       ├── auth/                  # JWT, Refresh Tokens, OAuth (Google/Microsoft)
│   │       ├── hrms/                  # Employee directory, leaves, attendance clocks, payroll runs
│   │       ├── crm/                   # Sales leads pipeline, accounts, deals & contacts
│   │       ├── procurement/           # Vendor management, purchase orders, requests & RFQs
│   │       ├── inventory/             # Multi-warehouse stock tracking and adjustments
│   │       ├── finance/               # Expense approvals, invoices, budgets, and policy checks
│   │       ├── helpdesk/              # Ticket queue, technician allocation, and SLAs
│   │       ├── workflow/              # Visual trigger-condition-action automation engine
│   │       ├── data-warehouse/        # WarehouseProcessor background database aggregator
│   │       └── security/              # Session management, DLP policies, and compliance centers
│   └── test/                          # 58 Jest unit & integration spec testing suites
└── TeamOS-app/                        # Flutter Mobile & Desktop App
    ├── pubspec.yaml                   # Dart dependencies configuration
    └── lib/
        ├── main.dart                  # App runner
        ├── routes/
        │   └── app_router.dart        # Route map definitions (routing for all 100+ screens)
        └── features/                  # Feature-first architectures
            ├── auth/                  # Register/Login UI flows
            ├── erp/                   # HRMS, CRM, Procurement, Inventory, Assets, Finance, Helpdesk
            ├── automation/            # Visual workflow builders, forms and approvals
            ├── bi/                    # OKRs, KPI builders, portfolio health, executive dashboards
            ├── desktop/               # Command palette, integrations, offline sync
            └── meetings/              # Active huddle frames, scheduler, breakout rooms
```

---

## ✨ Features Checklist

### 1. Authentication & Tenant Switcher (Phase 1-4)
- [x] JWT Authentication, Refresh Token Rotation, and login audit logs.
- [x] Multi-tenant workspace isolation.
- [x] Role-Based Access Control (RBAC) (Owner, Admin, Manager, Developer, QA, Guest).

### 2. Task Tracking & Agile Engine (Phase 5-7)
- [x] Epic ➔ Story ➔ Task / Bug ➔ Subtask hierarchy.
- [x] O(1) Kanban board positioning with float-based layout ordering.
- [x] Custom fields (Number, Date, URL, Select) and templates.

### 3. Realtime Slack-style Chat (Phase 8)
- [x] Channels, direct messages, and threaded discussions.
- [x] Typing indicators, read receipts, emoji reactions, and pins.

### 4. High-Fidelity Meetings & Huddles (Phase 9)
- [x] LiveKit SFU WebRTC meeting rooms with host moderator tools.
- [x] Waiting rooms, breakout rooms, and huddle recording exports.
- [x] AI-driven meeting summarizer, transcripts, and action item logs.

### 5. Collaborative Documents Platform (Phase 10)
- [x] Real-time editing, formatting, and file attachments.
- [x] Hierarchy directories, wiki collections, and version history.

### 6. AI Workspace & Copilot (Phase 11)
- [x] Chat assistants, prompt registries, and workflow generator.
- [x] OpenSearch semantic search across documents, meetings, and tasks.

### 7. Desktop Client Optimizations (Phase 12)
- [x] Command palette shortcuts, system tray, and local offline cache sync.

### 8. SaaS Billing & Subscriptions (Phase 13)
- [x] Stripe subscription management, plans checkout, usage metering.

### 9. Integrations Platform & Marketplace (Phase 14)
- [x] GitHub, Slack, Google Calendar webhooks and marketplace templates.

### 10. Enterprise Security & Compliance (Phase 15)
- [x] SAML 2.0 / SSO providers, SCIM provisioning, and session timeouts.
- [x] IP Allowlist middlewares and Legal Holds.
- [x] Data Retention rules, DLP pattern scans, and incident registry.

### 11. BI, Data Warehouses & Analytics (Phase 16)
- [x] Portfolio/Program management dashboard and resource planning.
- [x] OKRs dashboard, KPI builders, and forecasting engine.
- [x] Data Warehouse background processor (`WarehouseProcessor`).

### 12. Visual Workflow Automation (Phase 17)
- [x] Event-driven workflow execution engine and rules evaluator.
- [x] Dynamic Forms builder, submissions registry, and approval chains.
- [x] SLA configurations with target resolution hours.

### 13. Enterprise ERP Platform (Phase 18)
- [x] **HRMS**: Directory, clock attendance, leaves planner, recruitment, payroll preparation.
- [x] **CRM**: Sales pipeline, opportunities forecasting, accounts, contacts.
- [x] **Procurement**: Vendors directory, purchase requests, orders, RFQs.
- [x] **Inventory**: Multi-warehouse stock tracking and adjusters.
- [x] **Assets**: Physical assets registry and maintenance scheduling.
- [x] **Finance**: Expense policies (rules > 5000), invoices, budget allocations.
- [x] **Helpdesk**: Ticket queue management and SLA trackers.

### 14. Platform Stabilization & Integration (Phase 18.5)
- [x] Fully relational mock data database seeder.
- [x] Global Exception Filters, CORS, request loggers, and Security Headers.
- [x] Native macOS build config and launch success.

---

## 🛠 Getting Started

### Prerequisites
* **Node.js**: v18+
* **Flutter SDK**: v3.x
* **PostgreSQL**: v14+
* **Redis**: v6+
* **LiveKit Server / OpenSearch / MinIO**

### Backend Setup
1. Install npm dependencies:
   ```bash
   cd backend && npm install
   ```
2. Generate Prisma Client:
   ```bash
   npx prisma generate
   ```
3. Run the Relational Database Seeder:
   ```bash
   npx prisma db seed
   ```
4. Run Jest Test Suites (58 suites, 165 tests):
   ```bash
   npm run test
   ```
5. Start development server:
   ```bash
   npm run start:dev
   ```

### Frontend Setup
1. Fetch packages:
   ```bash
   cd TeamOS-app && flutter pub get
   ```
2. Add macOS platform desktop runner files:
   ```bash
   flutter create --platforms=macos .
   ```
3. Build release executable:
   ```bash
   flutter build macos
   ```
4. Run Flutter client:
   ```bash
   flutter run -d macos
   ```
