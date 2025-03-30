# Time / IPC / Cgroup Namespaces in Linux for Containers

## Introduction
Namespaces in Linux provide isolation of system resources for containers. The `time`, `IPC`, and `cgroup` namespaces allow fine-grained control over system behavior.

---

## IPC Namespace
The IPC (Inter-Process Communication) namespace provides isolation for IPC objects such as message queues, shared memory, and semaphores.

### List existing IPC objects
```sh
ipcs
```

### Create an IPC object
#### Create a shared memory segment
```sh
ipcmk -M 10
```
#### Create a message queue
```sh
ipcmk -Q
```

### Isolate IPC objects using IPC namespace
```sh
unshare --ipc /bin/bash
```
Now, any IPC objects created inside this namespace are isolated from the parent namespace.

---

## Cgroup Namespace
Cgroups (Control Groups) allow restriction and allocation of system resources like CPU, memory, I/O, and network.

### Understanding Cgroup Versions
- **Cgroup v1:** Uses a hierarchy-based approach where each resource type (controller) is in a separate hierarchy.
- **Cgroup v2:** Uses a unified hierarchy where all resources are managed together.

### Components of Cgroups
1. **Core:** Manages the overall hierarchy and process grouping.
2. **Controller:** Defines specific resource limits (e.g., CPU, memory, I/O).

### Example: Restricting Process Count Using Cgroups
#### Create a script that spawns multiple processes
```sh
vim sleep.sh
```
```sh
#!/bin/bash
for i in {1..10}; do
    sleep 100 &
done
```
#### Make the script executable and run it
```sh
chmod +x sleep.sh
./sleep.sh
```
#### Verify running processes
```sh
ps -C sleep
```

### Restrict the number of concurrent processes
```sh
cd /sys/fs/cgroup/
sudo mkdir cfs
cd cfs
```

#### List available controllers
```sh
ls
```

#### Check current process limits
```sh
cat pids.max
```

#### Set process limit to 20
```sh
sudo vim pids.max
# Enter "20" and save the file
```

#### Add the current shell's PID to the cgroup
```sh
echo $$ > cgroup.procs
```

#### Verify restriction
```sh
./sleep.sh
```
If the limit is reached, you will get an error:
```sh
retry Resource temporarily unavailable
```

---

## Time Namespace
The time namespace allows containers to have their own clock settings independent of the host.

### Check system time
```sh
date
```

### Isolate the time namespace
```sh
unshare --time /bin/bash
```

### Modify the system clock within the namespace
```sh
date --set "2025-01-01 12:00:00"
```

### Verify the new time inside the namespace
```sh
date
```

### Exit the namespace and check the global system time
```sh
exit
date
```
The system time outside remains unchanged.

---

These namespaces are essential for creating isolated container environments, ensuring that each container operates independently from the host and other containers.
