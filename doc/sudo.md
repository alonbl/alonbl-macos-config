# sudo integration

```sh
brew install pam-reattach
```

`/etc/pam.d/sudo_local`:

```
auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
auth       sufficient     pam_tid.so
```
