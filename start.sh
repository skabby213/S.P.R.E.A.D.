
#!/usr/bin/env bash
set -e

# Move to the S.P.R.E.A.D project directory
cd "$(dirname "$0")"

echo "Building S.P.R.E.A.D backend..."
cmake -S backend -B backend/build
cmake --build backend/build

echo "Preparing React frontend..."
if [ ! -d frontend/node_modules ]; then
    npm --prefix frontend ci
fi

npm --prefix frontend run build

echo "Starting C++ backend on port 8080..."
./backend/build/spread_backend &
BACKEND_PID=$!

# Stop the backend when the startup script exits
cleanup() {
    kill "$BACKEND_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo "Starting React frontend on port 4173..."
echo "Open port 4173 in your browser."
echo "Press Ctrl+C to stop S.P.R.E.A.D."

cd frontend
./node_modules/.bin/vite preview --host 0.0.0.0 --port 4173 --strictPort
