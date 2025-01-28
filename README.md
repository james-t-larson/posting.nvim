<h1 align="center">posting.nvim</h1>

<p align="center">
  A Neovim plugin to seamlessly integrate <a href="https://posting.sh">Posting</a>, the terminal-based HTTP client, into your workflow.
This plugin allows you to launch and manage Posting directly within Neovim, providing an efficient way to handle HTTP requests and responses without leaving your editor. 
</p>


---

## Features

- Open Posting directly in a floating window inside Neovim.
- Configure custom keybinds for launching Posting with specific arguments.
- Customizable UI settings such as border style, window size, and positioning.

### **Launch Multiple Collections or Environments**

One of the key benefits of `posting.nvim` is the ability to seamlessly switch between multiple Posting collections or environments using custom keybinds. For example, you can set up separate commands for a staging environment and a testing environment and switch between them without leaving Neovim.

#### **Example Use Case**
Imagine you have two collections:
- **`posting-collection` with `staging.env`**
- **`posting-collection` with `testing.env`**

You can configure `posting.nvim` to set up keybinds like this:
- `<leader>pd`: Launch Posting with the staging environment.
- `<leader>pt`: Launch Posting with the testing environment.

This setup allows you to toggle between environments quickly and efficiently.

#### **Switching Between Environments**
Once the keybinds are set up, you can seamlessly switch between environments:
- Press `<leader>pd` to open the staging environment.
- Press `<leader>pt` to open the testing environment.

The plugin dynamically handles the floating window for each environment and ensures that switching between them is fast and intuitive. Each environment launches its own terminal buffer, so you can manage separate sessions independently.

---

## Requirements

- [Posting](https://posting.sh) (ensure it's installed via `uv`, `pipx`, or other supported methods).
- Neovim 0.8+ with Lua support.

---

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

Add the following configuration to your LazyVim setup:

```lua
return {
  {
    "james-t-larson/posting.nvim",
    config = function()
      require("posting").setup({
        keybinds = {
          {
            binding = "<leader>pd",
            command = ":OpenPosting --collection posting-collection --env posting-envs/staging.env<CR>",
            desc = "Open Posting with dev env",
          },
        },
        ui = {
          border = "rounded", -- Border style for the Posting window
          width = 0.95,       -- Width of the window relative to the editor
          height = 0.87,      -- Height of the window relative to the editor
          x = 0.5,            -- Horizontal center
          y = 0.5,            -- Vertical center
        },
      })
    end,
  },
}
```

---

## Usage

### Commands

- `:OpenPosting [args]`: Launch Posting with optional arguments.
  - Example: `:OpenPosting --collection my-collection --env my-env.env`
- `:ClosePosting`: Close the currently open Posting interface.

### Default Keybinds

- `<leader>p`: Opens the Posting interface. You can customize this binding or add more specific ones.

Example custom keybinds configuration in `setup`:

```lua
require("posting").setup({
  keybinds = {
    {
      binding = "<leader>pd",
      command = ":OpenPosting --collection posting-collection --env posting-envs/staging.env<CR>",
      desc = "Open Posting with dev environment",
    },
    {
      binding = "<leader>pt",
      command = ":OpenPosting --collection testing-collection --env posting-envs/testing.env<CR>",
      desc = "Open Posting with testing environment",
    },
  },
})
```

---

## Configuration

### Setup Options

Here are the options available for `require("posting").setup()`:

| Option          | Type        | Default          | Description                                                                 |
|------------------|-------------|------------------|-----------------------------------------------------------------------------|
| `keybinds`       | `Keybinds`  | `{}`             | A list of custom keybinds to trigger Posting commands.                      |
| `ui.border`      | `string`    | `"rounded"`      | Border style for the Posting window. Options: `"none"`, `"single"`, `"double"`, etc. |
| `ui.width`       | `number`    | `0.95`           | Width of the Posting window relative to the editor.                         |
| `ui.height`      | `number`    | `0.87`           | Height of the Posting window relative to the editor.                        |
| `ui.x`           | `number`    | `0.5`            | Horizontal position of the Posting window (relative to editor).             |
| `ui.y`           | `number`    | `0.5`            | Vertical position of the Posting window (relative to editor).               |

---

## Example Configuration

```lua
require("posting").setup({
  keybinds = {
    {
      binding = "<leader>ps",
      command = ":OpenPosting --collection shared-collection --env shared-envs/prod.env<CR>",
      desc = "Open Posting with shared production environment",
    },
  },
  ui = {
    border = "rounded",
    width = 0.9,
    height = 0.8,
    x = 0.5,
    y = 0.5,
  },
})
```

---

## FAQ

### How do I install Posting?
Refer to the [official Posting installation guide](https://posting.sh/guide#installation). A quick way to install Posting is via `uv`:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install --python 3.12 posting
```

### What happens if Posting is not installed?
The plugin will show an error message in Neovim and gracefully terminate the attempt to launch Posting.

### Can I customize the quit command in Posting?
Yes, the plugin reads the `quit:` value from your Posting configuration file (`posting locate config`). If no custom quit command is found, `<C-C>` is used as the default.

---

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests on the [GitHub repository](https://github.com/your-username/posting.nvim).

---

## License

This plugin is licensed under the [MIT License](LICENSE).

---

## Acknowledgments

- [Posting](https://posting.sh) for the powerful HTTP client.
- [Neovim](https://neovim.io) for the extensible text editor.

