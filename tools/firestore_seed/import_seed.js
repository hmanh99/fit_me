/**
 * Node script to import seed data into Firestore using firebase-admin.
 *
 * Usage (PowerShell):
 * 1. Create a Firebase service account key JSON in Google Cloud IAM and download it.
 * 2. Install dependencies: npm install firebase-admin
 * 3. Set env var (PowerShell): $env:GOOGLE_APPLICATION_CREDENTIALS = "C:\path\to\serviceAccountKey.json"
 * 4. Run: node import_seed.js
 *
 * The script reads seed_workouts.json and writes each entry into the "workouts" collection.
 * If an object has a top-level "docId" field it will be used as the Firestore document ID.
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const seedFile = path.join(__dirname, 'seed_workouts.json');

if (!fs.existsSync(seedFile)) {
  console.error('seed_workouts.json not found in tools/firestore_seed');
  process.exit(1);
}

// Initialize app - uses GOOGLE_APPLICATION_CREDENTIALS or default credentials
try {
  admin.initializeApp();
} catch (e) {
  // already initialized in some environments
}

const db = admin.firestore();

async function importSeed() {
  const raw = fs.readFileSync(seedFile, 'utf8');
  const docs = JSON.parse(raw);

  for (const doc of docs) {
    try {
      const docId = doc.docId || db.collection('workouts').doc().id;
      const toWrite = Object.assign({}, doc);
      delete toWrite.docId;

      // Ensure numeric fields are numbers (the JSON already has numbers), no extra transformation needed
      await db.collection('workouts').doc(docId).set(toWrite, { merge: false });
      console.log(`Wrote workout document: ${docId}`);
    } catch (err) {
      console.error('Error writing document', err);
    }
  }

  console.log('Import completed.');
}

importSeed().catch((e) => {
  console.error('Import failed', e);
  process.exit(1);
});

