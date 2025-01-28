## To Do

- set_terminal_data is called every time
    * [ ] It should only be called when it needs to be
- break open into smaller functions

## Doing

- check if collection/env files exist?
    * [ ] throw error if files are not present
    * [ ] taskell.nvim has examples

## Done

- toggle posting might not be needed
- throw error/notification if posting is not installed
    * [x] failed installation validation should return early
- make functions local
- pull    quit command from posting config
    * [x] parse file location from posting locate config
    * [x] get content
    * [x] return quit command
    * [x] set quit command to <C-C> if no command is set, or no file is found 
- create lisence
- complete readme
- enable opts for end users
    * [x] create setup function
    * [x] move opts out of open
    * [x] force over ride opts with user ops
    * [x] support keybinds, should take an array of key binds and iterate over that
- need to support multiple buffers for multiple envs/collections
    * [x] Use the args as table keys
    * [x] if the table key doesn't exit, fall back to a defalt win, buf, and job id
