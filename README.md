# flutter_classwork1

A class grades app: a Flutter client that shows each student's grade, a pass/fail mark and the class average, with
buttons that move a grade by 0.01 point. A Java backend is included, ready for a REST API.

## Repository layout

| Folder | Contents |
|---|---|
| `frontend/` | Flutter app (Android first, web for development, Windows desktop) |
| `backend/` | Java 21 / Spring Boot backend (REST API) |
| `.github/workflows/` | Continuous integration for the backend |

## Frontend

Requirements: Flutter (stable channel) with the Android SDK.

```
cd frontend
flutter pub get
flutter analyze
flutter test
flutter run
```

See `frontend/README.md` for what the screen does and how the code is laid out.

## Backend

Requirements: Java 21 and Maven 3.9+.

```
cd backend
mvn verify
```

`verify` compiles the code and runs the tests. To run the server locally:

```
cd backend
mvn spring-boot:run
```

The health check answers at `http://localhost:8080/health` with `{"status":"UP"}`.

## Continuous integration

Every push and pull request to `main` that touches `backend/` builds and tests the backend with GitHub Actions
(`.github/workflows/backend-ci.yml`).
