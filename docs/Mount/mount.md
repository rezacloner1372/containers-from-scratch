# **Scenario: Mount Namespace in Linux for Containers**

## **Summary**
The mount namespace provides an isolated filesystem view for processes. This means changes to mount points in one namespace do not affect other namespaces. This is useful in containers, allowing each container to have its own filesystem and mount points.

---

## **1. Introduction to Mount and Filesystems**
List the available filesystems supported by the kernel:
```bash
cat /proc/filesystems
```
- Displays a list of all supported filesystem types.

To list mounted filesystems and their mount points:
```bash
mount
```
Or use:
```bash
findmnt
```
- `mount` → Shows all mounted filesystems.
- `findmnt` → Provides a tree view of mounted filesystems.

---

## **2. Checking Block Devices and Mount Points**
To display information about block devices and their associated mount points:
```bash
lsblk
```
- Lists all block devices along with their mount points.
- Device names such as `sda` refer to physical disks, while `sda1` refers to partitions.

To check available block devices:
```bash
ls /dev/
```
- Lists all devices under `/dev`.

---

## **3. Mounting and Unmounting a Device**
To mount a device to a directory:
```bash
sudo mkdir -p /mnt/16gb-usb
sudo mount /dev/sda1 /mnt/16gb-usb/
```
- `mkdir -p` → Creates the mount point directory if it doesn't exist.
- `mount` → Attaches the device `/dev/sda1` to `/mnt/16gb-usb/`.

To unmount the device:
```bash
sudo umount /mnt/16gb-usb/
```
- `umount` → Detaches the filesystem from the directory.

---

## **4. Checking Disk Space Usage**
To view disk usage:
```bash
df -h
```
- `df` → Displays disk space usage.
- `-h` → Human-readable format.

---

## **5. Demo: Using Alpine Root Filesystem with Mount Namespace**
### **5.1 Download Alpine Linux Root Filesystem**
```bash
uname -a
```
- Displays system information.

Download the Alpine root filesystem:
```bash
curl -O https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-minirootfs-3.21.2-x86_64.tar.gz
```
- `curl -O` → Downloads the specified file and saves it with its original name.

Extract the downloaded tarball:
```bash
tar -xvf alpine-minirootfs-3.21.2-x86_64.tar.gz
```
- `tar -xvf` → Extracts the tarball.

### **5.2 Prepare Alpine Root Filesystem**
Create a directory for the Alpine root filesystem:
```bash
mkdir -p alpine-rootfs
```
Extract the tarball to the newly created directory:
```bash
tar -xvf alpine-minirootfs-3.21.2-x86_64.tar.gz -C alpine-rootfs/
```
Move into the Alpine root directory:
```bash
cd alpine-rootfs/
touch test
```

---

## **6. Creating a New Mount Namespace**
Create a new namespace and enter a bash shell:
```bash
unshare --uts --pid --fork /bin/bash
```
- `--uts` → Isolates the hostname.
- `--pid` → Isolates process IDs.
- `--fork` → Forks a new shell.

Check the contents of the root directory:
```bash
ls /
```
- Lists the files and directories inside the new namespace.

Exit the namespace:
```bash
exit
```

### **6.1 Enter Alpine Root Filesystem in a New Namespace**
```bash
unshare --uts --pid --fork chroot $HOME/alpine-rootfs /bin/sh
```
- `chroot` → Changes the root directory to the specified directory.
- `$HOME/alpine-rootfs` → Points to the extracted Alpine root filesystem.

Switch to the root directory and list files:
```bash
cd /
ls
```
- You are now inside the Alpine filesystem.

Try using `apk` (Alpine package manager):
```bash
apk --help
```
- Alpine uses `apk` instead of `apt`.

---

## **7. Fixing /proc for Correct PID Visibility**
By default, `ps -ef` may not work correctly because `/proc` is still pointing to the host system.
Mount the `proc` filesystem to fix this:
```bash
mount -t proc proc ./proc -o nosuid,nodev,noexec
```
- `-t proc` → Specifies that the `proc` filesystem should be mounted.
- `nosuid,nodev,noexec` → Security options to restrict execution and device usage.

Check running processes:
```bash
ps -ef
```
- Now `ps` should show processes within the namespace.

---

## **8. Mounting Using Bind Mounts**
To create a bind mount:
```bash
mkdir -p /mnt/test
mount --bind /usr/bin /mnt/test
```
- `--bind` → Binds an existing directory to another location.

List the contents of the bind mount:
```bash
ls -lah /mnt/test
```
- Displays the content of `/usr/bin` now available at `/mnt/test`.

---

## **Conclusion**
This scenario demonstrates how to create a mount namespace, isolate the filesystem, and use `chroot` to run an alternative root filesystem. Additionally, it shows how to bind mount directories and properly manage `/proc` in a new namespace to maintain process visibility.
