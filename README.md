# 📱 Employee Manager – Flutter App Task

This is a submission for the technical task assigned by **Realtime Innovations** as part of the hiring process.

---

## 📌 Project Overview

The **Employee Manager** is a Flutter-based CRUD application where users can:

- Add new employee data
- Edit existing employee information
- Delete employee entries
- View a list of employees with details
- Pick and store dates with a custom date picker
- Persist data locally using a local database
- Experience a pixel-perfect UI on all mobile screen sizes

---

This project has been developed using the **BLoC state management** pattern and follows a **Clean UI Architecture**, ensuring a highly maintainable and scalable codebase. It uses the **Hive local database** to provide blazing-fast data persistence and smooth performance across devices.

---

## 🚀 Features

✅ Add/Edit/Delete Employee Information  
✅ Persist Data using `Hive` (local database)  
✅ Pixel-perfect UI across different screen resolutions  
✅ Custom Date Picker aligned with design  
✅ State Management using `Bloc` / `Cubit`  
✅ Clean UI Architecture for maintainability  
✅ Responsive UI & error handling for edge cases  
✅ Flutter Web version hosted for preview

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Hive** for local data persistence
- **BLoC / Cubit** for state management
- **Clean Architecture**
- **Responsive Framework** for adaptive UI
- **Flutter Web** for deployment

---



## 💡 Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/employee_manager_flutter.git
   cd employee_manager_flutter
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Code Generation (important before running the app)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

5. **Build APK**
   ```bash
   flutter build apk --release
   ```

6. **For Web Version**
   ```bash
   flutter build web
   ```

---
## 🎥 Video Walkthrough

The screen recording covers:

- App walkthrough on mobile
- All UI components in action
- Adding, editing, and deleting employees
- Date picker usage
- Handling edge cases (empty fields, validations)
- Web app preview

---

## 🙏 Acknowledgment

Thanks to **Realtime Innovations** for the opportunity. Looking forward to the next steps!
