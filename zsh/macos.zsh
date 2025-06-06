# ~/.dotfiles/zsh/macos.zsh
# macOS-specific optimizations and integrations

# Only load on macOS
[[ "$(uname)" != "Darwin" ]] && return 0

# ZSH options for macOS
setopt HIST_EXPIRE_DUPS_FIRST    # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Don't display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt HIST_VERIFY               # Don't execute immediately upon history expansion
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt AUTO_CD                   # Change directory just by typing directory name
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive mode
setopt MAGIC_EQUAL_SUBST         # Enable filename expansion for arguments of the form 'anything=expression'

# macOS-specific PATH additions
path=(
  # Homebrew paths (Apple Silicon and Intel)
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  
  # macOS system paths
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources"
  
  # User paths
  "${HOME}/.local/bin"
  "${HOME}/bin"
  
  $path
)

# Homebrew environment
if [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# macOS-specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias showdesktop='defaults write com.apple.finder CreateDesktop true; killall Finder'
alias hidedesktop='defaults write com.apple.finder CreateDesktop false; killall Finder'
alias spotoff='sudo mdutil -a -i off'
alias spoton='sudo mdutil -a -i on'
alias mute='osascript -e "set volume output muted true"'
alias unmute='osascript -e "set volume output muted false"'

# Quick Look
alias ql='qlmanage -p'

# Clipboard operations
alias pbcopy='pbcopy'
alias pbpaste='pbpaste'
alias copy='pbcopy'
alias paste='pbpaste'

# macOS system info
alias macinfo='system_profiler SPHardwareDataType SPSoftwareDataType'
alias battery='pmset -g batt'
alias thermal='sudo powermetrics --samplers smc_temp -n 1 | grep -i temp'

# Xcode and development
if command -v xcrun &> /dev/null; then
  alias ios='open -a Simulator'
  alias xcode='open -a Xcode'
fi

# Fix for macOS clipboard in tmux
if [[ -n "$TMUX" ]]; then
  alias pbcopy='reattach-to-user-namespace pbcopy'
  alias pbpaste='reattach-to-user-namespace pbpaste'
fi

# Homebrew management functions
brewup() {
  echo "Updating Homebrew..."
  brew update
  echo ""
  echo "Upgrading formulas..."
  brew upgrade
  echo ""
  echo "Cleaning up..."
  brew cleanup
  echo ""
  echo "Running doctor..."
  brew doctor
}

# Quick app launcher
app() {
  if [[ -z "$1" ]]; then
    echo "Usage: app <application-name>"
    return 1
  fi
  open -a "$1"
}

# macOS notification function
notify() {
  local title="${1:-Terminal}"
  local message="${2:-Command completed}"
  local sound="${3:-default}"
  
  osascript -e "display notification \"$message\" with title \"$title\" sound name \"$sound\""
}

# Lock screen
lock() {
  /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}

# Sleep functions
sleepnow() {
  pmset sleepnow
}

# Eject all mounted volumes
ejectall() {
  osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'
}

# Get current Wi-Fi network
wifi() {
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep ' SSID' | cut -d':' -f2 | sed 's/^ *//'
}

# Connect to Wi-Fi network
wificonnect() {
  if [[ -z "$1" ]]; then
    echo "Usage: wificonnect <network-name> [password]"
    return 1
  fi
  
  local network="$1"
  local password="$2"
  
  if [[ -n "$password" ]]; then
    networksetup -setairportnetwork en0 "$network" "$password"
  else
    networksetup -setairportnetwork en0 "$network"
  fi
}

# macOS defaults management
setdefault() {
  local domain="$1"
  local key="$2"
  local value="$3"
  local type="${4:-string}"
  
  if [[ -z "$domain" ]] || [[ -z "$key" ]] || [[ -z "$value" ]]; then
    echo "Usage: setdefault <domain> <key> <value> [type]"
    echo "Types: string, bool, int, float, array"
    return 1
  fi
  
  defaults write "$domain" "$key" -"$type" "$value"
  echo "Set $domain.$key to $value ($type)"
}

getdefault() {
  local domain="$1"
  local key="$2"
  
  if [[ -z "$domain" ]] || [[ -z "$key" ]]; then
    echo "Usage: getdefault <domain> <key>"
    return 1
  fi
  
  defaults read "$domain" "$key"
}

# macOS appearance
darkmode() {
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
  echo "Switched to dark mode"
}

lightmode() {
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
  echo "Switched to light mode"
}

# Screenshot utilities
screenshot() {
  local type="${1:-selection}"
  local filename="${2:-screenshot-$(date +%Y%m%d-%H%M%S).png}"
  
  case "$type" in
    "full"|"f")
      screencapture -x "$filename"
      ;;
    "selection"|"s"|*)
      screencapture -s "$filename"
      ;;
    "window"|"w")
      screencapture -w "$filename"
      ;;
    "clipboard"|"c")
      screencapture -c
      echo "Screenshot saved to clipboard"
      return 0
      ;;
  esac
  
  echo "Screenshot saved: $filename"
}

# Trash management (safer than rm)
trash() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: trash <file1> [file2] ..."
    return 1
  fi
  
  for file in "$@"; do
    if [[ -e "$file" ]]; then
      osascript -e "tell application \"Finder\" to delete POSIX file \"$(realpath "$file")\"" 2>/dev/null
      echo "Moved to trash: $file"
    else
      echo "File not found: $file"
    fi
  done
}

# Empty trash
emptytrash() {
  echo "Emptying trash..."
  osascript -e 'tell application "Finder" to empty trash'
  echo "Trash emptied"
}

# macOS service management
service() {
  local action="$1"
  local service_name="$2"
  
  case "$action" in
    "start")
      sudo launchctl load -w "/System/Library/LaunchDaemons/$service_name.plist" 2>/dev/null ||
      launchctl load -w "/System/Library/LaunchAgents/$service_name.plist" 2>/dev/null ||
      echo "Service not found: $service_name"
      ;;
    "stop")
      sudo launchctl unload -w "/System/Library/LaunchDaemons/$service_name.plist" 2>/dev/null ||
      launchctl unload -w "/System/Library/LaunchAgents/$service_name.plist" 2>/dev/null ||
      echo "Service not found: $service_name"
      ;;
    "list")
      launchctl list | grep -i "${service_name:-.*}"
      ;;
    *)
      echo "Usage: service {start|stop|list} [service-name]"
      ;;
  esac
}

# Check if running on Apple Silicon
is_apple_silicon() {
  [[ $(uname -m) == "arm64" ]]
}

# Rosetta management (Apple Silicon only)
if is_apple_silicon; then
  rosetta() {
    local action="$1"
    
    case "$action" in
      "install")
        sudo softwareupdate --install-rosetta --agree-to-license
        ;;
      "check")
        if pgrep oahd > /dev/null; then
          echo "Rosetta 2 is installed and running"
        else
          echo "Rosetta 2 is not running"
        fi
        ;;
      *)
        echo "Usage: rosetta {install|check}"
        ;;
    esac
  }
fi

# macOS software update
update() {
  echo "Checking for macOS updates..."
  softwareupdate -l
  echo ""
  read "REPLY?Install all updates? (y/N): "
  
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    sudo softwareupdate -ia
  fi
}

# macOS optimization
optimize() {
  echo "Optimizing macOS settings..."
  
  # Disable animations
  defaults write com.apple.dock expose-animation-duration -float 0.1
  defaults write com.apple.dock launchanim -bool false
  defaults write com.apple.finder DisableAllAnimations -bool true
  
  # Speed up Mission Control
  defaults write com.apple.dock expose-animation-duration -float 0.1
  
  # Disable dashboard
  defaults write com.apple.dashboard mcx-disabled -boolean true
  
  # Enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  
  echo "Restarting affected applications..."
  killall Dock
  killall Finder
  
  echo "macOS optimized for performance"
} 