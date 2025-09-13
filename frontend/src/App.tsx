import { useState, useEffect } from 'react'
import { healthService } from './services/healthService'
import type { HealthResponse, PingResponse } from './services/healthService'
import './App.css'

function App() {
  const [healthStatus, setHealthStatus] = useState<HealthResponse | null>(null)
  const [pingStatus, setPingStatus] = useState<PingResponse | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const checkConnection = async () => {
    setLoading(true)
    setError(null)

    try {
      // Health check
      const health = await healthService.checkHealth()
      setHealthStatus(health)

      // Ping test
      const ping = await healthService.ping()
      setPingStatus(ping)
    } catch (err) {
      console.error('Connection test failed:', err)
      setError(err instanceof Error ? err.message : 'Connection failed')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    // 자동으로 연결 테스트 실행
    checkConnection()
  }, [])

  return (
    <div className="App">
      <h1>🌱 GrowTogether TodoList</h1>
      <p>Foundation & Database Setup Test</p>

      <div className="connection-status">
        <h2>Backend Connection Test</h2>
        <button onClick={checkConnection} disabled={loading}>
          {loading ? 'Testing Connection...' : 'Test Connection'}
        </button>

        {error && (
          <div style={{ color: 'red', margin: '10px 0' }}>
            ❌ Error: {error}
          </div>
        )}

        {healthStatus && (
          <div style={{ margin: '20px 0' }}>
            <h3>Health Check Results:</h3>
            <div style={{ textAlign: 'left', background: '#f0f0f0', padding: '10px', borderRadius: '5px' }}>
              <p>✅ Status: {healthStatus.status}</p>
              <p>🔗 Service: {healthStatus.service}</p>
              <p>🗄️ Database: {healthStatus.database}</p>
              {healthStatus.database_url && <p>📍 DB URL: {healthStatus.database_url}</p>}
              <p>⏰ Timestamp: {new Date(healthStatus.timestamp).toLocaleString()}</p>
            </div>
          </div>
        )}

        {pingStatus && (
          <div style={{ margin: '20px 0' }}>
            <h3>Ping Test:</h3>
            <div style={{ textAlign: 'left', background: '#e8f5e8', padding: '10px', borderRadius: '5px' }}>
              <p>📡 {pingStatus.message}</p>
              <p>⏰ {new Date(pingStatus.timestamp).toLocaleString()}</p>
            </div>
          </div>
        )}
      </div>

      <div style={{ marginTop: '40px', fontSize: '14px', color: '#666' }}>
        <p>Story 1.1: Foundation & Database Setup</p>
        <p>Backend: http://localhost:8080/api</p>
        <p>Frontend: http://localhost:5173</p>
      </div>
    </div>
  )
}

export default App
