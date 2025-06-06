# ~/.dotfiles/zsh/performance.zsh
# Performance monitoring and optimization

# Enable timing for all commands if DEBUG is set
if [[ -n "$DEBUG" ]]; then
  setopt XTRACE
fi

# Performance monitoring variables
typeset -g DOTFILES_PERF_ENABLED=${DOTFILES_PERF_ENABLED:-0}
typeset -g DOTFILES_SLOW_COMMAND_THRESHOLD=${DOTFILES_SLOW_COMMAND_THRESHOLD:-5000}

# Command timing
if [[ "$DOTFILES_PERF_ENABLED" -eq 1 ]]; then
  preexec() {
    DOTFILES_TIMER_START=$(date +%s%3N)
  }
  
  precmd() {
    if [[ -n "$DOTFILES_TIMER_START" ]]; then
      local timer_end=$(date +%s%3N)
      local elapsed=$((timer_end - DOTFILES_TIMER_START))
      
      if [[ $elapsed -gt $DOTFILES_SLOW_COMMAND_THRESHOLD ]]; then
        echo "⏱️  Command took ${elapsed}ms"
      fi
      
      unset DOTFILES_TIMER_START
    fi
  }
fi

# Performance profiling functions
profile_start() {
  export DOTFILES_PROFILE_START=$(date +%s%3N)
  echo "📊 Performance profiling started..."
}

profile_end() {
  if [[ -n "$DOTFILES_PROFILE_START" ]]; then
    local end_time=$(date +%s%3N)
    local total_time=$((end_time - DOTFILES_PROFILE_START))
    echo "📊 Total time: ${total_time}ms"
    unset DOTFILES_PROFILE_START
  else
    echo "❌ No profiling session active"
  fi
}

# Shell startup time analysis
benchmark_startup() {
  local iterations=${1:-5}
  local total_time=0
  
  echo "🔄 Benchmarking shell startup ($iterations iterations)..."
  
  for i in {1..$iterations}; do
    local start_time=$(date +%s%3N)
    zsh -i -c 'exit' 2>/dev/null
    local end_time=$(date +%s%3N)
    local iteration_time=$((end_time - start_time))
    
    echo "Iteration $i: ${iteration_time}ms"
    total_time=$((total_time + iteration_time))
  done
  
  local average_time=$((total_time / iterations))
  echo "📊 Average startup time: ${average_time}ms"
  
  if [[ $average_time -gt 1000 ]]; then
    echo "⚠️  Startup time is slow. Consider optimizing your dotfiles."
  elif [[ $average_time -lt 500 ]]; then
    echo "✅ Startup time is excellent!"
  else
    echo "✅ Startup time is good."
  fi
}

# Function timing utility
time_function() {
  local func_name="$1"
  shift
  
  if ! declare -f "$func_name" &> /dev/null; then
    echo "❌ Function '$func_name' not found"
    return 1
  fi
  
  local start_time=$(date +%s%3N)
  "$func_name" "$@"
  local end_time=$(date +%s%3N)
  local elapsed=$((end_time - start_time))
  
  echo "⏱️  Function '$func_name' took ${elapsed}ms"
}

# Memory usage monitoring
memory_usage() {
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    local memory_info=$(vm_stat | grep -E "(Pages free|Pages active|Pages inactive|Pages speculative|Pages wired down)")
    local page_size=$(vm_stat | grep "page size" | awk '{print $8}')
    
    echo "🧠 Memory Usage (macOS):"
    echo "$memory_info" | while read line; do
      local pages=$(echo "$line" | awk '{print $3}' | sed 's/\.//')
      local category=$(echo "$line" | awk '{print $1, $2}')
      local mb=$((pages * page_size / 1024 / 1024))
      echo "  $category: ${mb}MB"
    done
  else
    # Linux
    echo "🧠 Memory Usage (Linux):"
    free -h
  fi
}

# CPU usage monitoring
cpu_usage() {
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    echo "🔥 CPU Usage (macOS):"
    top -l 1 -s 0 | grep "CPU usage" | awk '{print "  User:", $3, "Sys:", $5, "Idle:", $7}'
  else
    # Linux
    echo "🔥 CPU Usage (Linux):"
    top -bn1 | grep "Cpu(s)" | awk '{print "  User:", $2, "Sys:", $4, "Idle:", $8}'
  fi
}

# Disk I/O monitoring
disk_io() {
  echo "💽 Disk I/O:"
  if [[ "$(uname)" == "Darwin" ]]; then
    iostat -d 1 1 | tail -n +3
  else
    iostat -d 1 1 | tail -n +4
  fi
}

# Network monitoring
network_stats() {
  echo "🌐 Network Statistics:"
  if [[ "$(uname)" == "Darwin" ]]; then
    netstat -ib | grep -E "(Name|en0|en1|lo0)" | head -10
  else
    cat /proc/net/dev | head -5
  fi
}

# System performance overview
sysperf() {
  echo "📊 System Performance Overview"
  echo "==============================="
  echo ""
  
  # Uptime
  echo "⏰ Uptime:"
  uptime
  echo ""
  
  # Load average
  echo "📈 Load Average:"
  if [[ "$(uname)" == "Darwin" ]]; then
    sysctl -n vm.loadavg
  else
    cat /proc/loadavg
  fi
  echo ""
  
  # Memory
  memory_usage
  echo ""
  
  # CPU
  cpu_usage
  echo ""
  
  # Disk usage
  echo "💿 Disk Usage:"
  df -h | head -5
  echo ""
  
  # Top processes
  echo "🔝 Top Processes (by CPU):"
  if [[ "$(uname)" == "Darwin" ]]; then
    ps aux | sort -rk 3,3 | head -6
  else
    ps aux --sort=-%cpu | head -6
  fi
}

# Dotfiles performance analysis
dotfiles_perf() {
  echo "🔧 Dotfiles Performance Analysis"
  echo "================================="
  echo ""
  
  # Check for common performance issues
  echo "🔍 Checking for performance issues..."
  
  # Large history file
  if [[ -f "$HISTFILE" ]]; then
    local hist_size=$(wc -l < "$HISTFILE" 2>/dev/null || echo "0")
    if [[ $hist_size -gt 50000 ]]; then
      echo "⚠️  Large history file: $hist_size lines (consider cleaning)"
    else
      echo "✅ History file size: $hist_size lines"
    fi
  fi
  
  # Completion cache
  local comp_cache_dir="${HOME}/.zsh/cache"
  if [[ -d "$comp_cache_dir" ]]; then
    local cache_size=$(du -sh "$comp_cache_dir" 2>/dev/null | cut -f1)
    echo "✅ Completion cache size: $cache_size"
  fi
  
  # Check for slow plugins/modules
  echo ""
  echo "🧩 Module load times:"
  for config_file in exports macos completion aliases functions git prompt performance; do
    local config_path="${ZSH_CONFIG_DIR}/${config_file}.zsh"
    if [[ -r "$config_path" ]]; then
      time_function source "$config_path" 2>&1 | grep "took" | sed "s/Function 'source'/  $config_file/"
    fi
  done
}

# Clean up performance data
perf_cleanup() {
  echo "🧹 Cleaning up performance data..."
  
  # Clean completion cache
  rm -rf ~/.zsh/cache/*
  echo "✅ Cleared completion cache"
  
  # Trim history file
  if [[ -f "$HISTFILE" ]]; then
    local backup_file="${HISTFILE}.backup.$(date +%Y%m%d)"
    cp "$HISTFILE" "$backup_file"
    tail -n 10000 "$HISTFILE" > "${HISTFILE}.tmp" && mv "${HISTFILE}.tmp" "$HISTFILE"
    echo "✅ Trimmed history file (backup: $backup_file)"
  fi
  
  # Clean temporary files
  find /tmp -name "zsh*" -user "$USER" -mtime +7 -delete 2>/dev/null
  echo "✅ Cleaned temporary files"
  
  echo "🎉 Performance cleanup complete"
}

# Enable/disable performance monitoring
perf_toggle() {
  if [[ "$DOTFILES_PERF_ENABLED" -eq 1 ]]; then
    export DOTFILES_PERF_ENABLED=0
    echo "📊 Performance monitoring disabled"
  else
    export DOTFILES_PERF_ENABLED=1
    echo "📊 Performance monitoring enabled"
  fi
}

# Set performance threshold
perf_threshold() {
  local threshold="$1"
  
  if [[ -z "$threshold" ]] || ! [[ "$threshold" =~ ^[0-9]+$ ]]; then
    echo "Usage: perf_threshold <milliseconds>"
    echo "Current threshold: ${DOTFILES_SLOW_COMMAND_THRESHOLD}ms"
    return 1
  fi
  
  export DOTFILES_SLOW_COMMAND_THRESHOLD="$threshold"
  echo "📊 Slow command threshold set to ${threshold}ms"
}

# Performance tips
perf_tips() {
  echo "🚀 Performance Optimization Tips"
  echo "================================="
  echo ""
  echo "1. 🔧 Keep your dotfiles modular and load only what you need"
  echo "2. 📝 Limit history size (current: $(echo ${HISTSIZE:-unknown}))"
  echo "3. 🧹 Regularly clean completion cache (~/.zsh/cache/)"
  echo "4. ⚡ Use command-not-found handlers sparingly"
  echo "5. 🔄 Minimize the use of external commands in prompt"
  echo "6. 📦 Keep plugin count reasonable"
  echo "7. 🎯 Use conditional loading for heavy tools"
  echo "8. 💾 Consider using SSD for better I/O performance"
  echo "9. 🔍 Profile startup time regularly with 'benchmark_startup'"
  echo "10. 📊 Enable performance monitoring with 'perf_toggle'"
}

# Export performance functions
typeset -a performance_functions=(
  profile_start
  profile_end
  benchmark_startup
  time_function
  memory_usage
  cpu_usage
  disk_io
  network_stats
  sysperf
  dotfiles_perf
  perf_cleanup
  perf_toggle
  perf_threshold
  perf_tips
)

# Auto-complete for performance functions
if command -v compdef &> /dev/null; then
  compdef '_alternative "functions:performance functions:(${performance_functions[*]})"' time_function
fi 