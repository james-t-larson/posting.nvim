## Considering

- Create the collection/env if it doesn't exist?

## Roadmap

- Add projects and absolute paths to opts
    > This is to allow uses to be in multiple projects, but still open posting with the correct collection. This should mitigate the problem of creating a bunch of keymaps to cover multiple projects. Users should be able to associate the front end with the backend and launch the same collection from eother project

## To Do

- set_terminal_data is called every time
    * [ ] It should only be called when it needs to be
- break open into smaller functions
- Add posting.nvim to awesome-neovim
    > https://github.com/rockerBOO/awesome-neovim

## Doing

- Add a demo gif
    * [ ] install a plugin to show what keys I am press
    * [ ] create fake collections for a public api

## Done

- check if collection/env files exist
    * [x] throw error if files are not present
    * [x] do not launch window if args cannot be validated 
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
