import './App.css'

function App() {
  return (
    <div className="app">
      <header>
        <h1>S.P.R.E.A.D.</h1>
        <p>Food Supply Traceback System</p>
      </header>

      <main>
        <h2>Product Traceback</h2>

        <p>
          Search for a food lot to view product and supply chain information.
        </p>

        <div>
          <input type="text" placeholder="Enter Lot ID" />
          <button type="button">Search</button>
        </div>

        <h2>Traceback Results</h2>
        <p>No lot selected.</p>
      </main>
    </div>
  )
}

export default App