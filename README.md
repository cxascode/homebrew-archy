# homebrew-archy

A [Homebrew](https://brew.sh) tap for [Archy](https://developer.genesys.cloud/devapps/archy/), Genesys Cloud's YAML processor.

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

The Archy binary is not signed or notarized. macOS may block it the first time you run it.

Either allow it in **System Settings → Privacy & Security**, or remove the quarantine attribute:

```bash
xattr -dr com.apple.quarantine "$(brew --caskroom)/archy"
```

This cask also requires [Rosetta](https://support.apple.com/en-us/102527) on Apple Silicon Macs.

## Updates

This tap tracks the latest Archy release from Genesys. A GitHub Actions workflow checks [versions.json](https://sdk-cdn.mypurecloud.com/archy/versions.json) daily and updates the cask when a new version is published.

To upgrade manually:

```bash
brew update
brew upgrade --cask archy
```

## License

MIT — see [LICENSE](LICENSE).
