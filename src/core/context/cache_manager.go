package context

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sync"
	"time"

	_ "github.com/mattn/go-sqlite3"
)

// CacheManager handles caching of analysis results
type CacheManager interface {
	// StoreAnalysis stores an analysis result in the cache
	StoreAnalysis(path string, result *AnalysisResult) error
	
	// GetAnalysis retrieves an analysis result from the cache
	GetAnalysis(path string) (*AnalysisResult, bool)
	
	// InvalidateAnalysis removes an analysis result from the cache
	InvalidateAnalysis(path string) error
	
	// CleanupCache removes old cache entries
	CleanupCache(maxAge time.Duration) error
}

// CacheManagerImpl implements the CacheManager interface
type CacheManagerImpl struct {
	db          *sql.DB
	cachePath   string
	maxCacheAge time.Duration
	mutex       sync.RWMutex
	memCache    map[string]*AnalysisResult
}

// NewCacheManager creates a new cache manager
func NewCacheManager() CacheManager {
	// Get user's home directory
	homeDir, err := os.UserHomeDir()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Could not get user home directory: %v\n", err)
		homeDir = "."
	}
	
	// Create cache directory
	cacheDir := filepath.Join(homeDir, ".crazy-dev", "cache")
	if err := os.MkdirAll(cacheDir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Could not create cache directory: %v\n", err)
	}
	
	// Create cache database
	dbPath := filepath.Join(cacheDir, "context.db")
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Could not open cache database: %v\n", err)
		return &CacheManagerImpl{
			cachePath:   dbPath,
			maxCacheAge: 24 * time.Hour, // Default cache age: 1 day
			memCache:    make(map[string]*AnalysisResult),
		}
	}
	
	// Create cache table if it doesn't exist
	_, err = db.Exec(`
		CREATE TABLE IF NOT EXISTS analysis_cache (
			path TEXT PRIMARY KEY,
			result TEXT NOT NULL,
			timestamp INTEGER NOT NULL
		)
	`)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Could not create cache table: %v\n", err)
		db.Close()
		return &CacheManagerImpl{
			cachePath:   dbPath,
			maxCacheAge: 24 * time.Hour,
			memCache:    make(map[string]*AnalysisResult),
		}
	}
	
	return &CacheManagerImpl{
		db:          db,
		cachePath:   dbPath,
		maxCacheAge: 24 * time.Hour, // Default cache age: 1 day
		memCache:    make(map[string]*AnalysisResult),
	}
}

// StoreAnalysis stores an analysis result in the cache
func (cm *CacheManagerImpl) StoreAnalysis(path string, result *AnalysisResult) error {
	// Store in memory cache
	cm.mutex.Lock()
	cm.memCache[path] = result
	cm.mutex.Unlock()
	
	// Skip if database is not available
	if cm.db == nil {
		return nil
	}
	
	// Serialize result to JSON
	resultJSON, err := json.Marshal(result)
	if err != nil {
		return fmt.Errorf("failed to serialize analysis result: %w", err)
	}
	
	// Store in database
	_, err = cm.db.Exec(
		"INSERT OR REPLACE INTO analysis_cache (path, result, timestamp) VALUES (?, ?, ?)",
		path, string(resultJSON), time.Now().Unix(),
	)
	if err != nil {
		return fmt.Errorf("failed to store analysis result in cache: %w", err)
	}
	
	return nil
}

// GetAnalysis retrieves an analysis result from the cache
func (cm *CacheManagerImpl) GetAnalysis(path string) (*AnalysisResult, bool) {
	// Check memory cache first
	cm.mutex.RLock()
	result, found := cm.memCache[path]
	cm.mutex.RUnlock()
	
	if found {
		// Check if the result is still valid
		if time.Since(result.AnalyzedAt) <= cm.maxCacheAge {
			return result, true
		}
		
		// Result is too old, remove from memory cache
		cm.mutex.Lock()
		delete(cm.memCache, path)
		cm.mutex.Unlock()
	}
	
	// Skip if database is not available
	if cm.db == nil {
		return nil, false
	}
	
	// Query database
	var resultJSON string
	var timestamp int64
	err := cm.db.QueryRow(
		"SELECT result, timestamp FROM analysis_cache WHERE path = ?",
		path,
	).Scan(&resultJSON, &timestamp)
	
	if err != nil {
		if err != sql.ErrNoRows {
			fmt.Fprintf(os.Stderr, "Warning: Error querying cache: %v\n", err)
		}
		return nil, false
	}
	
	// Check if the result is still valid
	if time.Since(time.Unix(timestamp, 0)) > cm.maxCacheAge {
		// Result is too old, remove from database
		cm.InvalidateAnalysis(path)
		return nil, false
	}
	
	// Deserialize result
	var cachedResult AnalysisResult
	if err := json.Unmarshal([]byte(resultJSON), &cachedResult); err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Failed to deserialize cached result: %v\n", err)
		return nil, false
	}
	
	// Store in memory cache
	cm.mutex.Lock()
	cm.memCache[path] = &cachedResult
	cm.mutex.Unlock()
	
	return &cachedResult, true
}

// InvalidateAnalysis removes an analysis result from the cache
func (cm *CacheManagerImpl) InvalidateAnalysis(path string) error {
	// Remove from memory cache
	cm.mutex.Lock()
	delete(cm.memCache, path)
	cm.mutex.Unlock()
	
	// Skip if database is not available
	if cm.db == nil {
		return nil
	}
	
	// Remove from database
	_, err := cm.db.Exec("DELETE FROM analysis_cache WHERE path = ?", path)
	if err != nil {
		return fmt.Errorf("failed to remove analysis result from cache: %w", err)
	}
	
	return nil
}

// CleanupCache removes old cache entries
func (cm *CacheManagerImpl) CleanupCache(maxAge time.Duration) error {
	// Skip if database is not available
	if cm.db == nil {
		return nil
	}
	
	// Calculate cutoff timestamp
	cutoff := time.Now().Add(-maxAge).Unix()
	
	// Remove old entries
	_, err := cm.db.Exec("DELETE FROM analysis_cache WHERE timestamp < ?", cutoff)
	if err != nil {
		return fmt.Errorf("failed to clean up cache: %w", err)
	}
	
	return nil
}
