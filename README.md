# mousebrains/tap

Homebrew formulae for mousebrains projects.

## SerialTerm

[SerialTerm](https://github.com/mousebrains/SerialTerm) is a macOS serial terminal for
instruments on USB-serial adapters, with built-in ZMODEM, XMODEM and YMODEM.

```sh
brew install --HEAD mousebrains/tap/serialterm
```

Until SerialTerm's first tagged release the formula only builds the latest `main`, so
`--HEAD` is needed.

This builds `SerialTerm.app` on your Mac, so macOS doesn't block it the way it blocks an
unnotarized download. It needs macOS 15 or later and Xcode 26 or the Command Line Tools 26
or later (`xcode-select --install`).

- **Start**: `serialterm`, or link the app into /Applications:
  `ln -sf "$(brew --prefix serialterm)/SerialTerm.app" /Applications/SerialTerm.app`
- **Update**: `brew upgrade --fetch-HEAD serialterm` (without `--fetch-HEAD`, brew doesn't check `main`)
- **Remove**: `brew uninstall serialterm`, and delete the /Applications link if you made one.
