# 🚀 Task Tracker Mobile App — ICZ

> Clean, focused README with the 8 app screenshots neatly aligned and each screenshot explained clearly.  
> Replace the image URLs below with your repo `raw` links if you host screenshots inside the repository.

---

## 🔎 Key Features — What this app does
A quick summary of the core capabilities so a reader sees the value immediately: users can sign up and submit daily tasks, visualize progress with rich charts, and admins can monitor team performance and task compliance in real time.

---

## ✨ Key Highlights

- 🔐  Firebase Authentication (signup / login) + splash screen.  

- 👥  Two panels: **User** (submit tasks, view personal analytics) and **Admin** (review submissions, monitor employees).  

- 📝  Task fields: **Name**, **Department**, **Date** (auto), **Task Assigned**, **Work Description**, **Status**, **Rating**, **Issue**, **Time Spent**.  

- 📈  Analytics: **Number of Tasks vs Date**, **Time Spent per Task vs Date**, and other interactive graphs for trend analysis.  

- ⚡  Clean UI, toast feedback, smooth UX, and responsive layouts for mobile devices.


## 📸 Screenshots — gallery & explanations

<table>
  <tr>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/e1df815f-0605-4b34-a093-05df13c4fc4f" alt="01 - Splash Screen" width="320"/><br>
      <strong>01 • Splash Screen</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        A welcoming gradient header and concise branding — this screen appears briefly while the app initializes and checks Firebase authentication. It sets the tone with rounded shapes and smooth visual hierarchy.
      </p>
    </td>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/895a37aa-08a4-4676-8dc4-93d939e36419" alt="02 - Sign In" width="320"/><br>
      <strong>02 • Sign In</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        Clean login form: email / password fields, visible primary CTA and link to sign up or recover password. Error and loading states are presented via subtle toasts and disabled buttons for clarity.
      </p>
    </td>
  </tr>

  <tr>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/d94e5339-071c-4db6-97d1-9d16299f4ae1" alt="03 - Sign Up" width="320"/><br>
      <strong>03 • Sign Up</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        Registration screen with required profile fields — name, department selector and password. Friendly UX (inline validation) helps users create accounts quickly and correctly.
      </p>
    </td>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/628d60a7-9076-4fae-8050-b2bba4aa1ec2" alt="04 - User Panel Dashboard (Graphs)" width="320"/><br>
      <strong>04 • User Panel — Dashboard</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        Personal analytics view: aggregated metrics and time-series charts (tasks vs date, time spent). Users instantly see performance trends and recent activities for the selected date range.
      </p>
    </td>
  </tr>

  <tr>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/2ebed09b-e178-44de-b03f-df759141ddae" alt="05 - User Panel (More)" width="320"/><br>
      <strong>05 • User Panel — Task Summary & Quick Actions</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        Another user view showing task cards and shortcuts — quick-add buttons, filters and a compact list of recent entries. Designed to make daily task submission fast and repeatable.
      </p>
    </td>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/15a85dfd-a4ae-47c3-9b61-799eee93b34d" alt="06 - Submitted / Not-submitted Tasks" width="320"/><br>
      <strong>06 • Tasks — Submitted / Not Submitted</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        Compact task list shows per-day submission status: avatar / name, brief description, date and a colored status pill (Completed / In Progress / Uncompleted) for instant scanning.
      </p>
    </td>
  </tr>

  <tr>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/3f17c885-e73b-474c-9d38-67f80959122a" alt="07 - Admin Panel Overview" width="320"/><br>
      <strong>07 • Admin Panel — Overview</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        High-level admin dashboard with totals, department breakdowns (pie chart) and average ratings (bar chart). Powerful filters let admins inspect teams, dates, and departments quickly.
      </p>
    </td>
    <td align="center" width="50%">
      <img src="https://github.com/user-attachments/assets/f3eb2d88-8f81-4082-a827-bd24a8a9f1de" alt="08 - Admin — Task Detail" width="320"/><br>
      <strong>08 • Admin — Task Detail</strong>
      <p style="text-align:left;margin:6px 12px 0 12px;">
        Detailed view of an individual task: full fields (name, department, date, task assigned, description, rating, issue and time spent). Admins can review, comment or escalate issues from here.
      </p>
    </td>
  </tr>
</table>

> ✅ **Notes:**  
> - The gallery above uses the provided image URLs. For best results on GitHub, host images in `./assets/screenshots/` and reference their **raw** links (e.g. `https://github.com/<user>/<repo>/raw/main/assets/screenshots/xxx.png`).  
> - Recommended image width for mobile-screenshots is `320` px; for landscape charts use `480`–`640` px.

---

## ✨ What these screens show (short summary)
- **Onboarding & Auth:** polished splash, quick sign-up and sign-in flows to get users into the app fast.  
- **User Experience:** easy daily task submission, clear status badges, and quick analytics to track personal productivity.  
- **Admin Experience:** aggregated metrics and per-employee drilldowns help managers monitor workload, quality (ratings) and unresolved issues.

---

## 🛠 Minimal Tech Snapshot
- **Flutter (Dart)** — UI & logic  
- **Firebase** — Authentication, Cloud Firestore (data), Storage (attachments)  
- **Charts** — `fl_chart` or equivalent for pie / bar / line visuals  
- **State management** — Provider / Riverpod / BLoC (choose per preference)

---

## ✅ Quick Start — Run Locally

**Prerequisites:** Flutter installed, Android SDK (or Xcode for iOS), and Firebase project with `google-services.json` (Android) / `GoogleService-Info.plist` (iOS).

**1. Clone**
```bash
git clone https://github.com/your-username/Task_Tracker_Mobile_App.git
cd Task_Tracker_Mobile_App
android/app/google-services.json
ios/GoogleService-Info.plist
build/
.dart_tool/
flutter clean
flutter pub get
flutter run


