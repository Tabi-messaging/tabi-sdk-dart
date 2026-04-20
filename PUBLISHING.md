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

## pub.dev

1. Ensure `pubspec.yaml` has correct `repository`, `homepage`, and `version`.
2. Run `dart pub publish --dry-run`, fix any issues, then `dart pub publish`.

## Version bumps

Update `version` in `pubspec.yaml` and add an entry in `CHANGELOG.md` before tagging.
