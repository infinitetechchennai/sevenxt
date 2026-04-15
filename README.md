# SevenXT Mobile + App Backend

This repository contains the customer-facing SevenXT mobile app (Flutter) and its FastAPI backend used by the app.

## Project Structure

- `sevenxt/` - Flutter mobile application.
- `app/backend/` - FastAPI backend for auth, orders, payment, shipping, and integrations.
- `.github/` - CI/config automation files.

## Tech Stack

- **Mobile:** Flutter (Dart)
- **Backend:** FastAPI + PostgreSQL
- **Payments:** Razorpay
- **OTP/SMS:** Twilio
- **Shipping:** Delhivery
- **Auth:** JWT

## Local Setup

### 1) Backend

From `app/backend/`:

1. Create and activate a virtual environment.
2. Install dependencies:
   - `pip install -r requirements.txt`
3. Configure `.env` values (DB, JWT, Razorpay, Twilio, Delhivery).
4. Run server:
   - `uvicorn main:app --reload`

### 2) Flutter App

From `sevenxt/`:

1. Install dependencies:
   - `flutter pub get`
2. Run:
   - `flutter run`

## Notes

- Keep secrets only in `.env` and never commit credentials.
- Runtime/generated folders (for example `__pycache__`, `uploads`) should stay out of version control.
