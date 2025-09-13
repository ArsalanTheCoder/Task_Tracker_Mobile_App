# 🚀 Task Tracker Mobile App - ICZ

> Full-fledged Flutter Task Tracker with polished Firebase authentication, splash screen, and dual panels (User & Admin).  
> Users submit daily tasks and monitor progress with interactive graphs; Admins review submissions and monitor team performance.

---

## ✨ Key Highlights
- 🔐 Firebase Authentication (signup / login) + splash screen  
- 👥 Two panels: **User** (submit tasks, view personal analytics) and **Admin** (review submissions, monitor employees)  
- 📝 Task fields: Name, Department, Date (auto), Task Assigned, Work Description, Status, Rating, Issue, Time Spent  
- 📈 Analytics: Number of Tasks vs Date, Time Spent per Task vs Date, and more interactive graphs  
- ⚡ Clean UI, toast feedback, and smooth UX

---

## 📸 Screenshots & Explanations

<p align="center">
  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/e1df815f-0605-4b34-a093-05df13c4fc4f" width="320" alt="01 - Splash Screen"/>
    <figcaption align="center"><strong>01 • Splash Screen</strong><br/>Beautiful branded entry screen that runs while the app initializes and checks auth.</figcaption>
  </figure>

  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/895a37aa-08a4-4676-8dc4-93d939e36419" width="320" alt="02 - Sign In"/>
    <figcaption align="center"><strong>02 • Sign In</strong><br/>Clean login UI with email/password fields and validation feedback.</figcaption>
  </figure>

  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/d94e5339-071c-4db6-97d1-9d16299f4ae1" width="320" alt="03 - Sign Up"/>
    <figcaption align="center"><strong>03 • Sign Up</strong><br/>Simple registration screen—collects user info and assigns role (user/admin).</figcaption>
  </figure>

  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/628d60a7-9076-4fae-8050-b2bba4aa1ec2" width="320" alt="04 - User Dashboard & Graphs"/>
    <figcaption align="center"><strong>04 • User Dashboard</strong><br/>User view with summary cards and graphs showing progress over time.</figcaption>
  </figure>
</p>

<p align="center">
  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/2ebed09b-e178-44de-b03f-df759141ddae" width="320" alt="05 - User Panel Additional"/>
    <figcaption align="center"><strong>05 • User Panel (details)</strong><br/>Task list, add button, and quick access to submit today's task.</figcaption>
  </figure>

  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/15a85dfd-a4ae-47c3-9b61-799eee93b34d" width="320" alt="06 - Submission Status"/>
    <figcaption align="center"><strong>06 • Submissions Overview</strong><br/>Shows submitted vs. not-submitted tasks so users and admins can track compliance.</figcaption>
  </figure>

  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/3f17c885-e73b-474c-9d38-67f80959122a" width="320" alt="07 - Admin Panel"/>
    <figcaption align="center"><strong>07 • Admin Dashboard</strong><br/>Admin view: today's submissions, filters, and aggregated employee stats.</figcaption>
  </figure>

  <figure style="display:inline-block;margin:8px">
    <img src="https://github.com/user-attachments/assets/f3eb2d88-8f81-4082-a827-bd24a8a9f1de" width="320" alt="08 - Task Details"/>
    <figcaption align="center"><strong>08 • Task Details (Admin)</strong><br/>Full task specification: name, department, description, status, rating, issue, time spent.</figcaption>
  </figure>
</p>

> Tip: If you prefer fewer columns on mobile, reduce `width="320"` to `width="260"`.

---

## 🛠️ Tech Stack
- **Flutter** (Dart)  
- **Firebase**: Authentication + Cloud Firestore (storage of tasks & users)  
- **Charts**: `fl_chart` (or similar) for graphs  
- **State Management:** Provider / Riverpod / Bloc (based on your implementation)  
- **Local cache:** Optional (Hive / SharedPreferences)

---

## 🔎 Data Model (example)
**Collection:** `tasks` — sample document:
```json
{
  "userId": "uid_abc123",
  "name": "Muhammad Arsalan",
  "department": "Sales",
  "date": "2025-09-14T08:00:00Z",
  "taskAssigned": "Follow up with client",
  "workDescription": "Called client, updated proposal",
  "status": "completed",
  "rating": 4,
  "issue": "None",
  "timeSpentMinutes": 45,
  "createdAt": "<Firestore Timestamp>"
}
