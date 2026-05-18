Seed Firestore - Workouts Collection
==================================

This folder contains a small seed dataset and an import script to populate the `workouts` collection
in your Firebase Firestore for local development or testing.

Files
- seed_workouts.json: List of workout documents compatible with the app's data models.
- import_seed.js: Node.js script using `firebase-admin` to write documents.

Quick steps (Windows PowerShell)
1. Install Node.js (if not installed): https://nodejs.org/
2. Open PowerShell in this folder:

   cd E:\AndroidStudioProjects\personal_fitness_tracker\tools\firestore_seed

3. Install dependency:

   npm install firebase-admin

4. Create a Firebase service account key:
   - Go to Google Cloud Console -> IAM & Admin -> Service Accounts
   - Create a service account with Firestore permissions and generate a JSON key
   - Save the key file locally, e.g. C:\keys\pf_tracker_sa.json

5. Set environment variable (PowerShell):

   $env:GOOGLE_APPLICATION_CREDENTIALS = 'C:\keys\pf_tracker_sa.json'

6. Run the importer:

   node import_seed.js

Notes
- The script will write documents into `workouts` collection. If a record has `docId` it will be used
  as the document ID, otherwise a generated ID is used.
- This operation can overwrite existing documents with the same ID (it's not merging).
- The JSON structure matches `WorkoutModel.fromFirestore` and `ExerciseModel.fromMap` used in the app.

If you prefer to use the Firebase Console UI, you can open the JSON and add documents manually.

