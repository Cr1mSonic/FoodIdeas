# Tic Tac Toe / Food Ideas

College project with a Flutter web/mobile client and a Node.js backend.

## Project folders

- `tic_tac_toe/` — Flutter application.
- `tic_tac_toe_server/` — Express server and SQLite database.

## Run locally

Start the backend in one Git Bash terminal:

```bash
cd /c/src/tic_tac_toe_server
npm install
npm start
```

Start Flutter Web in a second terminal:

```bash
cd /c/src/tic_tac_toe
../flutter/bin/flutter.bat pub get
../flutter/bin/flutter.bat run -d chrome
```

Keep the backend terminal open while using the app. The server uses port `3000`.

## Configure the backend address

The API address is currently written directly in these Flutter files:

- `tic_tac_toe/lib/screens/register_screen.dart`
- `tic_tac_toe/lib/screens/login_screen.dart`
- `tic_tac_toe/lib/screens/profile_screen.dart`
- `tic_tac_toe/lib/screens/food_screen.dart`

Replace `172.20.10.2` in those files with the current IP address of the computer running the backend. Keep port `3000`. When both Chrome and the backend run on the same computer, `localhost` can be used instead. A phone or another computer needs the backend computer's reachable local network IP.

## OpenAI API key

The backend reads `OPENAI_API_KEY` from:

`tic_tac_toe_server/.env`

This file is local and ignored by Git. Never commit or share it. To set up a local copy, create `.env` in `tic_tac_toe_server/` with:

```env
OPENAI_API_KEY=put_your_own_key_here
```

The safe template is `tic_tac_toe_server/.env.example`; it contains no real key. If a real key was committed or shared, revoke it and create a replacement.
