# 🩺 CancerCare

## Cancer Patient Monitoring & Support Mobile Application

> **Track. Care. Support.**

CancerCare is a Flutter-based mobile application designed to help cancer patients and caregivers manage treatment, medications, symptoms, appointments, medical reports, and daily health information in one organized platform.

The main goal of CancerCare is to make cancer care management easier, more organized, and accessible through a simple and user-friendly mobile application.

---

## 📱 Project Overview

Cancer patients often need to manage many important things at the same time, including:

* Treatment schedules
* Medication schedules
* Doctor appointments
* Symptoms
* Medical reports
* Health information
* Emergency contacts
* Treatment progress

Managing all these separately can become difficult.

**CancerCare** provides a centralized platform where users can organize and monitor important health-related information.

---

# 🎯 Project Objectives

The main objectives of CancerCare are:

* Organize cancer treatment information
* Track medications and treatment cycles
* Monitor daily health conditions
* Record symptoms
* Manage doctor appointments
* Store medical reports
* Visualize health progress
* Provide emergency support
* Provide an easy-to-use patient profile
* Help caregivers organize patient information

---

# ✨ Features

## 🏠 1. Home Dashboard

The Home screen provides an overview of the patient's current health and treatment status.

### Features

* Personalized greeting
* Treatment overview
* Current treatment cycle
* Treatment completion progress
* Next treatment session
* Today's health summary
* Pain level
* Temperature
* Weight
* Energy level
* Quick navigation
* Notification access

### Example

```text
Hello, JYOTI 👋

Take care of yourself today.

Treatment Overview
Chemotherapy
3 of 6 cycles
50% Complete

Today's Health

Pain Level     3/10
Temperature   98.4°F
Weight        62 kg
Energy        Good
```

---

## ❤️ 2. Health Monitoring

The Health section allows patients to monitor their daily health condition.

### Health Information

* Pain level
* Body temperature
* Weight
* Energy level
* Mood
* Symptoms
* Daily health status

Health information can be viewed through organized cards and progress information.

---

## 💊 3. Medication Management

CancerCare provides medication management functionality.

Users can:

* View current medications
* Check dosage
* Check medication timing
* Mark medication as taken
* View medication schedules
* Track medication history

### Example

```text
Medication

Ondansetron
8 mg
08:00 AM
Taken

Paracetamol
500 mg
02:00 PM
Pending
```

---

## 🏥 4. Treatment Tracking

The Treatment section helps patients monitor their cancer treatment.

### Treatment Features

* Treatment type
* Treatment cycle
* Completed cycles
* Remaining cycles
* Treatment progress
* Next treatment session
* Treatment history
* Treatment details

### Example

```text
Treatment Type:
Chemotherapy

Current Cycle:
3 of 6

Progress:
50%

Next Session:
28 September
```

---

## 📅 5. Appointment Management

CancerCare helps users keep track of important medical appointments.

### Appointment Features

* Doctor appointments
* Appointment date
* Appointment time
* Hospital information
* Doctor information
* Appointment status
* Upcoming appointments

### Example

```text
Upcoming Appointment

Dr. Example
Cancer Care Hospital

Date:
28 September

Time:
10:30 AM
```

---

## 🤒 6. Symptom Monitoring

Patients can record their daily symptoms.

### Examples

* Nausea
* Headache
* Fatigue
* Pain
* Fever
* Dizziness
* Loss of appetite
* Weakness

Users can monitor symptoms over time and observe changes in their health condition.

---

## 📄 7. Medical Reports

The Reports section is designed to organize important medical documents.

### Report Types

* Blood test reports
* Scan reports
* Biopsy reports
* Prescription
* Doctor notes
* Treatment reports

Each report can contain:

* Report title
* Date
* Hospital
* Doctor
* Report description

---

## 📊 8. Health Progress Charts

CancerCare provides health progress visualization.

Users can monitor:

* Weight progress
* Pain progress
* Temperature
* Energy level
* Treatment progress
* Health trends

Charts make it easier to understand changes in health over time.

---

## 🚨 9. Emergency Support

The Emergency feature provides quick access to emergency contact information.

### Emergency Contact

```text
01602381861
```

Users can quickly access their emergency contact during urgent situations.

> **Note:** CancerCare is a project/demo and does not replace professional medical advice or emergency medical services.

---

## 🔔 10. Notifications

CancerCare includes a notification section for important reminders.

Notifications can be used for:

* Medication reminders
* Treatment reminders
* Appointment reminders
* Health tracking reminders
* General care reminders

---

## 👤 11. Patient Profile

The Profile section contains important patient information.

### Demo Profile

```text
Name:
JYOTI

Age:
22

Gender:
Female

Blood Group:
A+

Emergency Contact:
01602381861

Caregiver:
Rina Singh

Caregiver Phone:
Not Provided

Doctor:
Dr. Example

Doctor Phone:
Not Provided

Hospital:
Cancer Care Hospital
```

---

## ⚙️ 12. Settings

The Settings section can be used for application preferences.

Possible settings include:

* Notification settings
* Profile settings
* Privacy settings
* App information
* Help and support

---

# 👥 Target Users

### Primary Users

* Cancer Patients

### Secondary Users

* Family Members
* Caregivers
* Doctors
* Healthcare Professionals

---

# 🛠️ Technologies Used

| Technology      | Purpose                 |
| --------------- | ----------------------- |
| Flutter         | Application Development |
| Dart            | Programming Language    |
| Material Design | UI Design               |
| Android         | Mobile Platform         |
| Web             | Chrome Demo/Testing     |
| VS Code         | Development Environment |
| GitHub          | Version Control         |

---

# 🏗️ Application Architecture

```text
CancerCare
│
├── Home
│   ├── Greeting
│   ├── Treatment Overview
│   ├── Today's Health
│   └── Quick Actions
│
├── Health
│   ├── Pain
│   ├── Temperature
│   ├── Weight
│   ├── Energy
│   └── Symptoms
│
├── Treatment
│   ├── Treatment Type
│   ├── Treatment Cycle
│   ├── Progress
│   └── Treatment History
│
├── Medication
│   ├── Medication List
│   ├── Dosage
│   ├── Schedule
│   └── Medication Status
│
├── Appointments
│   ├── Doctor
│   ├── Date
│   ├── Time
│   └── Hospital
│
├── Reports
│   ├── Medical Reports
│   ├── Blood Tests
│   ├── Scan Reports
│   └── Prescriptions
│
├── Emergency
│   └── Emergency Contact
│
└── Profile
    ├── Personal Information
    ├── Caregiver
    ├── Doctor
    └── Hospital
```

---

# 🎨 UI Design

CancerCare uses a clean and modern healthcare-focused interface.

### Design Principles

* Simple navigation
* Clean cards
* Healthcare-focused color scheme
* Large readable text
* Easy-to-understand icons
* Responsive layout
* Mobile-friendly interface
* Clear information hierarchy

---

# 🧭 Navigation

The application uses a bottom navigation bar.

```text
┌────────┬────────┬───────────┬────────┬────────┐
│  Home  │ Health │ Treatment │ Reports│ Profile│
└────────┴────────┴───────────┴────────┴────────┘
```

Users can easily move between the main sections.

---

# 📂 Project Structure

```text
CancerCare/
│
├── android/
├── ios/
├── web/
├── windows/
│
├── lib/
│   └── main.dart
│
├── pubspec.yaml
│
└── README.md
```

---

# 🚀 Installation & Setup

## Step 1 — Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Then enter the project folder:

```bash
cd CancerCare
```

---

## Step 2 — Install Flutter Dependencies

```bash
flutter pub get
```

---

## Step 3 — Check Flutter Installation

```bash
flutter doctor
```

Make sure Flutter is correctly installed and configured.

---

# ▶️ Run the Application

## Run on Chrome

To view the CancerCare app in Chrome:

```bash
flutter run -d chrome
```

---

## Run on Android

Connect an Android phone or start an Android emulator.

Check connected devices:

```bash
flutter devices
```

Then run:

```bash
flutter run
```

---

# 📱 Build APK

To create an Android APK:

```bash
flutter build apk --release
```

After a successful build, the APK can usually be found at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

You can copy the APK to an Android phone and install it.

---

# 🧪 Testing

The project can be tested using:

* Chrome
* Android Emulator
* Android Smartphone
* Windows development environment

Run:

```bash
flutter analyze
```

to check the project for Dart/Flutter analysis issues.

---

# 🔐 Privacy & Security

CancerCare is designed as an educational/project prototype.

In a production version, sensitive health information should be protected using:

* Secure authentication
* Encrypted data storage
* Secure API communication
* Role-based access control
* Secure cloud storage
* Proper healthcare privacy practices

---

# ⚠️ Medical Disclaimer

CancerCare is a software project/demo created for educational and application-development purposes.

The application does **not** provide medical diagnosis, treatment decisions, or professional medical advice.

Users should always consult qualified healthcare professionals regarding diagnosis, medication, treatment, symptoms, or emergencies.

For urgent medical situations, users should contact appropriate emergency medical services or a healthcare professional.

---

# 🔮 Future Improvements

Future versions of CancerCare may include:

* 🔐 User authentication
* ☁️ Firebase cloud database
* 👨‍⚕️ Doctor dashboard
* 👨‍👩‍👧 Caregiver account
* 💊 Automatic medication reminders
* 🔔 Push notifications
* 📅 Advanced appointment calendar
* 📄 PDF medical report upload
* 📷 Medical document scanning
* 📊 Advanced health analytics
* 📈 Detailed health charts
* 🧠 AI-based health insights
* 🌐 Cloud synchronization
* 🌙 Dark mode
* 🌍 Multiple language support
* 🆘 One-tap emergency calling

---

# 📸 Screenshots

Add your application screenshots inside a `screenshots` folder.

Example:

```text
screenshots/
├── home.png
├── health.png
├── treatment.png
├── reports.png
└── profile.png
```

Then add them to the README:

### Home Dashboard

![Home Screen](screenshots/home.png)

### Health Monitoring

![Health Screen](screenshots/health.png)

### Treatment

![Treatment Screen](screenshots/treatment.png)

### Reports

![Reports Screen](screenshots/reports.png)

### Profile

![Profile Screen](screenshots/profile.png)

---

# 📚 Main Modules

| Module        | Description                    |
| ------------- | ------------------------------ |
| Home          | Patient dashboard              |
| Health        | Daily health monitoring        |
| Treatment     | Treatment and cycle tracking   |
| Medication    | Medication management          |
| Symptoms      | Symptom tracking               |
| Appointments  | Medical appointment management |
| Reports       | Medical report organization    |
| Charts        | Health progress visualization  |
| Emergency     | Emergency contact support      |
| Notifications | Important reminders            |
| Profile       | Patient information            |
| Settings      | Application preferences        |

---

# 💡 Benefits

CancerCare can help users:

* Organize treatment information
* Remember important appointments
* Track medications
* Monitor symptoms
* Store medical information
* Understand health progress
* Access emergency contact information
* Keep important patient information in one place

---

# 🎓 Academic Project

**Project Name:** CancerCare

**Project Type:** Mobile Application

**Platform:** Flutter

**Programming Language:** Dart

**Application Category:** Healthcare / Patient Monitoring

### Tagline

> **Track. Care. Support.**

---

# 👩‍💻 Developer

**JYOTI**

CancerCare — Cancer Patient Monitoring & Support Mobile Application

---

# ❤️ Conclusion

CancerCare is designed to make cancer care management more organized and accessible.

Instead of keeping treatment schedules, medications, symptoms, appointments, and medical information in different places, CancerCare brings important information together in one application.

The project demonstrates how Flutter can be used to build a modern healthcare-focused mobile application with an intuitive user interface and patient-centered features.

> **Track. Care. Support.**

---

# ⭐ Support the Project

If you find this project useful, consider giving the repository a ⭐ on GitHub.

Thank you for checking out **CancerCare**! ❤️
