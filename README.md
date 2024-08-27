# betterenv

Automatically load `.env` file when you `cd` into any directory of a project.

Works even if you didn't `cd` into the root directory of the project but a descendant of it.

This script will automatically detect the first ancestor directory with a `.env` file and load it.

## Installation

1. Clone this repository into `$ZSH_CUSTOM/plugins/` (by default
   `~/.oh-my-zsh/custom/plugins/`)

   ```bash
   git clone https://github.com/hezicyan/betterenv ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/betterenv
   ```

2. Add the plugin to the list of plugins for Oh My Zsh to load (inside
   `~/.zshrc`):

   ```bash
   plugins=(
     # other plugins...
     betterenv
   )
   ```

3. Start a new terminal session

## Usage

Create a `.env` file in your project root directory and do your stuff there. Then next time when you `cd` into this project, this `.env` file will automatically be sourced.

## Configuration

### ZSH_BETTERENV_FILE

You can also modify the name of the file to be sourced with the variable `ZSH_BETTERENV_FILE`.  If the variable isn't set, it will default to be set as `.env`. For example, this will make the plugin look for files named `.dotenv` and load them:

```bash
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_BETTERENV_FILE=.dotenv
```

### ZSH_BETTERENV_ALLOWED_LIST, ZSH_BETTERENV_DISALLOWED_LIST

The default behavior of the plugin is to always ask whether to source a dotenv file. There's a **Y**es, **N**o, **A**lways and N**e**ver option. If you choose Always, the directory of the .env file will be added to an allowed list; if you choose Never, it will be added to a disallowed list. If a directory is found in either of those lists, the plugin won't ask for confirmation and will instead either source the .env file or proceed without action respectively.

The allowed and disallowed lists are saved by default in `$ZSH_CACHE_DIR/betterenv-allowed.list` and `$ZSH_CACHE_DIR/betterenv-disallowed.list` respectively. If you want to change that location, change the `$ZSH_BETTERENV_ALLOWED_LIST` and `$ZSH_BETTERENV_DISALLOWED_LIST` variables, like so:

```bash
# in ~/.zshrc, before Oh My Zsh is sourced:
ZSH_BETTERENV_ALLOWED_LIST=/path/to/betterenv/allowed/list
ZSH_BETTERENV_DISALLOWED_LIST=/path/to/betterenv/disallowed/list
```

The file is just a list of directories, separated by a newline character. If you want to change your decision, just edit the file and remove the line for the directory you want to change.

NOTE: if a directory is found in both the allowed and disallowed lists, the disallowed list takes preference, *i.e.* the .env file will never be sourced.

## Acknowledgments

This project references and builds upon the [dotenv](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dotenv) plugin of oh-my-zsh, which is licensed under the MIT License.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.
