# **Dotfiles Configuration**

A personal setup for Vim and Tmux tailored for efficient development.

 

## **Installation**

Clone the repository and run the setup script:

```bash
git clone git@github.com:s06a/dotfiles.git
cd dotfiles
./setup.sh
```

 

## **Vim Configuration**

![image](https://github.com/user-attachments/assets/c91a7b0c-c44a-418e-a56f-ca8e83142afe)

### **Key Features**
- Enhanced editing experience with plugins and custom shortcuts.
- Integrated **LSP support** for Go, including:
  - Auto-completion
  - Go-to-definition
  - Hover documentation
- NERDTree for easy file exploration.

### **Shortcuts**
| Shortcut      | Action                                  |
|---------------|-----------------------------------------|
| `F1`          | Toggle **NERDTree** file explorer.      |
| `t` (in NERDTree) | Open files in a new tab.              |
| `:tabc`       | Close the currently opened tab.         |
| `h`           | Show hover information for functions.   |
| `gd`          | Jump to the definition of a symbol.     |
| `Ctrl-o`      | Return to the previous location.        |

 

## **Tmux Configuration**

### **Key Features**
- Streamlined navigation between panes.
- Easy splitting of panes for multitasking.
- Mouse support for scrolling (use `Shift` for copying).

### **Shortcuts**
| Shortcut             | Action                                      |
|----------------------|---------------------------------------------|
| `` ` `` (Backtick)   | Tmux prefix key.                           |
| `Alt+Arrow`          | Navigate between panes.                    |
| `prefix + |`         | Split pane horizontally.                   |
| `prefix + -`         | Split pane vertically.                     |
| `Mouse Scroll`       | Scroll through output (hold `Shift` to copy). |

 

This configuration provides a seamless workflow for Vim and Tmux. Feel free to contribute or adapt it to suit your development needs!
