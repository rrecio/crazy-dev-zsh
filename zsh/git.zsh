# ~/.dotfiles/zsh/git.zsh
# Advanced git integration and shortcuts

# Git status in prompt (if not using starship)
git_prompt_info() {
  if ! git rev-parse --git-dir &> /dev/null; then
    return 0
  fi

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local status=""
  local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  local modified=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
  local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")

  # Build status string
  if [[ "$staged" -gt 0 ]]; then
    status="${status}+${staged}"
  fi
  if [[ "$modified" -gt 0 ]]; then
    status="${status}!${modified}"
  fi
  if [[ "$untracked" -gt 0 ]]; then
    status="${status}?${untracked}"
  fi
  if [[ "$ahead" -gt 0 ]]; then
    status="${status}↑${ahead}"
  fi
  if [[ "$behind" -gt 0 ]]; then
    status="${status}↓${behind}"
  fi

  if [[ -n "$status" ]]; then
    echo " (%F{yellow}${branch}%f %F{red}${status}%f)"
  else
    echo " (%F{green}${branch}%f)"
  fi
}

# Check if current directory is in a git repository
is_git_repository() {
  git rev-parse --git-dir &> /dev/null
}

# Get current git branch
current_git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

# Smart git add - stage modified files or all files if none specified
gma() {
  if [[ $# -eq 0 ]]; then
    # Stage all modified files (not untracked)
    git add -u
  else
    git add "$@"
  fi
}

# Interactive git add
gai() {
  git add -i "$@"
}

# Git diff with better defaults
gdiff() {
  if [[ $# -eq 0 ]]; then
    git diff --color-words
  else
    git diff --color-words "$@"
  fi
}

# Git log with better formatting
glog() {
  local format="%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%an%C(reset) %s%C(auto)%d%C(reset)"
  git log --pretty=format:"$format" --date=short --graph "$@"
}

# Quick commit with message
qcommit() {
  if [[ -z "$1" ]]; then
    echo "Usage: qcommit <message>"
    return 1
  fi
  git add -A && git commit -m "$1"
}

# Git status with better formatting
gstatus() {
  if ! is_git_repository; then
    echo "Not in a git repository"
    return 1
  fi

  echo "Repository: $(basename $(git rev-parse --show-toplevel))"
  echo "Branch: $(current_git_branch)"
  echo ""
  git status --short --branch
}

# Switch to main/master branch
gmain() {
  if git show-ref --verify --quiet refs/heads/main; then
    git checkout main
  elif git show-ref --verify --quiet refs/heads/master; then
    git checkout master
  else
    echo "Neither 'main' nor 'master' branch found"
    return 1
  fi
}

# Create and switch to new branch
gnew() {
  if [[ -z "$1" ]]; then
    echo "Usage: gnew <branch-name>"
    return 1
  fi
  git checkout -b "$1"
}

# Delete merged branches (excluding main/master/develop)
gcleanup() {
  local current=$(current_git_branch)
  local branches=$(git branch --merged | grep -E -v '(main|master|develop|\*)')
  
  if [[ -z "$branches" ]]; then
    echo "No merged branches to delete"
    return 0
  fi
  
  echo "Merged branches to delete:"
  echo "$branches"
  echo ""
  read "REPLY?Delete these branches? (y/N): "
  
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "$branches" | xargs -n 1 git branch -d
    echo "Cleaned up merged branches"
  else
    echo "Cancelled"
  fi
}

# Git commit with conventional commit format
gconv() {
  local type="$1"
  local scope="$2"
  local message="$3"
  
  if [[ -z "$type" ]] || [[ -z "$message" ]]; then
    echo "Usage: gconv <type> [scope] <message>"
    echo "Types: feat, fix, docs, style, refactor, perf, test, chore"
    echo "Example: gconv feat auth add login functionality"
    echo "Example: gconv fix api fix user authentication bug"
    return 1
  fi
  
  # If only two arguments, treat second as message
  if [[ -z "$message" ]]; then
    message="$scope"
    scope=""
  fi
  
  local commit_msg
  if [[ -n "$scope" ]]; then
    commit_msg="${type}(${scope}): ${message}"
  else
    commit_msg="${type}: ${message}"
  fi
  
  git commit -m "$commit_msg"
}

# Git push with upstream tracking
gpush() {
  local branch=$(current_git_branch)
  if [[ -z "$branch" ]]; then
    echo "Not on a git branch"
    return 1
  fi
  
  # Check if upstream is set
  if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} &> /dev/null; then
    echo "Setting upstream for branch '$branch'"
    git push -u origin "$branch"
  else
    git push "$@"
  fi
}

# Interactive rebase helper
grebase() {
  local target="${1:-main}"
  echo "Interactive rebase onto $target"
  git rebase -i "$target"
}

# Squash commits
gsquash() {
  local count="${1:-2}"
  git rebase -i "HEAD~$count"
}

# Git worktree utilities
gworktree() {
  local action="$1"
  
  case "$action" in
    "list"|"l")
      git worktree list
      ;;
    "add"|"a")
      local branch="$2"
      if [[ -z "$branch" ]]; then
        echo "Usage: gworktree add <branch-name>"
        return 1
      fi
      local worktree_path="../$(basename $(pwd))-$branch"
      git worktree add "$worktree_path" "$branch"
      echo "Worktree created at: $worktree_path"
      ;;
    "remove"|"r")
      local branch="$2"
      if [[ -z "$branch" ]]; then
        echo "Usage: gworktree remove <branch-name>"
        return 1
      fi
      local worktree_path="../$(basename $(pwd))-$branch"
      git worktree remove "$worktree_path"
      ;;
    *)
      echo "Usage: gworktree {list|add|remove} [branch-name]"
      echo "  list (l)   - List all worktrees"
      echo "  add (a)    - Add new worktree for branch"
      echo "  remove (r) - Remove worktree for branch"
      ;;
  esac
}

# Git file history
ghistory() {
  if [[ -z "$1" ]]; then
    echo "Usage: ghistory <file>"
    return 1
  fi
  git log --follow --patch -- "$1"
}

# Git blame with better formatting
gblame() {
  if [[ -z "$1" ]]; then
    echo "Usage: gblame <file>"
    return 1
  fi
  git blame -b -w -C "$1"
}

# Find commits by message
gfind() {
  if [[ -z "$1" ]]; then
    echo "Usage: gfind <search-term>"
    return 1
  fi
  git log --grep="$1" --oneline
}

# Show commits by author
gauthor() {
  if [[ -z "$1" ]]; then
    echo "Usage: gauthor <author-name>"
    return 1
  fi
  git log --author="$1" --oneline
}

# Git stash utilities
gstash() {
  local action="$1"
  
  case "$action" in
    "save"|"s")
      local message="$2"
      if [[ -n "$message" ]]; then
        git stash save "$message"
      else
        git stash save "WIP: $(date)"
      fi
      ;;
    "list"|"l")
      git stash list
      ;;
    "show"|"sh")
      local stash="${2:-0}"
      git stash show -p "stash@{$stash}"
      ;;
    "apply"|"a")
      local stash="${2:-0}"
      git stash apply "stash@{$stash}"
      ;;
    "pop"|"p")
      local stash="${2:-0}"
      git stash pop "stash@{$stash}"
      ;;
    "drop"|"d")
      local stash="${2:-0}"
      git stash drop "stash@{$stash}"
      ;;
    "clear"|"c")
      echo "This will delete all stashes. Are you sure? (y/N)"
      read "REPLY?> "
      if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        git stash clear
        echo "All stashes cleared"
      fi
      ;;
    *)
      echo "Usage: gstash {save|list|show|apply|pop|drop|clear}"
      echo "  save (s)   - Save current changes to stash"
      echo "  list (l)   - List all stashes"
      echo "  show (sh)  - Show stash contents"
      echo "  apply (a)  - Apply stash without removing it"
      echo "  pop (p)    - Apply and remove stash"
      echo "  drop (d)   - Delete stash"
      echo "  clear (c)  - Delete all stashes"
      ;;
  esac
}

# Sync with remote (fetch and rebase)
gsync() {
  local branch=$(current_git_branch)
  local remote="${1:-origin}"
  local target_branch="${2:-$branch}"
  
  echo "Syncing $branch with $remote/$target_branch"
  git fetch "$remote" && git rebase "$remote/$target_branch"
}

# Git repository information
ginfo() {
  if ! is_git_repository; then
    echo "Not in a git repository"
    return 1
  fi
  
  local repo_root=$(git rev-parse --show-toplevel)
  local repo_name=$(basename "$repo_root")
  local branch=$(current_git_branch)
  local remote_url=$(git remote get-url origin 2>/dev/null || echo "No remote")
  local last_commit=$(git log -1 --pretty=format:"%h %s" 2>/dev/null || echo "No commits")
  local contributors=$(git shortlog -sn | wc -l | tr -d ' ')
  local total_commits=$(git rev-list --all --count 2>/dev/null || echo "0")
  
  echo "Repository Information"
  echo "======================"
  echo "Name: $repo_name"
  echo "Path: $repo_root"
  echo "Branch: $branch"
  echo "Remote: $remote_url"
  echo "Last commit: $last_commit"
  echo "Contributors: $contributors"
  echo "Total commits: $total_commits"
  echo ""
  echo "Status:"
  git status --porcelain | wc -l | tr -d ' ' | xargs -I {} echo "Changed files: {}"
} 