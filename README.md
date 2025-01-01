# **Dotfiles Configuration**

A personal setup for Vim, Neovim, and Tmux tailored for efficient development.

## **Installation**

Clone the repository and run the setup script:

```bash
git clone git@github.com:s06a/dotfiles.git
cd dotfiles
./setup.sh
```

## **Neovim Configuration**

![image](https://github.com/user-attachments/assets/de05ce6c-5977-4048-9ceb-e3e9da07a9d7)

### **Key Features**
- Powered by **LazyVim** for a modern and feature-rich experience.
- Integrated **LSP support** for Go:
  - Auto-completion
  - Go-to-definition
  - Hover documentation
- And much more.

## **Vim Configuration**

![Vim](https://github.com/user-attachments/assets/41b8a0ff-87d6-42cb-be8b-c6d099ee9094)

### **Key Features**
- Enhanced editing experience with plugins and shortcuts.
- Integrated **LSP support** for Go:
  - Auto-completion
  - Go-to-definition
  - Hover documentation
- **NERDTree** for efficient file exploration.

### **Shortcuts**
| Shortcut      | Action                                  |
|---------------|-----------------------------------------|
| `F1`          | Toggle **NERDTree** file explorer.      |
| `t` (in NERDTree) | Open file in a new tab.              |
| `:tabc`       | Close the current tab.                 |
| `f`           | Show hover information for functions.   |
| `gd`          | Go to the definition of a symbol.       |
| `Ctrl-o`      | Return to the previous location.        |

## **Tmux Configuration**

### **Key Features**
- Effortless navigation and pane management.
- Mouse support for scrolling (hold `Shift` to copy).
- Optimized for multitasking.

### **Shortcuts**
| Shortcut             | Action                                      |
|----------------------|---------------------------------------------|
| `` ` `` (Backtick)   | Tmux prefix key.                           |
| `Alt+Arrow`          | Navigate between panes.                    |
| `prefix + -`         | Split pane vertically.                     |
| `Mouse Scroll`       | Scroll output (hold `Shift` to copy).       |
