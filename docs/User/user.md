# **Scenario: User Namespace in Linux for Containers**

## **Summary**
User namespaces allow processes to have different user IDs inside a container than they do on the host system. This enables privilege isolation, where a process inside a container can run as `root` while being mapped to an unprivileged user on the host.

---

## **1. Checking User Information**
Before creating a new user namespace, check the current user information:
```bash
id
```
- Displays the user ID (UID), group ID (GID), and additional group memberships of the current user.

To list existing user namespaces:
```bash
lsns --type user
```
- Shows active user namespaces on the system.

---

## **2. Creating a New User Namespace**
Move to the `nobody` user within a new user namespace:
```bash
unshare --user bash
```
- `--user` → Creates a new user namespace.
- `bash` → Launches a new shell in this namespace.

Now, check the namespace information:
```bash
readlink /proc/$$/ns/user
```
- Displays the unique namespace ID for the current shell.
- This should now be different from the initial namespace ID.

Verify user identity inside the new namespace:
```bash
id
```
- The effective user will be `nobody`, as the namespace does not inherit user mappings.

---

## **3. Mapping the Root User Inside the Namespace**
Instead of being mapped to `nobody`, we can map the namespace's root user to the current user:
```bash
unshare --map-root-user bash
```
- `--map-root-user` → Maps the root user (`UID 0`) inside the namespace to the current unprivileged user on the host.

List user namespaces again:
```bash
lsns --type user
```
- The newly created namespace should now be visible in the output.

Inspect the user ID mapping:
```bash
cat /proc/$$/uid_map
```
- Displays the mapping between host and container UIDs.
- Typically, it will show `0 1000 1`, meaning UID 0 inside the namespace corresponds to UID 1000 on the host.

---

## **4. Testing File Permissions**
Create a test file inside the new user namespace:
```bash
touch temp.txt
ls -l temp.txt
```
- The file is created with UID 0 (root inside the namespace), but it maps to the actual user outside the namespace.

---

## **Conclusion**
This setup demonstrates how user namespaces allow privilege isolation in containers. Even though a process may run as `root` inside a namespace, it is still restricted by host-level permissions, providing security benefits for containerized applications.

