# homebrew-archy

[Homebrew](https://brew.sh) Tap for [Archy](https://developer.genesys.cloud/devapps/archy/), Genesys Cloud's YAML processor.

## Install

```bash
brew tap cxascode/archy
brew install --cask archy
```

Verify the installation:

```bash
archy --version
```

## First run on macOS

This binary is not signed or notarized. macOS may block it the first time you run it.

Either allow it in **System Settings → Privacy & Security**, or remove the quarantine attribute:

```bash
xattr -dr com.apple.quarantine "$(brew --caskroom)/archy"
```

This cask also requires [Rosetta](https://support.apple.com/en-us/102527) on Apple Silicon Macs.
