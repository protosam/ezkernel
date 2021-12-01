# ezkernel
It just builds a kernel.

```
$ make build
```

## Why?
Just needed a kernel that works with qemu for microvms that supported mounting a
9p file system at root.

## Todo
* Build the latest kernel. Dockerfiles are hard coded to build 5.15.
* Add a file with kernel version at /version.txt

