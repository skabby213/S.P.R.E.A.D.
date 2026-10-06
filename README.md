# S.P.R.E.A.D.

### System for Processing, Routing, Equipment, Allocation, and Distribution

S.P.R.E.A.D. is a food supply traceback system designed to help track potential foodborne outbreaks through the food supply chain.

The system connects food products, production lots, shipments, locations, laboratory testing, recalls, and reported illness cases to help identify potential sources of contamination.

## Project Description

Foodborne outbreaks can involve multiple products, locations, and stages of the supply chain, making it difficult to determine where contamination may have originated.

S.P.R.E.A.D. is being developed to organize this information in a relational database and provide a user interface for tracing food products through the supply chain.

The planned system architecture is:

React Frontend → C++ REST API → MySQL Database

## Technologies

- React
- JavaScript
- C++
- cpp-httplib
- CMake
- MySQL
- Vite
- Git / GitHub
- Leaflet (planned for mapping and visualization)

## Current Development

The project currently includes:

- A MySQL relational database schema for food supply traceback data
- A C++ REST API that builds and runs successfully
- A health endpoint for verifying that the backend service is running
- Dynamic API endpoints for retrieving product and lot information
- A React frontend for entering a Lot ID
- Communication between the React frontend and C++ backend
- JSON responses from the C++ API displayed in the React interface

### Current API Endpoints

GET /health

Returns the status of the S.P.R.E.A.D. API.

GET /api/products/{id}

Returns test product information using the supplied product ID.

GET /api/lots/{id}

Returns test lot information using the supplied lot ID.

Example:

GET /api/lots/1

Response:

{
  "lot_id": 1,
  "lot_code": "LOT-2026-001",
  "status": "active"
}

## Database

The MySQL database currently contains tables for:

- Pathogens
- Food Products
- Locations
- Illness Reports
- Exposures
- Lots
- Shipments
- Shipment Items
- Lab Tests
- Recalls
- Recall Items

These tables are designed to represent relationships between food products, their movement through the supply chain, testing results, recalls, and reported illnesses.

## How to Run the Project

### 1. Clone the Repository

Clone the S.P.R.E.A.D. repository and navigate into the project directory.

```bash
git clone <repository-url>
cd S.P.R.E.A.D.
```

### 2. Build the C++ Backend

From the project root, build the backend using CMake:

```bash
cmake --build backend/build
```

### 3. Start the C++ Backend

Run the backend server:

```bash
./backend/build/spread_backend
```

The S.P.R.E.A.D. API will run on port `8080`.

The backend can be tested with:

```bash
curl http://127.0.0.1:8080/health
```

A successful response should return:

```json
{
  "status": "ok",
  "service": "S.P.R.E.A.D. API"
}
```

The lot API can also be tested with:

```bash
curl http://127.0.0.1:8080/api/lots/1
```

### 4. Install Frontend Dependencies

Open a second terminal and navigate to the frontend directory:

```bash
cd frontend
```

Install the required packages:

```bash
npm install
```

### 5. Build the React Frontend

Create the frontend production build:

```bash
npm run build
```

### 6. Start the Frontend

Start the Vite preview server:

```bash
npx vite preview --host 0.0.0.0 --port 4173
```

The frontend runs on port `4173`.

Keep both the frontend and backend running while using the application:

```text
Frontend (React)     → Port 4173
Backend (C++ API)    → Port 8080
```

Enter a Lot ID, such as `1`, into the S.P.R.E.A.D. interface and select **Search**. The React frontend will send a request to the C++ API and display the returned lot information.

> **Note:** The current API uses test data. Integration between the C++ backend and MySQL database is still under development.

## Current System Flow

1. The user enters a Lot ID in the React interface.
2. React sends a request to the C++ REST API.
3. The C++ backend processes the request.
4. The API returns a JSON response containing lot information.
5. React displays the returned information to the user.

## Development Status

S.P.R.E.A.D. is currently under development.

The React frontend and C++ REST API are communicating successfully. Product and lot API responses currently use test data.

The MySQL database has been created, but database integration with the C++ backend is still in development.

## Next Steps

- Connect the C++ REST API to the MySQL database
- Retrieve real lot and product information from the database
- Expand traceback information to include shipments and locations
- Add laboratory test and recall information
- Improve the React user interface
- Add Leaflet mapping for supply chain visualization
- Expand API testing and error handling