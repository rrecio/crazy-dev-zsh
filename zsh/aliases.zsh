# ~/.dotfiles/zsh/aliases.zsh
# Smart aliases and shortcuts

# Core utilities with better defaults
alias ls='ls -G'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Better alternatives (if available)
if command -v eza &> /dev/null; then
  alias ls='eza --icons'
  alias ll='eza -alF --icons --header --git'
  alias la='eza -A --icons'
  alias tree='eza --tree --icons'
fi

if command -v bat &> /dev/null; then
  alias cat='bat --paging=never'
  alias less='bat --paging=always'
fi

if command -v fd &> /dev/null; then
  alias find='fd'
fi

if command -v rg &> /dev/null; then
  alias grep='rg'
fi

if command -v dust &> /dev/null; then
  alias du='dust'
fi

if command -v procs &> /dev/null; then
  alias ps='procs'
fi

# Git aliases (enhanced)
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate --all'
alias gll='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge'
alias gp='git push'
alias gpu='git push -u origin HEAD'
alias gpl='git pull'
alias gr='git reset'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# Smart git aliases that adapt to context
alias gpr='git pull --rebase'
# Removed gsync alias - replaced by enhanced gsync function in git.zsh
alias gclean='git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d'
alias gwip='git add -A && git commit -m "WIP: work in progress"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dclean='docker system prune -af'

# Kubernetes
if command -v kubectl &> /dev/null; then
  alias k='kubectl'
  alias kgp='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgd='kubectl get deployments'
  alias kdp='kubectl describe pod'
  alias kds='kubectl describe service'
  alias kdd='kubectl describe deployment'
  alias kaf='kubectl apply -f'
  alias kdf='kubectl delete -f'
fi

# Package managers
alias b='brew'
alias bi='brew install'
alias bu='brew update && brew upgrade'
alias bc='brew cleanup'
alias bs='brew search'
alias binfo='brew info'

# Node.js
alias n='npm'
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nu='npm update'
alias nc='npm cache clean --force'

# pnpm
if command -v pnpm &> /dev/null; then
  alias p='pnpm'
  alias pi='pnpm install'
  alias pid='pnpm install --save-dev'
  alias pr='pnpm run'
  alias ps='pnpm start'
  alias pt='pnpm test'
  alias pu='pnpm update'
fi

# Yarn
if command -v yarn &> /dev/null; then
  alias y='yarn'
  alias ya='yarn add'
  alias yad='yarn add --dev'
  alias yr='yarn run'
  alias ys='yarn start'
  alias yt='yarn test'
  alias yu='yarn upgrade'
fi

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias serve='python3 -m http.server'

# macOS specific
alias flush='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
alias lscleanup='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'
alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* "delete from LSQuarantineEvent"'
alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'

# Network
alias ip='curl -4 icanhazip.com'
alias ip6='curl -6 icanhazip.com'
alias localip='ipconfig getifaddr en0'
alias ips='ifconfig -a | grep -o "inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)" | awk "{ sub(/inet6? (addr:)? ?/, \"\"); print }"'
alias ports='netstat -tuln'
alias listening='lsof -i -P | grep LISTEN'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias hosts='sudo $EDITOR /etc/hosts'
alias reload='source ~/.zshrc'

# Development shortcuts
alias server='python3 -m http.server 8000'
alias tunnel='ngrok http 3000'
alias c='cursor .'
alias o='open .'

# iOS/macOS Development
alias xcode='open -a Xcode'
alias xcselect='sudo xcode-select --switch'
alias xcversion='xcodebuild -version'
alias xcdevices='xcrun simctl list devices'
alias xcclean='xcodebuild clean'
alias xcbuild='smart_xcodebuild'
alias xctest='xcodebuild test'
alias xcarchive='xcodebuild archive'
alias xcrun='xcrun'

# iOS Simulator
alias sim='open -a Simulator'
alias simlist='xcrun simctl list devices'
alias simboot='xcrun simctl boot'
alias simshutdown='xcrun simctl shutdown all'
alias simreset='xcrun simctl erase all'
alias simapps='xcrun simctl listapps booted'

# Swift Package Manager
alias spm='swift package'
alias spmbuild='swift build'
alias spmtest='swift test'
alias spmclean='swift package clean'
alias spmupdate='swift package update'
alias spmresolve='swift package resolve'

# Swift
# Removed self-referential aliases: swift, swiftc, swiftformat, swiftlint work directly

# Flutter Development
# Removed self-referential alias: flutter works directly
alias fl='flutter'
alias fldoctor='flutter doctor'
alias flcreate='flutter create'
alias flrun='flutter run'
alias flbuild='flutter build'
alias fltest='flutter test'
alias flclean='flutter clean'
alias flpub='flutter pub'
alias fldevices='flutter devices'
alias flchannel='flutter channel'
alias flupgrade='flutter upgrade'
alias flanalyze='flutter analyze'

# Dart
# Removed self-referential alias: dart works directly
alias dartfmt='dart format'
alias dartanalyze='dart analyze'
alias dartrun='dart run'
alias darttest='dart test'
alias dartpub='dart pub'

# Android Development
# Removed self-referential aliases: adb, emulator, avdmanager, sdkmanager work directly

# Go Development
# Removed self-referential alias: go works directly
alias gob='go build'
alias gor='go run'
alias got='go test'
alias gom='go mod'
alias goi='go install'
alias goc='go clean'
alias gof='go fmt'
alias goget='go get'
alias gowork='go work'
alias gobench='go test -bench=.'
alias gocover='go test -cover'
alias gorace='go test -race'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dk='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drmi='docker rmi'
alias drun='docker run'
alias dexec='docker exec -it'
alias dlogs='docker logs'
alias dstop='docker stop'
alias drm='docker rm'
alias dprune='docker system prune'
alias dclean='docker system prune -af'
alias dbuild='docker build'
alias dpull='docker pull'
alias dpush='docker push'
alias dtag='docker tag'

# Docker Compose
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcr='docker-compose restart'
alias dcl='docker-compose logs'
alias dce='docker-compose exec'
alias dcps='docker-compose ps'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kga='kubectl get all'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kdesc='kubectl describe'
alias klogs='kubectl logs'
alias kexec='kubectl exec -it'
alias kport='kubectl port-forward'
alias kctx='kubectx'
alias kns='kubens'

# AWS CLI
# Removed self-referential alias: aws works directly
alias awsls='aws s3 ls'
alias awscp='aws s3 cp'
alias awssync='aws s3 sync'
alias awsprofile='aws configure list-profiles'
alias awswhoami='aws sts get-caller-identity'
alias awsregions='aws ec2 describe-regions --output table'

# Heroku
alias h='heroku'
alias hps='heroku ps'
alias hlogs='heroku logs --tail'
alias hconfig='heroku config'
alias hrun='heroku run'
alias hopen='heroku open'
alias hdeploy='git push heroku main'

# Node.js & JavaScript Development
alias n='node'
# Removed self-referential aliases to prevent parse conflicts
# Commands: node, npm, yarn, pnpm, bun, deno work directly
alias pn='pnpm'

# NPM shortcuts
alias ni='npm install'
alias nis='npm install --save'
alias nid='npm install --save-dev'
alias nig='npm install --global'
alias nu='npm uninstall'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nd='npm run dev'
alias nw='npm run watch'
alias nl='npm run lint'
alias nf='npm run format'
alias nc='npm run clean'
alias nup='npm update'
alias nout='npm outdated'

# Yarn shortcuts
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yag='yarn global add'
alias yr='yarn remove'
alias yun='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yd='yarn dev'
alias yw='yarn watch'
alias yl='yarn lint'
alias yf='yarn format'
alias yup='yarn upgrade'
alias yout='yarn outdated'

# PNPM shortcuts
alias pi='pnpm install'
alias pa='pnpm add'
alias pad='pnpm add -D'
alias pag='pnpm add -g'
alias pr='pnpm remove'
alias prun='pnpm run'
alias ps='pnpm start'
alias pt='pnpm test'
alias pb='pnpm build'
alias pd='pnpm dev'
alias pw='pnpm watch'
alias pl='pnpm lint'
alias pf='pnpm format'
alias pup='pnpm update'
alias pout='pnpm outdated'

# TypeScript
alias ts='typescript'
# Removed self-referential aliases: tsc, tsx work directly
alias tsnode='ts-node'

# Common JavaScript frameworks and tools
alias react='npx create-react-app'
alias next='npx create-next-app'
alias vue='npx @vue/cli create'
alias nuxt='npx create-nuxt-app'
alias vite='npx create-vite'
alias astro='npx create-astro'
alias remix='npx create-remix'
alias svelte='npx create-svelte'
alias angular='npx @angular/cli new'
alias nest='npx @nestjs/cli new'
alias express='npx express-generator'

# Development servers
alias serve='npx serve'
alias live='npx live-server'
alias http='npx http-server'

# Testing
alias jest='npx jest'
alias vitest='npx vitest'
alias cypress='npx cypress'
alias playwright='npx playwright'

# Build tools
alias webpack='npx webpack'
alias rollup='npx rollup'
alias vite='npx vite'
alias turbo='npx turbo'

# Code quality
alias eslint='npx eslint'
alias prettier='npx prettier'
alias tslint='npx tslint'

# Python AI Development
alias py='python3'
alias pip='pip3'
alias jupyter='jupyter lab'
# Removed self-referential aliases: ipython, conda, mamba work directly

# AI Model Management
alias hflogin='huggingface-hub login'
alias hfdownload='huggingface-hub download'
# Removed self-referential aliases: ollama, cursor work directly

# Cursor IDE
alias cudit='cursor'

# Quick development shortcuts
alias ios='ios_sim'
alias xcbuild='smart_xcodebuild'
alias aienv='ai_env'
alias swiftnew='swift_new'
alias analyze='xc_analyze'
alias flnew='flutter_new'
alias flanalyze='flutter_analyze'
alias flhot='flutter_hot'
alias flbuild='flutter_build_smart'
alias fldeps='flutter_deps'
alias device='device_manager'
alias droid='android_emulator'
alias gonew='go_new'
alias gorun='go_run_smart'
alias deploy='smart_deploy'
alias kube='k8s_manager'
alias dock='docker_manager'
alias jsnew='js_new'
alias jsrun='js_run_smart'
alias jstest='js_test_smart'
alias jsbuild='js_build_smart'
alias jsdeps='js_deps_manager'

# Quick navigation
alias projects='cd ~/Projects'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop'
alias documents='cd ~/Documents'

# Process management
alias psg='ps aux | grep'
alias top='htop'
alias topc='htop -s PERCENT_CPU'
alias topm='htop -s PERCENT_MEM'

# Archive operations
alias tarls='tar -tzf'
alias untar='tar -xf'
alias targz='tar -czf'
alias untargz='tar -xzf'

# JSON/XML processing
if command -v jq &> /dev/null; then
  alias json='jq .'
fi

# System info
alias sysinfo='system_profiler SPSoftwareDataType SPHardwareDataType'
alias diskusage='df -h'
alias meminfo='vm_stat'
alias cpuinfo='sysctl -n machdep.cpu.brand_string'

# SSH
alias ssh-keygen-ed25519='ssh-keygen -t ed25519 -C'
alias ssh-copy='pbcopy < ~/.ssh/id_ed25519.pub'

# Time tracking
alias timer='echo "Timer started. Press Ctrl+C to stop." && date && time cat'

# ==========================================
# AI-Powered Development Aliases (Ollama)
# ==========================================

# Ollama model management
alias om='ollama_manager'
alias oml='ollama_manager list'
alias omd='ollama_manager download'
alias omr='ollama_manager remove'
alias omi='ollama_manager info'
alias oms='ollama_manager serve'
alias omstop='ollama_manager stop'
alias omps='ollama_manager status'
alias popular='ollama_manager models'

# AI development shortcuts
alias ai='ai_env'
alias aienv='ai_env'
alias explain='ai_explain'
alias review='ai_review'
alias commit='ai_commit'
alias docs='ai_docs'
alias test='ai_test'
alias debug='ai_debug'
alias translate='ai_translate'
alias refactor='ai_refactor'
alias init='ai_init'

# Quick AI commands with default models
alias expl='ai_explain'  # Explain code
alias rev='ai_review'    # Review code
alias doc='ai_docs'      # Generate docs
alias bug='ai_debug'     # Debug errors
alias ref='ai_refactor'  # Refactoring suggestions

# Model-specific shortcuts
alias llama='ollama run llama2'
alias code='ollama run codellama'
alias coder='ollama run deepseek-coder'
alias mistral='ollama run mistral'
alias wizard='ollama run wizard-coder'

# Quick model downloads
alias getllama='ollama pull llama2'
alias getcode='ollama pull codellama'
alias getcoder='ollama pull deepseek-coder'
alias getmistral='ollama pull mistral'
alias getwizard='ollama pull wizard-coder'

# Language-specific AI models
alias pycode='ollama run codellama:python'
alias javacode='ollama run codellama:java'
alias rustcode='ollama run codellama:rust'
alias gocode='ollama run codellama:golang'

# AI-powered development workflows
alias aicommit='git add . && ai_commit && git commit -F /dev/stdin'
alias aireview='ai_review . | less'
alias aidocs='ai_docs . && open README.md'
alias aitest='find . -name "*.py" -o -name "*.js" -o -name "*.go" | head -5 | xargs -I {} ai_test {}'

# Error debugging aliases
alias errorlog='tail -f /var/log/system.log | ai_debug -'
alias npmlog='npm run build 2>&1 | ai_debug -'
alias pythonlog='python3 -u main.py 2>&1 | ai_debug -'

# Code translation shortcuts
alias py2js='ai_translate'  # Will require params
alias js2py='ai_translate'  # Will require params
alias go2py='ai_translate'  # Will require params
alias py2go='ai_translate'  # Will require params

# AI project initialization
alias newweb='ai_init web'
alias newapi='ai_init api'
alias newcli='ai_init cli'
alias newml='ai_init ml'
alias newdata='ai_init data'

# Ollama server management
alias startai='ollama serve > /dev/null 2>&1 &'
alias stopai='pkill -f ollama'
alias restartai='stopai && sleep 2 && startai'
alias aimodels='ollama list'
alias aistatus='pgrep -f ollama && echo "✅ Ollama running" || echo "❌ Ollama stopped"'

# AI-enhanced development aliases
alias smartcommit='git diff --cached | ai_debug - && ai_commit'
alias codereview='git diff HEAD~1 | ai_review -'
alias explainlast='git show HEAD --name-only | head -1 | xargs ai_explain'
alias docme='ai_docs . && echo "📝 Documentation updated"'

# Quick AI explanations for common files
alias explainpkg='ai_explain package.json'
alias explainreq='ai_explain requirements.txt'
alias explainmake='ai_explain Makefile'
alias explaindocker='ai_explain Dockerfile'
alias explainread='ai_explain README.md'

# AI-powered code quality
alias quality='ai_review . && ai_refactor . readability'
alias security='ai_review . && ai_refactor . security'
alias performance='ai_refactor . performance'
alias testability='ai_refactor . testing'

# Multi-language AI support
alias aipy='AI_MODEL_DEFAULT=codellama:python ai_env python'
alias aijs='AI_MODEL_DEFAULT=codellama:javascript ai_env javascript'
alias aigo='AI_MODEL_DEFAULT=codellama:golang ai_env go'
alias airust='AI_MODEL_DEFAULT=codellama:rust ai_env rust'
alias aijava='AI_MODEL_DEFAULT=codellama:java ai_env java'

# AI chat shortcuts for different purposes
alias codechat='ollama run deepseek-coder'
alias helpchat='ollama run llama2'
alias fastchat='ollama run mistral'
alias pythonchat='ollama run codellama:python'

# Development workflow with AI
alias workflowjs='ai_env javascript && ai_docs . && ai_test src/'
alias workflowpy='ai_env python && ai_docs . && ai_test src/'
alias workflowgo='ai_env go && ai_docs . && ai_test .'

# AI model size management
alias smallmodels='echo "Installing small models..." && ollama pull codellama:7b && ollama pull mistral:7b'
alias bigmodels='echo "Installing large models..." && ollama pull codellama:34b && ollama pull llama2:70b'

# Quick AI assistance
alias askcode='echo "Ask me about your code..." && ollama run deepseek-coder'
alias askpy='echo "Python questions..." && ollama run codellama:python'
alias askjs='echo "JavaScript questions..." && ollama run codellama:javascript'
alias askhelp='echo "General help..." && ollama run llama2' 