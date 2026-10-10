# 🧠 Eldoria Staff App — Project Brain (BRAIN.md)

> **Repository Scope**: This project is exclusively the **Eldoria Staff Mobile Application** (`eldoriaCare`). It is engineered specifically for in-field healthcare professionals — **Registered Nurses (GNM/ANM)**, **Trained Caregivers & Attendants**, and **Certified Physiotherapists** — delivering scheduled care visits and shifts to patients' homes.
>
> *(Client/Family booking and Admin Care Desk operations are external counterpart services).*

---

## 1. Executive Product Vision & Purpose

### 1.1 Overview
The **Eldoria Staff App** is the digital workplace for Eldoria's clinical and caregiving workforce. It empowers care professionals to manage their availability, review and accept booking requests in their city, navigate to patient residences, execute standardized clinical protocols, record patient vitals in real time, and submit visit handover summaries for patient families.

### 1.2 Core Target Users
1. **Registered Nurses (GNM / ANM)**: Administer clinical procedures (IV/IM injections, wound dressing, catheter/Ryles tube care, vital monitoring, post-op recovery, and home ICU support).
2. **Caregivers & Patient Attendants**: Provide daily living support (bathing, personal hygiene, feeding, mobility assistance, repositioning bedridden patients, companionship).
3. **Certified Physiotherapists**: Conduct physical rehabilitation, range-of-motion therapy, stroke rehab, and post-surgery mobility sessions.

### 1.3 Key Value Pillars for Staff
- **Complete Shift Control**: Instant **On-Duty / Off-Duty** toggle. Work when available.
- **Local City Feed**: Receive open requests filtered strictly to the staff member's registered city and locality.
- **Guided Clinical Execution**: Step-by-step care task checklists tailored to the specific booking service.
- **Transparent Communication**: 1-tap phone calls, WhatsApp messages to family, and Google Maps GPS navigation.
- **Digital Handover & Vitals**: Real-time recording of Blood Pressure, Blood Sugar, SpO₂, and visit observations.

---

## 2. Core Architectural Blueprint

The application is architected using **Flutter 3+** with **GetX** for predictable reactive state management and **Dio** for robust networking.

```
┌─────────────────────────────────────────────────────────────────┐
│                       Presentation Layer                        │
│  - Views: GetView<T> & Obx Reactive Widgets                     │
│  - Responsive Geometry: SizeConfig (.w, .h, .sp)                │
│  - Standard Component Atoms: MyAppBar, MyButton, MyTextField    │
└────────────────────────────────┬────────────────────────────────┘
                                 │
┌────────────────────────────────▼────────────────────────────────┐
│                   Controller & State Layer                      │
│  - StaffDashboardController (Duty toggle, tab switching)        │
│  - VisitsController (Today, Upcoming, Overdue, Completed)       │
│  - RequestsController (City open feed, claim/assign visits)     │
│  - VisitExecutionController (Transit, Check-in, Vitals, Done)   │
│  - StaffOnboardingController (4-step application wizard)        │
│  - StaffProfileController (Credentials, verified badge, auth)   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
┌────────────────────────────────▼────────────────────────────────┐
│                    Data & Repository Layer                      │
│  - Repository.instance (Singleton API Client)                   │
│  - Dio 5.9 + PrettyDioLogger Interceptors                       │
│  - Preference (SharedPreferences staff session & duty state)    │
│  - Local Models: StaffUser, StaffVisit, CareTask, VitalsLog     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Staff App Feature & Screen Specifications

Based directly on the prototype benchmark ([project-ui-files/Staff-app.html](file:///Users/ajayrawat/StudioProjects/Eldoria-Care/project-ui-files/Staff-app.html)):

```
                                  ┌───────────────────────────┐
                                  │       Splash Screen       │
                                  └─────────────┬─────────────┘
                                                │
                                    Is Logged In & Approved?
                                   ┌────────────┴────────────┐
                                   ▼ NO                      ▼ YES
                      ┌──────────────────────┐    ┌──────────────────────────┐
                      │  Staff Login / Phone │    │  Staff Dashboard Frame   │
                      └──────────┬───────────┘    │  - On/Off Duty Switch    │
                                 │                │  - Today/Upcoming Stats  │
                   ┌─────────────┴────────────┐   └────────────┬─────────────┘
                   ▼                          ▼                │
         ┌──────────────────┐       ┌──────────────────┐       │ 4 Core Tabs
         │ Join as Staff    │       │ Track Application│       ├──────────────┬──────────────┬──────────────┐
         │ (4-step Onboard) │       │ (Status & Notes) │       ▼              ▼              ▼              ▼
         └──────────────────┘       └──────────────────┘   ┌─────────┐   ┌──────────┐   ┌─────────┐   ┌─────────┐
                                                           │ Visits  │   │ Requests │   │ Alerts  │   │ Profile │
                                                           │ (My     │   │ (Open    │   │ (Notifi-│   │ (Badge, │
                                                           │ Visits) │   │ Feed)    │   │ cations)│   │ Logout) │
                                                           └────┬────┘   └────┬─────┘   └─────────┘   └─────────┘
                                                                │             │
                                                                ▼             ▼
                                                      ┌───────────────────────────────────┐
                                                      │  Active Visit Execution Screen    │
                                                      │  - "On the way" transit trigger   │
                                                      │  - Patient Home Check-in          │
                                                      │  - Clinical Tasks Checklist       │
                                                      │  - Vitals Logger (BP, Sugar, SpO₂)│
                                                      │  - Visit Notes & Complete Shift   │
                                                      └───────────────────────────────────┘
```

---

### 3.1 Authentication & Onboarding Module

#### A. Staff Login & Quick Switch (`/login`)
- Phone number input with 6-digit OTP verification.
- Tester/Demo account quick-selector for rapid field verification during testing.
- Checks staff account approval status:
  - If `approved`: routes directly to Dashboard (`AppRoutes.dashboard`).
  - If `pending` or `changes`: routes to Track Application.
  - If new user: prompts "Join as Staff".

#### B. "Join as Staff" 4-Step Registration Wizard (`/onboarding/apply`)
1. **Step 1: Personal & Contact Details**:
   - Full Name, Mobile Number, Email Address.
   - Date of Birth, Gender (Male / Female / Other).
   - Operating City (dropdown of supported cities) & Local Area/Neighborhood.
   - Residential Address.
   - Emergency Contact (Name, Phone, Relationship).
2. **Step 2: Role & Professional Qualifications**:
   - Primary Role Selection chips:
     - `Registered Nurse (GNM)`
     - `Registered Nurse (ANM)`
     - `Trained Caregiver`
     - `Patient Attendant`
     - `Physiotherapist`
   - Nursing / Medical Council Registration Number (for clinical roles).
   - Highest Medical / Healthcare Qualification.
   - Total Years of Experience.
   - Clinical Skills checklist (e.g. *Vitals, IV/IM Injection, Catheter Care, Wound Care, Suction, Elder Hygiene, Post-Op Care, Physio*).
   - Languages spoken (Hindi, English, Marathi, Bengali, Tamil, etc.).
   - Preferred Availability (`12-hr Day`, `12-hr Night`, `24-hr Live-in`, `Single Visits`).
3. **Step 3: Document Uploads**:
   - Profile Photo (camera / gallery image with thumbnail preview).
   - Government Photo ID (Aadhaar / PAN / Voter ID - JPG/PNG/PDF).
   - Qualification / Nursing Degree Certificate.
   - Registration Council Certificate.
4. **Step 4: Review, Consent & Submission**:
   - Review summarized application data.
   - Mandatory Consent Checkbox: *"I confirm these details and documents are true, and I agree to identity and background verification by Eldoria Care at Home."*
   - Submission triggers status `pending` and provides immediate Application Tracking ID.

#### C. Track Application Status (`/onboarding/track`)
- Displays real-time status pill:
  - 🟡 **Pending Review**: *"Your application is under review by the Eldoria Care Desk. Background check in progress."*
  - 🟠 **Changes Requested**: *"The Care Desk requested updates to your documents/information."* Includes admin notes and an **"Edit & Resubmit"** button.
  - 🟢 **Approved**: *"Congratulations! Your credentials have been verified."* Shows **"Sign in to Staff App"** CTA button.
  - 🔴 **Rejected**: Explanatory reason with an option to appeal or reapply.

---

### 3.2 Staff Dashboard Frame & Navigation

#### Persistent Header:
- Staff Avatar with duty indicator halo (pulsing green when On Duty).
- Staff Name, Role badge (e.g. `Nurse (GNM)`), and Operating City.
- **On Duty / Off Duty Toggle Switch**:
  - Live reactive toggle.
  - When **On Duty**: Eligible for automatic visit dispatches and city booking alerts.
  - When **Off Duty**: Mutes instant dispatches; displays resting banner.
- **Quick Metric Counters**:
  - `Today`: Number of visits scheduled for the current date.
  - `Upcoming`: Confirmed future visits.
  - `Completed`: Lifetime completed visits count.

#### 4 Bottom Navigation Tabs:
1. `Visits` (`Icons.list_alt_rounded`): Assigned personal visits.
2. `Requests` (`Icons.calendar_month_rounded`): Open city request feed (with unread badge counter).
3. `Alerts` (`Icons.notifications_outlined`): Notification feed with unread dot.
4. `Profile` (`Icons.person_outline_rounded`): Credentials, verification status, settings.

---

### 3.3 Tab 1: My Visits (`/visits`)

The primary daily workflow screen. Grouped into structured chronological buckets:

1. **Overdue / Action Needed**: Visits that have passed their start time but have not been clocked in.
2. **Today's Visits**: Sorted by scheduled time slot (`07:00 AM`, `09:00 AM`, etc.).
3. **Upcoming Visits**: Tomorrow and future confirmed bookings.
4. **Recently Completed**: Last 5 completed visits with checkout timestamps.

#### Visit Card Elements:
- Scheduled Date & Time Slot (e.g. *Today · 9:00 AM*).
- Live Status Pill (`assigned`, `on_the_way`, `in_progress`, `completed`).
- Patient Name & Age (e.g. *Savitri Sharma, 74 yrs*).
- Service Name & Plan (e.g. *Home Nursing · 12-hr day shift*).
- Full Location Address with Pin icon.
- Focus Indicator: Active visits (`on_the_way` or `in_progress`) display an accent border.

---

### 3.4 Tab 2: Open Requests Feed (`/requests`)

Displays open booking requests in the staff member's registered city waiting to be claimed or allocated.

#### Screen Details:
- City indicator banner: *"Open requests in Mumbai. Confirm, take the visit yourself or assign a colleague."*
- Card Information:
  - Patient condition & relation (e.g. *Mother, 78 yrs*).
  - Requested service & shift plan (e.g. *Elderly Caregiver · 24-hr live-in*).
  - Area / Locality & scheduled start date.
  - Special family notes (e.g. *"Bedridden, needs assistance with sponge bath and medication"*).
- **Staff Action Buttons**:
  1. **"Confirm & assign to me"**: Immediately claims the visit, moving it to the staff member's `Visits` tab.
  2. **"Assign to colleague"**: Opens a list of fellow on-duty staff members in the same city to delegate the booking.
  3. **"Confirm only"**: Acknowledges the booking for the family while letting the central Care Desk assign staff later.

#### Real-time Request Pop-up Dialog:
- When a new booking drops in the city, an assertive floating dialog appears:
  - Pulse bell icon, patient info, time, and locality.
  - Quick action: **"View Request"** or **"Later"**.

---

### 3.5 Tab 3: Alerts & Notifications (`/alerts`)

- List of high-priority operational notifications:
  - New visit assigned by Care Desk.
  - Visit schedule or time slot updated by family.
  - Booking cancelled alert.
  - Document verification status updates.
- Interactive: Tapping an alert navigates directly to the relevant visit or application screen.
- "Mark all as read" action button.

---

### 3.6 Tab 4: Staff Profile (`/profile`)

- Profile Header with initials avatar, full name, and professional role.
- **Verification Status Badge**:
  - `Verified` (Green shield with checkmark) or `Pending Verification`.
- Summary Details List:
  - Registered Mobile Number (`+91 XXXXX XXXXX`).
  - Assigned City and Operating Locality.
  - Registration Council License Number.
  - Qualifications and Verified Skills list.
- **Sign Out** button (clears local session and navigates to login).

---

### 3.7 Active Visit Execution Screen (`/visit-execution`)

The critical operational screen for executing in-home care protocols.

```
┌─────────────────────────────────────────────────────────────┐
│  ← Back    Patient: Savitri Sharma, 74 yrs                  │
│            Home Nursing · Today, 9:00 AM                    │
├─────────────────────────────────────────────────────────────┤
│  [ Visit in Progress ]                          BK-88219    │
│                                                             │
│  ┌─ Family Care Notes ────────────────────────────────────┐ │
│  │ "Patient is recovering from knee surgery. Please check │ │
│  │  blood sugar before breakfast. Medicine in kitchen."   │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│  📍 402 Palm Heights, Andheri West, Mumbai                  │
│  ┌───────────────┐ ┌─────────────────┐ ┌─────────────────┐  │
│  │ 📞 Call Family │ │ 💬 WhatsApp   │ │ 🗺️ Google Maps   │  │
│  └───────────────┘ └─────────────────┘ └─────────────────┘  │
│                                                             │
│  ┌─ Clinical Care Tasks ──────────────────────────────────┐ │
│  │ [x] Check BP, pulse & SpO₂                             │ │
│  │ [x] Check fasting blood sugar                          │ │
│  │ [ ] Give morning prescribed medication                 │ │
│  │ [ ] Assisted walk & knee mobility exercises            │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌─ Vitals Recorded ──────────────────────────────────────┐ │
│  │  BP (mmHg)        Sugar (mg/dL)       SpO₂ (%)         │ │
│  │  [ 124/82   ]     [ 118       ]       [ 98     ]       │ │
│  │                                                        │ │
│  │  Handover Notes for Family                             │ │
│  │  [ Patient was cheerful, walked 10 mins with walker. ] │ │
│  └────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  [  COMPLETE VISIT & CHECK OUT                           ]  │
└─────────────────────────────────────────────────────────────┘
```

#### Step-by-Step State Transitions:
1. **State: `assigned` / `confirmed`**:
   - Staff is at home or transit base.
   - Primary Action Button: **"Start trip · notify family"** ➔ Transitions to `on_the_way`. Family receives arrival alert.
2. **State: `on_the_way`**:
   - Staff is traveling.
   - 1-tap **Google Maps Navigation** launches GPS directions to patient residence.
   - 1-tap **Phone Call** or **WhatsApp** to coordinate entry / gate pass with family.
   - Primary Action Button: **"Check in at patient's home"** ➔ Transitions to `in_progress` and records precise `checkInAt` timestamp.
3. **State: `in_progress`**:
   - Displays green indicator: *"Checked in at 9:04 AM"*.
   - **Interactive Clinical Tasks Checklist**:
     - Dynamically populated based on service type (e.g. *Vitals, Wound dressing, Tube feeding, Bed-sore check, Assisted walk*).
     - Staff taps checkboxes as tasks are executed.
   - **Vitals & Handover Notes Input Form**:
     - `BP (mmHg)` (e.g. `120/80`)
     - `Blood Sugar (mg/dL)` (e.g. `112`)
     - `SpO₂ (%)` (e.g. `98`)
     - `Visit Notes for Family` (Text field: Patient condition, appetite, exercises done, instructions).
   - Primary Action Button: **"Complete visit & check out"** ➔ Validates inputs, saves vitals, records `checkOutAt` timestamp, transitions booking to `completed`.
4. **State: `completed`**:
   - Read-only historical summary.
   - Displays completion timestamp (e.g. *"Completed Today, 5:12 PM"*).
   - Locks checklists and shows recorded vitals for audit.

---

## 4. Domain Data Models (Staff Specific)

The data models required in `lib/model/` for the Staff App:

### 4.1 Staff User Model (`StaffUser`)
```dart
class StaffUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role;             // 'nurse_gnm', 'nurse_anm', 'caregiver', 'physio'
  final String city;             // 'mumbai', 'pune', 'delhi', etc.
  final String area;             // Local neighborhood / sector
  final String address;
  final String qualification;
  final String? regNo;           // Council License / Registration No.
  final int experienceYears;
  final List<String> skills;     // ['vitals', 'wound_care', 'catheter', 'hygiene']
  final List<String> languages;  // ['Hindi', 'English', 'Marathi']
  final bool onDuty;             // true = available for visits
  final String approvalStatus;   // 'pending', 'approved', 'changes', 'rejected'
  final String? rejectionReason;
  final String? photoUrl;
  final Map<String, String>? documents; // {'id_proof': 'url', 'degree': 'url'}
}
```

### 4.2 Staff Visit Model (`StaffVisit`)
```dart
class StaffVisit {
  final String id;
  final String code;             // e.g. "ELD-7421"
  final String serviceId;        // 'nursing', 'caregiver', 'physio', etc.
  final String serviceName;      // "Home Nursing"
  final String plan;             // "12-hr day shift", "Single visit"
  final String status;           // 'assigned', 'on_the_way', 'in_progress', 'completed'
  final String date;             // "2026-10-06"
  final String time;             // "9:00 AM"
  final String patientName;
  final String? patientAge;
  final String address;
  final String city;
  final String clientName;       // Family member name
  final String clientPhone;      // Phone number for call / WhatsApp
  final String? familyNotes;     // Special instructions from family
  final List<CareTask> tasks;    // Clinical protocol checklist
  final VitalsLog? vitals;       // BP, Sugar, SpO2 readings
  final int? checkInAt;          // Epoch milliseconds
  final int? checkOutAt;         // Epoch milliseconds
}
```

### 4.3 Care Task Model (`CareTask`)
```dart
class CareTask {
  final String id;
  final String label;            // "Check BP & SpO2", "Assisted walk"
  bool isDone;
}
```

### 4.4 Vitals Log Model (`VitalsLog`)
```dart
class VitalsLog {
  final String? bp;              // "120/80"
  final String? sugar;           // "110"
  final String? spo2;            // "98"
  final String? notes;           // "Patient did well with knee exercise..."
}
```

---

## 5. Directory Inventory & Codebase Mapping

```
Eldoria-Care/
├── assets/
│   ├── icons/                 # Brand logos (horizontal_logo.png), SVG action icons
│   └── json/                  # Lottie animations & offline configs
├── project-ui-files/
│   └── Staff-app.html         # Pure Staff Application Prototype (Target reference)
├── lib/
│   ├── main.dart              # App initialization, GetMaterialApp, theme injection
│   ├── data_handler/
│   │   ├── api_keys.dart      # Base endpoints for staff auth, visits, requests
│   │   ├── api_provider.dart  # Dio HTTP client, token authorization, error handling
│   │   └── repository.dart    # Central Repository singleton for staff network calls
│   ├── dialogs/
│   │   └── alert_dialog.dart  # Fluent MyAlertDialog
│   ├── model/
│   │   ├── staff_user.dart    # Staff professional profile & approval models
│   │   ├── staff_visit.dart   # Visit item, booking lifecycle & checklist models
│   │   └── vitals_log.dart    # Vitals readings (BP, Sugar, SpO2) and visit notes
│   ├── routes/
│   │   └── app_routes.dart    # Staff routes: login, onboard, dashboard, visit-detail
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login/         # StaffLoginScreen & StaffLoginController
│   │   │   └── onboarding/    # StaffOnboardingWizard (4 steps) & TrackApplication
│   │   ├── dashboard/         # StaffDashboard, DutyHeader, BottomNavBar
│   │   ├── visits/            # VisitsListScreen (Today, Upcoming, Completed)
│   │   ├── requests/          # OpenRequestsFeedScreen & ClaimVisitDialog
│   │   ├── visit_execution/   # ActiveVisitScreen (Transit, Check-in, Tasks, Vitals)
│   │   ├── alerts/            # StaffNotificationsScreen
│   │   ├── profile/           # StaffProfileScreen (Credentials, Verified Badge)
│   │   └── splash/            # SplashScreen (Session token & duty check)
│   ├── theme/
│   │   ├── app_theme.dart     # Light & Dark theme definitions
│   │   └── theme_controller.dart # Reactive dark/light mode controller
│   ├── utils/
│   │   ├── const.dart         # Global constants, tester numbers, default cities
│   │   ├── data/en.dart       # English localization dictionary (690+ keys)
│   │   ├── helper.dart        # Responsive extensions (.w, .h, .sp, .t)
│   │   ├── logger.dart        # Console logger
│   │   ├── preference.dart    # SharedPreferences staff session & duty manager
│   │   └── toasty.dart        # Toast notifications
│   ├── values/
│   │   ├── size_config.dart   # Screen dimension utilities
│   │   └── theme_colors.dart  # Brand palette (Navy #0E2F5A, Accent Orange #F2A01F)
│   └── widget/
│       ├── app_bar.dart       # Reusable MyAppBar
│       ├── empty_widget.dart  # Empty visit / request illustration
│       ├── my_button.dart     # Animated button with loading states
│       ├── my_dropdown.dart   # City & qualification selector
│       └── text_field.dart    # Animated form inputs
```

---

## 6. Migration & Codebase Cleanup Plan

To transform the current template codebase strictly into the **Eldoria Staff App**, the following cleanup tasks are required:

1. **Clean Navigation in [bottom_nav_bar.dart](file:///Users/ajayrawat/StudioProjects/Eldoria-Care/lib/screens/dashboard/bottom_nav_bar.dart)**:
   - *Remove*: Obsolete job-portal labels (`Jobs`, `Resdex`, `Applies`).
   - *Add*: Staff tabs:
     - Index 0: **Visits** (`Icons.format_list_bulleted_rounded`)
     - Index 1: **Requests** (`Icons.calendar_month_rounded`)
     - Index 2: **Alerts** (`Icons.notifications_none_rounded`)
     - Index 3: **Profile** (`Icons.person_outline_rounded`)
2. **Refactor [dashboard.dart](file:///Users/ajayrawat/StudioProjects/Eldoria-Care/lib/screens/dashboard/dashboard.dart)**:
   - Add persistent top `DutyHeader` (Avatar, Name, Role, On-Duty switch, Metric counters).
   - Wire body switcher to the 4 staff screens.
3. **Replace [model/users.dart](file:///Users/ajayrawat/StudioProjects/Eldoria-Care/lib/model/users.dart)**:
   - Replace candidate/employer schema with `StaffUser`, `StaffVisit`, `CareTask`, and `VitalsLog`.
4. **Implement Screens**:
   - `VisitsListScreen`: Categorized lists for Today, Upcoming, Overdue, Completed.
   - `OpenRequestsScreen`: Open feed with "Confirm & Assign" dialogs.
   - `ActiveVisitScreen`: Check-in, task checklist, vitals input, Google Maps / WhatsApp launcher.
   - `StaffOnboardingWizard`: 4-step wizard for new staff signups.

---

## 7. Actionable Implementation Roadmap

### Phase 1: Staff Data Models & Session Store
- [ ] Create `lib/model/staff_user.dart` (staff profile, role, approval status, duty state).
- [ ] Create `lib/model/staff_visit.dart` (booking codes, patient data, clinical tasks, status).
- [ ] Create `lib/model/vitals_log.dart` (BP, blood sugar, SpO2, handover notes).
- [ ] Update [Preference](file:///Users/ajayrawat/StudioProjects/Eldoria-Care/lib/utils/preference.dart) with `setDuty(bool onDuty)` and `isDuty`.

### Phase 2: Staff Dashboard & Core Navigation
- [ ] Update [bottom_nav_bar.dart](file:///Users/ajayrawat/StudioProjects/Eldoria-Care/lib/screens/dashboard/bottom_nav_bar.dart) with the 4 staff navigation items.
- [ ] Build `DutyHeader` widget with reactive on-duty switch and metric counters (`Today`, `Upcoming`, `Completed`).
- [ ] Create `VisitsListScreen` with visit summary cards and category tabs.

### Phase 3: Active Visit Execution Flow
- [ ] Build `ActiveVisitScreen` with status-driven bottom action button:
  - `assigned` ➔ *"Start trip · notify family"*
  - `on_the_way` ➔ *"Check in at patient's home"*
  - `in_progress` ➔ *"Complete visit & check out"*
- [ ] Implement interactive `CareTasksChecklist` widget with checkboxes.
- [ ] Implement `VitalsInputCard` (BP, Sugar, SpO₂, Handover Notes).
- [ ] Add direct actions: Phone dialer ([url_launcher](https://pub.dev/packages/url_launcher)), WhatsApp API launcher, Google Maps navigation intent.

### Phase 4: Open Booking Requests Feed
- [ ] Build `OpenRequestsScreen` displaying unassigned city requests.
- [ ] Implement claim actions: *"Assign to me"*, *"Assign to colleague"*, *"Confirm only"*.
- [ ] Build incoming request floating dialog popup.

### Phase 5: Onboarding & Application Tracking
- [ ] Build 4-step `StaffOnboardingWizard` with photo/doc picking ([image_picker](https://pub.dev/packages/image_picker), [file_picker](https://pub.dev/packages/file_picker)).
- [ ] Build `TrackApplicationScreen` with live status stepper and edit-resubmit actions.
