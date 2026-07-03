# Virt

## Installation

```
brew install --cask utm
```

Use native virtualisation if you do not need USB redirection.
Use qemu arm64 virtualisation if you need USB redirection.

## Shared

In these examples we use `share` as exported directory from host.

### native

`/etc/fstab`:

```
share /mnt/share virtiofs auto 0 0
```

### qemu

`/etc/fstab`:

```
share /mnt/share 9p trans=virtio,version=9p2000.L,access=any,dfltuid=1000,dfltgid=1000,rw,_netdev,nofail,auto 0 0
```
