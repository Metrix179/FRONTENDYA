# PoshanEye - Flutter Authentication & Home Dashboard

Run:
1. flutter pub get
2. flutter run

Parent demo sign-in:
- Child ID: PE-1048
- Password: 12345678

This sign-in is local prototype validation only. Replace it with a backend authentication service before production use.

UX architecture notes:
- `go_router` owns the role and authentication entry routes with curved fade/scale transitions.
- `flutter_riverpod` owns session-level state; form input remains local to each form screen.
- `flutter_animate` provides staggered entrance motion on the role-selection surface.
- The existing custom `AppTheme` now defines Material 3 component defaults and fluid page transitions.
- This checkout is web-only, so Android/iOS Impeller settings cannot be configured until those platform folders are generated.
- No large `ListView` or `GridView` exists in the current UI, so builder/staggered-list conversion would add complexity without a performance benefit.
