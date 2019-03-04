finish
" Enhanced jump list navigation commands

" fix error: E121: Undefined variable: l:fileJumpCapture
let g:EnhancedJumps_CaptureJumpMessages = 0

" nmap J <Plug>EnhancedJumpsOlder
" nmap K <Plug>EnhancedJumpsNewer

" " works:
" nmap J <Plug>EnhancedJumpsLocalOlder
" nmap K <Plug>EnhancedJumpsLocalNewer

" works:
nmap <c-u> <Plug>EnhancedJumpsLocalOlder
nmap <c-o> <Plug>EnhancedJumpsLocalNewer

nmap H <Plug>EnhancedJumpsRemoteOlder
nmap L <Plug>EnhancedJumpsRemoteNewer

" nmap <c-u> <Plug>EnhancedJumpsSwitchRemoteOlder
" nmap <c-o> <Plug>EnhancedJumpsSwitchRemoteNewer

" nmap ,{ <Plug>EnhancedJumpsSwitchOlder
" nmap ,} <Plug>EnhancedJumpsSwitchNewer

" nmap z; <Plug>EnhancedJumpsFarFallbackChangeOlder
" nmap z, <Plug>EnhancedJumpsFarFallbackChangeNewer
" nmap z; <Plug>EnhancedJumpsFarChangeOlder
" nmap z, <Plug>EnhancedJumpsFarChangeNewer

" To disable the special additional mappings: >
nmap <Plug>DisableEnhancedJumpsLocalOlder  <Plug>EnhancedJumpsLocalOlder
nmap <Plug>DisableEnhancedJumpsLocalNewer  <Plug>EnhancedJumpsLocalNewer
nmap <Plug>DisableEnhancedJumpsRemoteOlder <Plug>EnhancedJumpsRemoteOlder
nmap <Plug>DisableEnhancedJumpsRemoteNewer <Plug>EnhancedJumpsRemoteNewer

PackAdd inkarkat/vim-ingo-library
PackAdd inkarkat/vim-EnhancedJumps
