# Calamares Package

> Calamares is a distribution-independent system installer, with an advanced partitioning
> feature for both manual and automated partitioning operations. Calamares is designed to
> be customizable by distribution maintainers without need for cumbersome patching,
> thanks to third party branding and external modules support.

PKGBUILD for building the Calamares package with custom configuration.

## Building the package

```
makepkg
```

## Signing the package

```
gpg --detach-sign *.tar.zst
```