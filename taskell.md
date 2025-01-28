## To Do

- need to support multiple buffers for multiple envs/collections
- create lisence
- complete readme
- check if collection/env files exist?
    * [ ] throw error if files are not present
    * [ ] taskell.nvim has examples
- set collection and env used in header
    * [ ] Only support one env at a time for now

## Doing

- enable opts for end users
    * [ ] create setup function
    * [ ] move opts out of open
    * [ ] force over ride opts with user ops

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
