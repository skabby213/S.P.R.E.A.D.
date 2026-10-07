import "./App.css";

function App() {
  return (
    <div className="page">
      <header>
        <h1>S.P.R.E.A.D.</h1>
        <p>Foodborne Illness Traceability System</p>
      </header>

    <nav>
      <a href="#">Dashboard</a>
      <a href="#">Lots</a>
      <a href="#">Shipments</a>
      <a href="#">Labs</a>
      <a href="#">Recalls</a>
    </nav>
      <main>
        <h2>Current Investigation Records</h2>

        <p>
          S.P.R.E.A.D. connects food products, production lots, shipments,
          laboratory findings, exposure locations, and illness reports.
        </p>

        <div className="filters">
          <label>
            Pathogen:
            <select>
              <option>Any</option>
              <option>Listeria monocytogenes</option>
              <option>Salmonella enterica</option>
            </select>
          </label>

          <label>
            Product:
            <select>
              <option>Any</option>
              <option>Cheddar Cheese</option>
              <option>Whole Milk</option>
            </select>
          </label>
        </div>

        <table>
          <thead>
            <tr>
              <th>Lot Code</th>
              <th>Product</th>
              <th>Status</th>
              <th>Pathogen</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td>CHEESE-2026-001</td>
              <td>Cheddar Cheese</td>
              <td className="positive">Positive</td>
              <td>Listeria monocytogenes</td>
            </tr>

            <tr>
              <td>MILK-2026-004</td>
              <td>Whole Milk</td>
              <td className="clear">Clear</td>
              <td>—</td>
            </tr>
          </tbody>
        </table>
      </main>
    </div>
  );
}

export default App;