import { useState } from 'react'
import './App.css'

function App() {  
  const [lotId, setLotId] = useState('')
  const [lotData, setLotData] = useState(null)
  const searchLot = async () => {
  const response = await fetch(
    `/azuread/user/am2nk/codeserver/proxy/8080/api/lots/${lotId}`
  )

  const data = await response.json()
  setLotData(data)
}
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
          <input
          type="text"
          placeholder="Enter Lot ID"
          value={lotId}
          onChange={(e) => setLotId(e.target.value)}
        />
          <button type="button" onClick={searchLot}>
            Search
          </button>
        </div>

        <h2>Traceback Results</h2>
        {lotData ? (
          <div>
            <p>Lot ID: {lotData.lot_id}</p>
            <p>Lot Code: {lotData.lot_code}</p>
            <p>Status: {lotData.status}</p>
          </div>
        ) : (
          <p>No lot selected.</p>
        )}
      </main>
    </div>
  )
}

export default App