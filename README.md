# Excelerate 📚

**Excelerate** is a modern mobile e-learning app built with **Flutter**, designed to help learners advance their careers through personalized and engaging online courses. It works seamlessly on both **iOS** and **Android** devices.

---

## Overview

Excelerate provides a user-friendly platform where learners can:  

- Explore courses across multiple categories (Development, Design, Business, Data Science, etc.)  
- Track progress and achievements  
- Access course content, including video lessons and transcripts  
- Manage enrolled courses and personal profile settings  

The app focuses on **intuitive navigation**, **personalized learning**, and **cross-platform accessibility**.

---

## How the App Works

1. **Onboarding & Authentication**  
   - Users can now **sign up and sign in using Firebase Authentication**.  
   - Email/Password registration and **Google Sign-In** are fully implemented.  
   - **Loading indicators** are displayed during login and signup to prevent multiple requests.  
   - **Error handling** provides user feedback for invalid credentials, weak passwords, or network issues.  

2. **Learning Dashboard**  
   - Personalized greeting and progress overview.  
   - Quick access to ongoing courses and achievements.  

3. **Course Exploration**  
   - Browse or search for courses by category.  
   - Course pages include lessons, ratings, duration, and instructor info.  

4. **Course Player**  
   - Embedded video player with controls (play/pause, forward/backward, fullscreen).  
   - Lesson progress tracking and navigation between lessons.  
   - Transcript section for accessibility.  

5. **My Courses Section**  
   - Shows all enrolled courses with completion status.  
   - Filter courses by All, In Progress, Completed, Saved.  

6. **Profile & Account Management**  
   - Edit profile, change password, manage preferences (notifications, dark mode).  
   - Access help/support and legal info.  
   - Users are now redirected to their **Profile Page** after successful sign-up or login.  

---

## Week 3 Updates 🗓️

- Integrated **Firebase Auth** and **Firebase Core**.  
- Implemented **Email/Password Sign-In and Sign-Up** flows.  
- Added **Google Sign-In** authentication.  
- Introduced **loading states** during authentication processes.  
- Added **error handling** with user feedback (SnackBars and dialogs).  
- Navigation updated:  
  - **Sign-In → Home → Profile**  
  - **Sign-Up → Profile**  
  - **Google Sign-In → Profile**  

---

## Tech Stack 🛠️
- **Framework:** Flutter 3.x  
- **Language:** Dart  
- **State Management:** Provider / Riverpod / Bloc  
- **Backend:** Firebase (Auth, Firestore, Storage)  
- **Database:** Firebase Firestore  

---

## Getting Started 🚀

1. **Clone the repository**  
```bash
git clone https://github.com/AsimBinNasir/Excelerate.git
