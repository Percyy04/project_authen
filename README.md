# 🔐 Flutter Firebase Authentication Demo

> **GROUP 1 — PRM393 | FPT University**  
> A complete, production-style Flutter authentication app powered by Firebase.

---

## 📋 Overview

`project_authen` is a full-featured Flutter authentication demo that demonstrates a clean, event-driven auth architecture using Firebase Authentication. The project covers the full authentication lifecycle — from registration and login to password recovery, email verification, and secure account management.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📧 Email / Password Login | Sign in with email and password |
| 📝 Register | Create new account with email verification |
| 🔑 Forgot Password (Email) | Reset password via email link |
| 📱 Forgot Password (SMS OTP) | Reset password via phone number & OTP |
| ✅ Email Verification | Verify email after registration |
| 👤 Update Username | Change display name (with re-auth) |
| 🔒 Reset Password | Change password from current (with re-auth) |
| 🗑️ Delete Account | Permanently delete account (with re-auth) |
| 🚪 Sign Out | Logout with session cleanup |

---

## 🏗️ Architecture

The app follows an **Event-Driven Proxy Redirection** pattern centered around `AuthWrapper`.

```
MyApp
└── AuthWrapper (listens to FirebaseAuth.instance.authStateChanges())
        ├── Loading State     → CircularProgressIndicator
        ├── Unauthenticated   → LoginScreen
        └── Authenticated     → HomeScreen
```

All Firebase logic is centralized in a single `AuthService` class — acting as the **single source of truth** for authentication state.

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point + AuthWrapper
├── firebase_options.dart              # Firebase configuration
├── services/
│   └── auth_service.dart              # Centralized auth logic
└── screens/
    ├── login_screen.dart
    ├── register_screen.dart
    ├── home_screen.dart
    ├── verify_email_screen.dart
    ├── forgot_password_choice_screen.dart
    ├── forgot_password_email_screen.dart
    ├── forgot_password_screen.dart
    ├── reset_password_screen.dart
    └── reset_password_new_screen.dart
```

---

## 🔧 Core Dependencies

```yaml
dependencies:
  firebase_core: ^4.5.0
  firebase_auth: ^6.2.0
  provider: ^6.1.2
  pinput: ^6.0.2
  get: ^4.7.3
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.2.0`
- A Firebase project (with Authentication enabled)
- Android / iOS setup completed

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Percyy04/project_authen.git
   cd project_authen
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**  
   Replace `lib/firebase_options.dart` with your own Firebase project config, or run:
   ```bash
   flutterfire configure
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🛡️ Security Design

### Timeout Guards
All async operations are protected against infinite loading via strict timeouts:

```dart
.timeout(const Duration(seconds: 15))  // login, register, account updates
.timeout(const Duration(seconds: 10))  // sign out
```

### Re-authentication Loop
Sensitive operations (`updatePassword`, `deleteAccount`) require a recent login session:

```
Step 1 → EmailAuthProvider.credential(email, password)
Step 2 → user.reauthenticateWithCredential(credential)
Step 3 → user.updatePassword() / user.delete()
```

### Email Verification Loop
```
sendEmailVerification() → User clicks inbox link → currentUser?.reload() → AuthWrapper re-routes
```

### Error Handling
All Firebase exceptions are caught and mapped to user-friendly UI messages:

| Firebase Error Code | UI Message |
|---|---|
| `wrong-password` | Mật khẩu không đúng |
| `invalid-email` | Email không hợp lệ |
| `user-not-found` | Tài khoản không tồn tại |
| `email-already-in-use` | Email đã được sử dụng |
| `weak-password` | Mật khẩu quá yếu |

---

## 📊 API Reference — AuthService

| Method | Description | Timeout |
|---|---|---|
| `signIn(email, password)` | Login with email/password | 15s |
| `createUser(email, password)` | Register new account | 15s |
| `signOut()` | Logout and clear session | 10s |
| `resetPassword(email)` | Send password reset email | 15s |
| `updateUsername(username)` | Update display name | 15s |
| `resetPasswordFromCurrentPassword(...)` | Change password (re-auth required) | 15s |
| `deleteAccount(email, password)` | Delete account (re-auth required) | 15s |
| `verifyPhoneNumber(...)` | Trigger SMS OTP | 60s |
| `signInWithSmsCode(...)` | Verify OTP and sign in | 20s |
| `currentUser` | Get cached user (sync) | — |
| `authStateChanges` | Auth state stream for UI | — |

---

## 📌 Notes

- Language is set to Vietnamese (`setLanguageCode('vi')`) so Firebase emails are sent in Vietnamese.
- The app uses `GetMaterialApp` from the `get` package for lightweight routing.
- OTP input is handled using the `pinput` package for a clean UI.

---

## 📄 License

This project is for educational purposes — **PRM393, FPT University**.
