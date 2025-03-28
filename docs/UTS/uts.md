# **Scenario: UTS Namespace in Linux for Containers**

## **Summary**
The UTS (Unix Time-Sharing) namespace allows a container to have its own hostname, separate from the host system. This is useful in containerized environments where each container should have its own unique identity without affecting the host or other containers.

---

## **1. Checking the Current Hostname**
Before creating a new UTS namespace, check the system's current hostname:
```bash
hostname
```
- Displays the hostname of the system.

---

## **2. Changing the Hostname in the Default Namespace**
Modify the hostname (this affects the global namespace, so be cautious):
```bash
hostname uts1
```
- Sets the system-wide hostname to `uts1`.
- This change is visible system-wide until reboot or until it is changed again.

Check active UTS namespaces:
```bash
lsns --type uts
```
- Lists all currently active UTS namespaces.

Modify the hostname again:
```bash
hostname uts2
```
- Updates the hostname again at the system level.
- This still affects all processes in the default UTS namespace.

Open a new shell session:
```bash
bash
```
- This spawns a new shell but does not create a new UTS namespace, so changes to the hostname still affect the global namespace.

Check the hostname inside this shell:
```bash
hostname
```
- The output will still be `uts2` as no new namespace was created.

---

## **3. Creating a New UTS Namespace**
To isolate hostname changes, create a new UTS namespace:
```bash
unshare --uts /bin/bash
```
- `--uts` → Creates a new UTS namespace.
- `/bin/bash` → Opens a new shell within the isolated namespace.

Check the hostname inside the new namespace:
```bash
hostname
```
- Initially, it will match the host's current hostname (`uts2`).

Change the hostname inside the new namespace:
```bash
hostname container-uts
```
- This change is only visible inside the new UTS namespace.
- The host system and other namespaces remain unaffected.

Verify the change:
```bash
hostname
```
- Should now output `container-uts`.

Check active UTS namespaces again:
```bash
lsns --type uts
```
- A new UTS namespace should now be listed.

---

## **4. Verifying Hostname Isolation**
Open another terminal and check the hostname on the host system:
```bash
hostname
```
- The output should still be `uts2`, proving that changes in the UTS namespace do not affect the host.

Exit the namespace shell:
```bash
exit
```
- This returns to the default UTS namespace.

Check the hostname again:
```bash
hostname
```
- It should still be `uts2`, confirming that the container's hostname change was confined to the namespace.

---

## **Conclusion**
This setup demonstrates how UTS namespaces provide hostname isolation for containers. Changes made within a UTS namespace do not impact the host, ensuring that multiple containers can have distinct hostnames without interfering with each other.
