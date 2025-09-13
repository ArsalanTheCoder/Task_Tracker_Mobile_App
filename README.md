# 🚀 Task Tracker Mobile App - ICZ

> Full-fledged Flutter Task Tracker with **beautiful Firebase authentication**, **splash screen**, and **dual panels** (User & Admin).  
> Users submit daily tasks and monitor progress with interactive graphs; Admins review submissions and monitor team performance.

---

<!-- Badges (uncomment & replace if you want) -->
<!--
[![Flutter](https://img.shields.io/badge/Flutter-2.10-blue)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green)]()
-->

## ✨ Highlights
- 🔐 **Firebase Authentication** with polished registration & login flows + splash screen  
- 👥 **Two panels:**  
  - **User Panel:** Submit daily tasks, view progress charts, track personal history  
  - **Admin Panel:** View today's submissions, full submission history, and employee performance analytics  
- 📝 **Task fields:** Name, Department, Date (auto-filled), Task Assigned, Today's Work Description, Status (Completed / In Progress / etc.), Rating (feedback), Issue  
- 📈 **Analytics:** Multiple graphs (Number of Tasks vs Date, Time Spent per Task vs Date, and more) for deep insights  
- ⚡ Clean UI, toast feedback, offline resilience (local caching where applicable)

---

## 📸 Screenshots / Demo
> Replace the `src` links with your uploaded images or GIFs (recommended sizes: 800×450 or width attribute < 800).

<p align="center">
  <img src="https://github.com/your-username/Task_Tracker_Mobile_App/raw/main/screenshots/splash_screen.png" width="320" alt="Splash Screen" />
  <img src="https://github.com/your-username/Task_Tracker_Mobile_App/raw/main/screenshots/login_screen.png" width="320" alt="Login Screen" />
</p>

<p align="center">
  <img src="https://github.com/your-username/Task_Tracker_Mobile_App/raw/main/screenshots/user_dashboard.png" width="320" alt="User Dashboard" />
  <img src="https://github.com/your-username/Task_Tracker_Mobile_App/raw/main/screenshots/admin_dashboard.png" width="320" alt="Admin Dashboard" />
</p>

<p align="center">
  <img src="https://github.com/your-username/Task_Tracker_Mobile_App/raw/main/screenshots/graph_tasks_vs_date.png" width="480" alt="Tasks vs Date Graph" />
</p>

> Tip: use GIFs for short flows (login → submit task → graph update). Put them in `/screenshots` or `/assets` and reference with `raw` links.

---

## 🛠️ Tech Stack
- **Flutter** (Dart)  
- **Firebase**: Authentication, Cloud Firestore (or Realtime DB), (optional) Cloud Functions, Storage  
- **State Management:** Provider / Riverpod / Bloc (update based on your implementation)  
- **Charts:** `fl_chart` or similar (for Time series & bar charts)  
- **Local storage (optional):** Hive / SharedPreferences for caching

---

## 🔎 Data Model (example)
> Use this as a reference for your Firestore documents.

**Collection:** `tasks`  
Document fields:
```json
{
  "userId": "uid_abc123",
  "name": "Muhammad Arsalan",
  "department": "Sales",
  "date": "2025-09-14T08:00:00Z",
  "taskAssigned": "Follow up with client",
  "workDescription": "Called client, updated proposal",
  "status": "completed",            // completed | inprogress | pending
  "rating": 4,                      // integer or float
  "issue": "None",
  "timeSpentMinutes": 45,
  "createdAt": "<Firestore Timestamp>"
}
