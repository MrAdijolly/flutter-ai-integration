# Structured Notes AI

Prototype Flutter application that generates **structured academic notes using AI**.

This project is designed to help students quickly generate **well-organized study notes** for different academic streams such as Engineering, Polytechnic, and Arts & Science.

---

## Features

* AI-generated academic notes
* Clean structured output
* Supports multiple academic streams
* Simple and user-friendly interface

---

## Tech Stack

* **Flutter**
* **Dart**
* **Gemini API (Google Generative AI)**


  ## Requirements

- Flutter SDK → https://docs.flutter.dev/get-started/install  
- Git → https://git-scm.com/downloads  
- Android Studio → https://developer.android.com/studio  
- VS Code → https://code.visualstudio.com/  

  

---

## Project Structure

```
lib/
 ├── main.dart
 ├── integrateAI.dart
 ├── semester.dart
 ├── subjects.dart
 └── api_key.dart (ignored from Git)
```

---

## Getting Started

1. Clone the repository

```
git clone https://github.com/YOUR_USERNAME/sn_project.git
```

2. Navigate to the project folder

```
cd sn_project
```

3. Install dependencies

```
flutter pub get
```

4. Run the application

```
flutter run
```

---

## Security Note

The **Gemini API key is not included in the repository**.
Create a file:

```
lib/api_key.dart
```

and add your API key:

```dart
const String geminiApiKey = "YOUR_API_KEY";
```

---

## Author

**Adi Jolly**

---

## License

This project is for educational and prototype purposes.
