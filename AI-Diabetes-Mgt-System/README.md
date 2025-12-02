# AI Powered Diabetes Self Management System

A comprehensive Flutter application designed to help diabetic patients manage their health effectively using AI-powered features.

## Features

### 🔐 User Authentication
- **Register**: Users can sign up with email and password using Firebase Authentication
- **Login**: Secure login for registered users
- **Profile Management**: Users can update personal details (age, gender, weight, health history)

### 📊 Dashboard
After login, users access a comprehensive dashboard featuring:
- Quick access to upload food images
- Recent calorie & glucose reports
- Suggested meal plan summary
- Option to open chatbot for detailed interaction

### 📷 Calories & Glucose Calculator from Image
- Upload food pictures via camera or gallery
- Optional description input for cooked foods (e.g., "fried in oil," "boiled")
- AI-powered analysis providing:
  - Calorie content of the food
  - Estimated glucose level impact
  - Personalized recommendations

### 🍽️ Personalized Meal Plan
The app generates meal plans based on:
- User's age, gender, and weight
- Past 3 days' sugar level readings
- Health history and preferences
- Diabetic-friendly meal recommendations

### 🤖 Chatbot-Based Interaction
AI assistant that helps with:
- Collecting user information (age, gender, weight, sugar levels)
- Processing food image requests and returning analysis
- Providing basic meal plans and diabetes management advice
- 24/7 support for diabetes-related questions

### 📈 Health Reports
- Track glucose readings over time
- View food analysis history
- Monitor meal plan effectiveness
- Statistical insights and trends

## Technical Stack

- **Framework**: Flutter
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider
- **UI**: Material Design with custom white & blue theme
- **Image Processing**: Image Picker
- **Local Storage**: SharedPreferences

## Setup Instructions

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd diabties
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password)
   - Create a Firestore database
   - Enable Storage
   - Update `lib/firebase_options.dart` with your Firebase configuration:
     ```dart
     // Replace with your actual Firebase configuration
     static const FirebaseOptions android = FirebaseOptions(
       apiKey: 'your-api-key',
       appId: 'your-app-id',
       messagingSenderId: 'your-sender-id',
       projectId: 'your-project-id',
       storageBucket: 'your-storage-bucket',
     );
     ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Collections Structure

The app uses the following Firestore collections:

#### Users Collection
```
users/{userId}
├── fullName: string
├── email: string
├── age: number
├── gender: string
├── weight: number
├── healthHistory: string
├── isProfileComplete: boolean
├── createdAt: timestamp
└── updatedAt: timestamp
```

#### Sugar Readings Collection
```
sugar_readings/{readingId}
├── reading: number
├── dateTime: timestamp
└── userId: string
```

#### Calorie Reports Collection
```
calorie_reports/{reportId}
├── foodName: string
├── calories: number
├── glucoseImpact: number
├── imageUrl: string (optional)
├── description: string (optional)
├── dateTime: timestamp
└── userId: string
```

#### Meal Plans Collection
```
meal_plans/{planId}
├── mealPlan: string
├── generatedAt: timestamp
├── userId: string
├── userAge: number
├── userWeight: number
├── userGender: string
└── recentReadings: array
```

## App Architecture

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── services/                 # Business logic
│   ├── auth_service.dart     # Authentication service
│   └── user_service.dart     # User data management
└── screens/                  # UI screens
    ├── auth/                 # Authentication screens
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── dashboard/            # Main dashboard
    │   └── dashboard_screen.dart
    ├── profile/              # User profile management
    │   └── profile_screen.dart
    ├── food/                 # Food scanning
    │   └── food_scanner_screen.dart
    ├── chatbot/              # AI assistant
    │   └── chatbot_screen.dart
    └── reports/              # Health reports
        └── reports_screen.dart
```

## Design Theme

The app uses a clean white and blue color scheme:
- **Primary Blue**: #2196F3
- **Secondary Blue**: #1976D2
- **Background**: White (#FFFFFF)
- **Surface**: Light gray (#F5F5F5)
- **Cards**: White with subtle shadows

## Usage Guide

### Getting Started
1. **Register** a new account or **Login** with existing credentials
2. **Complete your profile** with personal health information
3. **Add glucose readings** to track your levels
4. **Scan food items** to get nutritional analysis
5. **Generate meal plans** based on your health data
6. **Use the AI chatbot** for personalized advice

### Food Scanning
1. Navigate to the "Scan Food" section
2. Take a photo or select from gallery
3. Enter the food name and cooking method
4. Get instant calorie and glucose impact analysis
5. Save the report for tracking

### Meal Planning
1. Ensure your profile is complete
2. Have recent glucose readings logged
3. Request meal plan generation through dashboard or chatbot
4. Follow the personalized recommendations

### AI Assistant
- Ask questions about diabetes management
- Get meal suggestions
- Understand glucose readings
- Receive general health tips
- Log health information through conversation

## Security & Privacy

- All user data is encrypted and stored securely in Firebase
- Authentication is handled by Firebase Auth
- Personal health information is protected according to privacy standards
- No sensitive data is stored locally on the device

## Future Enhancements

- Integration with wearable devices
- Advanced AI image recognition for food analysis
- Doctor/healthcare provider dashboard
- Medication tracking and reminders
- Social features for community support
- Integration with health APIs
- Offline mode capabilities

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support

For support and questions:
- Open an issue in the repository
- Contact the development team
- Check the documentation

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This is a health management tool and should not replace professional medical advice. Always consult with healthcare providers for medical decisions.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
