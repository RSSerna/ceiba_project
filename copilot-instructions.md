# Copilot Instructions for Ceiba Project

These instructions are intended to guide GitHub Copilot (and similar AI assistants) when making changes to this Flutter project.

## 🧭 Architecture and Style

### ✅ Clean Code Architecture (Feature-First)
- Organize code by **feature** (vertical slices), not by layer.
- Each feature folder contains its own `presentation`, `domain`, and `data` subfolders.
- Keep UI logic in `presentation`, business logic in `domain`, and data access in `data`.
- Prefer **small, focused classes** and avoid large widgets or single-file business logic.

### ✅ State Management: BLoC
- Use the **BLoC pattern** for state management.
- Each feature should have its own `Bloc`, `Event`, and `State` classes.
- Use `flutter_bloc` conventions: `BlocProvider`, `BlocBuilder`, `BlocListener`.

### ✅ Dependency Injection: get_it
- Use `get_it` for dependency injection and service location.
- Register dependencies in a dedicated `injection.dart` or `service_locator.dart` file.
- Use `GetIt.I.get<T>()` rather than global singletons.

## 📁 Project Structure (Preferred)

```
lib/
  core/
    errors/
    network/
    utils/
  features/
    <feature_name>/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        blocs/
        pages/
        widgets/
  shared/
    widgets/
    utils/
  injection.dart
  main.dart
```

> Each feature folder should be self-contained; shared code should live under `shared/` or `core/`.

## 🧪 Testing
- Provide unit tests for BLoCs, use cases, and repositories.
- Use `mocktail` or `mockito` for mocking.

## 🧰 Packages (Use when appropriate)
- `flutter_bloc`
- `bloc_test`
- `get_it`
- `equatable`
- `dio` or `http` for networking (keep it in data layer)

## ✨ Assistant Behavior
- If requested to add features, follow the architecture pattern above.
- Prefer **minimal and explicit changes**; avoid generating unused code.
- When modifying existing code, preserve naming conventions and file structure.

---

> If this file needs to be updated (new patterns, dependencies, or conventions), update this file rather than assuming changed behavior.
