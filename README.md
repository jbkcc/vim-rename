# rename.vim

A Vim plugin for renaming and moving files without leaving the editor.

## What can it do?

- **Rename files** in place within their current directory
- **Move files** to different directories with automatic directory creation
- **Refuse to overwrite existing files** with a `!` flag to force destruction

## Commands

### `:FMove[!] {path}`
Move the current file to `{path}`. Directories are created as needed.

Add `!` to overwrite an existing file at the destination.

```vim
:FMove some/other/file.txt
:FMove /absolute/path/to/file.txt
:FMove! existing.txt
```

### `:FRename[!] {filename}`
Rename the current file to `{filename}`, keeping it in the same directory.

Add `!` to overwrite an existing file.

```vim
:FRename new.txt
:FRename! existing.txt
```

## Requirements

- Vim 8.0+
- `nocompatible` mode

## License

Same terms as Vim itself (see `:help license`)

## LLM Disclosure

I used Claude to start the implementation and documentation, then edited and
tested manually.
