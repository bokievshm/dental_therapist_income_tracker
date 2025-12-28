# FinMolar 🦷💰

A specialized income tracking and practice management application designed specifically for dental therapists working across multiple practices in the UK.

## Overview

FinMolar solves a real problem faced by dental therapists: managing income from multiple sources (NHS UDAs, hygiene services, private work) across different practices with varying contractual agreements. It replaces scattered spreadsheets with a centralized, intelligent system that automates calculations, tracks targets, and even uses AI to detect anomalies in income patterns.

**Built by a dental professional, for dental professionals.**

## Key Features

### 📊 Smart Dashboard
- Real-time income overview across all practices
- Breakdown by service type (UDAs, Hygiene, Private)
- Production vs. collection tracking
- Target progress visualization

### 💷 Intelligent Income Logging
- Support for all UDA bands (Band 1, 2, 3, Urgent, etc.)
- Automatic income calculation based on customizable fee settings
- "Awaiting Completion" tracking for incomplete UDA courses
- **AI-powered anomaly detection** — flags entries that deviate significantly from historical patterns

### 🏥 Multi-Practice Management
- Track work across unlimited practices
- Support for NHS, Private, and Mixed practice types
- Practice-specific activity history and filtering
- Individual UDA targets per practice

### 🎯 Financial Target Setting
- Custom targets (monthly, quarterly, yearly, or custom periods)
- Filter by practice and/or service type
- Visual progress tracking
- Deadline reminders

### 🧾 Invoice Generation
- Filter by date range, practice, and service type
- Professional invoice layout with GDC number
- Handle "Awaiting UDA Completions" → final band conversion
- Export to CSV
- Print/Save as PDF

### 🔔 Notification System
- Income logging confirmations
- Target deadline reminders
- Anomaly alerts
- Month-end UDA completion reminders

## Tech Stack

- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript
- **UI Components:** ShadCN UI + Radix UI primitives
- **Styling:** Tailwind CSS
- **AI Integration:** Google Genkit for anomaly detection
- **State Management:** React hooks + localStorage (prototype)
- **Date Handling:** date-fns
- **Icons:** Lucide React

## AI-Powered Features

The application integrates Google AI via Genkit to provide intelligent income anomaly detection. When logging income, the system compares entries against historical averages for that practice and service type, alerting users to potential errors or unusual patterns that may warrant review.

```typescript
// Example: AI analyzes if logged income deviates from expected patterns
const anomalyResult = await detectIncomeAnomaly({
  practiceId,
  serviceType,
  loggedAmount,
  historicalAverage
});
```

## Domain-Specific Logic

### UDA Band System
The app implements the full NHS UDA banding structure:
- Band 1 (1 UDA) — Examination, diagnosis, preventive advice
- Band 2 (3 UDAs) — Fillings, extractions, root canal treatment
- Band 3 (12 UDAs) — Crowns, bridges, dentures
- Urgent (1.2 UDAs) — Emergency treatment
- Plus handling for incomplete courses awaiting band assignment

### Income Calculation
- **UDAs:** Count × Fee per UDA (user-configurable)
- **Hygiene:** Sessions × Fee per session
- **Private:** Gross fee × Income percentage (typically 40-50%)

## Screenshots

*[Dashboard, Income Logging, and Invoice screens would go here]*

## Roadmap

- [ ] Firebase backend integration for persistent storage
- [ ] User authentication system
- [ ] Stripe integration for subscription tiers
- [ ] Push notifications (FCM)
- [ ] Email notifications and reports
- [ ] Practice performance analytics
- [ ] Tax year reporting for self-assessment

## Why I Built This

As a dental therapist working across multiple UK practices, I experienced firsthand the challenges of tracking income from different sources — NHS UDAs with their band system, private work percentages, hygiene sessions — all with different rates at different practices. Existing solutions were either too generic (spreadsheets) or designed for practice owners rather than associate clinicians.

FinMolar is built with deep understanding of how dental therapists actually work and get paid in the UK system.

## Local Development

```bash
# Clone the repository
git clone https://github.com/bokievshm/dental_therapist_income_tracker.git

# Install dependencies
npm install

# Run development server
npm run dev

# Open http://localhost:3000
```

## License

MIT License — see LICENSE file for details.

## Author

**Dr Alexander B]**  
Dental Therapist | Digital Health Developer  
GDC Registered | MSc Maxillofacial Surgery

- GitHub: [@bokievshm](https://github.com/bokievshm)

---

*FinMolar is currently a working prototype. Contributions, feedback, and feature requests are welcome.*
