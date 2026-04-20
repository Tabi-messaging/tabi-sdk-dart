# Publishing `tabi_sdk`

## First-time GitHub setup

1. Create an empty repository on GitHub: **Tabi-messaging/tabi-sdk-dart** (no README/license if you are pushing an existing tree).

2. **If this folder is the only checkout** (standalone clone), from this directory (repository root):

```bash
git init
git add .
git commit -m "Initial commit: tabi_sdk Dart package"
git branch -M main
git remote add origin https://github.com/Tabi-messaging/tabi-sdk-dart.git
git push -u origin main
```

Do **not** run `git init` here while this directory is nested inside another Git repository (nested `.git` folders cause confusing behavior). In that case, either copy `tabi-sdk-dart/` to a new directory outside the monorepo and run the commands above, or push from the **parent** repository using a subtree split:

```bash
# from the parent monorepo root (example: PSIRS-INFRA)
git subtree split --prefix=tabi-sdk-dart -b tabi-sdk-dart-export
git push https://github.com/Tabi-messaging/tabi-sdk-dart.git tabi-sdk-dart-export:main
```

3. Tag releases when publishing to pub.dev:

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Publish to pub.dev

### 1. One-time: pub.dev account

1. Open [pub.dev](https://pub.dev) and sign in with a **Google account** you want tied to the package.
2. Optionally create a **verified publisher** so the package shows as `tabi.africa` (or your org) instead of a personal name:
   - [pub.dev/create-publisher](https://pub.dev/create-publisher)
   - You prove domain ownership with a **DNS TXT** record (or use the flow pub.dev documents for your case).

Until you have a verified publisher, the package is published under your **user account**; you can transfer or associate a publisher later following [pub.dev policy](https://dart.dev/tools/pub/publishing#publishing-your-package).

### 2. One-time: log in from the CLI

From any machine where you will run `dart pub publish`:

```bash
dart pub login
```

This stores credentials locally (or uses `PUB_CREDENTIALS` in CI—see [dart.dev publishing](https://dart.dev/tools/pub/publishing)).

### 3. Check the package before publishing

From the **package root** (this repo root, where `pubspec.yaml` lives):

```bash
dart pub get
dart analyze
dart test
dart pub publish --dry-run
```

`--dry-run` validates metadata, files, and size **without** uploading. Fix anything it reports (missing `LICENSE`, invalid `homepage`, etc.).

### 4. Publish

```bash
dart pub publish
```

Confirm when prompted. After a few minutes the package appears at `https://pub.dev/packages/tabi_sdk` (name comes from `name:` in `pubspec.yaml`).

### 5. After the first successful publish

- Tag the release in Git (match `version` in `pubspec.yaml`):

```bash
git tag v0.1.0
git push origin v0.1.0
```

- Later releases: bump `version` in `pubspec.yaml`, update `CHANGELOG.md`, commit, then repeat steps 3–4 and tag the new version.

### Common issues

| Issue | What to do |
|-------|------------|
| Name already taken | Change `name:` in `pubspec.yaml` (breaking for users—pick a stable name early). |
| `repository` invalid | Use a public `https://` URL; Git must match published content. |
| Files too large / wrong files | Add entries to `.gitignore`; `publish_to` is rarely needed if the tree is clean. |
| Not authorized | Run `dart pub login` again; ensure the Google account owns or can publish under the publisher. |

Official reference: [Publishing packages](https://dart.dev/tools/pub/publishing).

## Version bumps

Update `version` in `pubspec.yaml` and add an entry in `CHANGELOG.md` before tagging.

## Optional: live smoke script (maintainers)

To hit the real API from a checkout (requires `TABI_API_KEY` in the environment):

```bash
export TABI_API_KEY=tk_...
# optional: export TABI_BASE_URL=https://api.tabi.africa/api/v1
dart run tool/smoke.dart
```

This is **not** part of the public integration docs; it only lists channels as a connectivity check.
