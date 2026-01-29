# 📊 How to View Running Containers in Podman Desktop

## 🖥️ Step-by-Step Guide

### Step 1: Open Podman Desktop

1. Press **Windows Key**
2. Type: `Podman Desktop`
3. Click to open the application

---

### Step 2: Navigate to Containers View

Once Podman Desktop is open:

#### Option A: Containers Tab (Main View)
```
┌─────────────────────────────────────────────────────┐
│ Podman Desktop                              [- □ ×] │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ☰ Menu                                            │
│  🏠 Dashboard                                       │
│  📦 Containers        ← CLICK HERE!                │
│  🖼️  Images                                         │
│  📁 Volumes                                         │
│  🌐 Pods                                            │
│  ⚙️  Settings                                        │
│                                                     │
├─────────────────────────────────────────────────────┤
│  YOUR RUNNING CONTAINERS WILL APPEAR HERE:         │
│                                                     │
│  ┌──────────────────────────────────────────────┐ │
│  │ 🟢 festive_robinson                          │ │
│  │    localhost/inventory-service:latest        │ │
│  │    Up 15 minutes                             │ │
│  │    Port: 8082→8080                           │ │
│  │    [▶️ Start] [⏸️ Stop] [🗑️ Delete] [📝 Logs] │ │
│  └──────────────────────────────────────────────┘ │
│                                                     │
│  ┌──────────────────────────────────────────────┐ │
│  │ 🟢 boring_chaplygin                          │ │
│  │    localhost/order-service:latest            │ │
│  │    Up 15 minutes                             │ │
│  │    Port: 8081→8081                           │ │
│  │    [▶️ Start] [⏸️ Stop] [🗑️ Delete] [📝 Logs] │ │
│  └──────────────────────────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🔍 What You'll See for Your Services

### Your Running Containers:

#### 1. Inventory Service Container
```
Name:       festive_robinson
Image:      localhost/inventory-service:latest
Status:     🟢 Running (Up X minutes)
Ports:      8082:8080
CPU/Memory: Shows usage stats
```

**Actions Available:**
- ▶️ **Start** - Start if stopped
- ⏸️ **Stop** - Stop the container
- 🔄 **Restart** - Restart the container
- 🗑️ **Delete** - Remove the container
- 📝 **Logs** - View container logs
- 🖥️ **Terminal** - Open shell inside container
- 📊 **Inspect** - View detailed information

#### 2. Order Service Container
```
Name:       boring_chaplygin
Image:      localhost/order-service:latest
Status:     🟢 Running (Up X minutes)
Ports:      8080-8081:8080-8081
CPU/Memory: Shows usage stats
```

**Same Actions Available** as above

---

## 📊 Understanding the Containers View

### Status Indicators:
- 🟢 **Green** = Running
- 🔴 **Red** = Stopped
- 🟡 **Yellow** = Starting/Stopping
- ⚪ **Gray** = Paused

### Information Displayed:
1. **Container Name** - e.g., "festive_robinson"
2. **Image** - What image it's running from
3. **Status** - How long it's been running
4. **Ports** - Port mappings (host:container)
5. **CPU Usage** - Real-time CPU consumption
6. **Memory Usage** - RAM being used
7. **Network** - Network I/O
8. **Created** - When container was created

---

## 🎯 Quick Actions in Podman Desktop

### View Container Logs:
1. Click on your container name (e.g., "festive_robinson")
2. Click **"Logs"** button
3. You'll see all output from the service

**What you'll see in logs:**
```
__  ____  __  _____   ___  __ ____  ______ 
 --/ __ \/ / / / _ | / _ \/ //_/ / / / __/ 
 -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \   
--\___\_\____/_/ |_/_/|_/_/|_|\____/___/   
2026-01-28 10:00:00 INFO  [io.quarkus] Quarkus started
2026-01-28 10:00:00 INFO  [io.quarkus] Listening on: http://0.0.0.0:8080
```

### Open Terminal in Container:
1. Click on your container
2. Click **"Terminal"** or **"Exec"** button
3. You get a shell inside the running container

### View Detailed Stats:
1. Click on your container
2. Look at the **"Stats"** tab
3. See real-time:
   - CPU usage graph
   - Memory usage graph
   - Network I/O
   - Disk I/O

---

## 🖼️ Alternative Views

### Dashboard View:
Click **"Dashboard"** (home icon) to see:
- Overview of all containers
- Quick stats
- Running vs stopped containers
- Images count
- Volumes count

### Pods View:
If you use pods (Kubernetes-like groups), they appear here.

### Images View:
Click **"Images"** to see your built images:
- `quarkus-microservices/inventory-service:latest`
- `quarkus-microservices/order-service:latest`

---

## 🔧 Useful Features in Podman Desktop

### 1. Search/Filter Containers
At the top of the Containers view:
```
[🔍 Search containers...]  [Filter: All ▼]
```
You can filter by:
- All containers
- Running only
- Stopped only

### 2. Bulk Actions
Select multiple containers and perform actions on all at once:
- Start all
- Stop all
- Delete all

### 3. Container Details Panel
Click any container to see detailed panel on the right:
- **Info tab** - Basic information
- **Logs tab** - Real-time logs
- **Inspect tab** - JSON configuration
- **Stats tab** - Resource usage
- **Terminal tab** - Command line access

---

## 🎨 Visual Layout Example

```
┌────────────────────────────────────────────────────────────────┐
│  Podman Desktop                                     [- □ ×]    │
├────┬───────────────────────────────────────────────────────────┤
│ ☰  │  Containers (2 running, 0 stopped)                        │
│ 🏠 │                                                            │
│►📦◄│  [🔍 Search] [Filter: Running ▼] [⚙️] [🔄 Refresh]      │
│ 🖼️ │  ┌─────────────────────────────────────────────────────┐│
│ 📁 │  │ 🟢 festive_robinson              [▶] [⏸] [🗑] [📝]││
│ 🌐 │  │ inventory-service:latest                            ││
│ ⚙️ │  │ Up 15 minutes    CPU: 2%    MEM: 128MB              ││
│    │  │ Ports: 8082→8080                                    ││
│    │  └─────────────────────────────────────────────────────┘│
│    │                                                            │
│    │  ┌─────────────────────────────────────────────────────┐│
│    │  │ 🟢 boring_chaplygin              [▶] [⏸] [🗑] [📝]││
│    │  │ order-service:latest                                ││
│    │  │ Up 15 minutes    CPU: 1%    MEM: 115MB              ││
│    │  │ Ports: 8080-8081→8080-8081                          ││
│    │  └─────────────────────────────────────────────────────┘│
└────┴───────────────────────────────────────────────────────────┘
```

---

## 📝 Your Specific Containers

Based on your current setup, you should see:

### Container 1: festive_robinson
- **Name:** festive_robinson
- **Image:** localhost/inventory-service:latest
- **Status:** 🟢 Running
- **Ports:** 8082:8080, 8444:8443
- **Service:** Inventory Service

**To verify it's working:**
- Click "Logs" → Should see Quarkus startup logs
- Browser: http://localhost:8082/inventory

### Container 2: boring_chaplygin
- **Name:** boring_chaplygin
- **Image:** localhost/order-service:latest
- **Status:** 🟢 Running
- **Ports:** 8080-8081:8080-8081, 8443:8443
- **Service:** Order Service

**To verify it's working:**
- Click "Logs" → Should see Quarkus startup logs
- Browser: http://localhost:8081/orders

---

## 🚀 Quick Actions from Podman Desktop

### Stop a Container:
1. Go to **Containers** tab
2. Find your container (e.g., festive_robinson)
3. Click **Stop** button (⏸️ icon)
4. Status changes to 🔴 Stopped

### View Logs:
1. Click on container name
2. Click **Logs** tab in right panel
3. See real-time logs
4. Use search to filter logs

### Restart a Container:
1. Find your container
2. Click **Restart** button (🔄 icon)
3. Container restarts with same settings

### Delete a Container:
1. Stop the container first (if running)
2. Click **Delete** button (🗑️ icon)
3. Confirm deletion
4. Container is removed (image remains)

---

## 💡 Pro Tips

### 1. Quick Container Info
**Hover** over any container to see tooltip with:
- Full container ID
- Command being run
- Created time
- Additional port info

### 2. Copy Container Details
**Right-click** on container → **Copy**:
- Container ID
- Container name
- Image name

### 3. Open in Browser
Some containers show a **"Open in Browser"** button if they expose web ports.

### 4. Monitor Resources
Enable **"Show stats"** view to see:
- Real-time CPU graph
- Memory usage graph
- Network throughput

---

## 🎯 Summary

**Where to see your running containers:**
1. Open **Podman Desktop**
2. Click **"Containers"** in left sidebar
3. See all running containers with status indicators

**Your containers:**
- 🟢 **festive_robinson** (Inventory Service) - Port 8082
- 🟢 **boring_chaplygin** (Order Service) - Port 8081

**Quick actions available:**
- View logs
- Stop/Start/Restart
- Open terminal
- View stats
- Inspect configuration
- Delete container

---

## 🔗 Additional Resources

**Command Line Alternative:**
```bash
# List all running containers
podman ps

# List all containers (including stopped)
podman ps -a

# View logs
podman logs -f festive_robinson

# View stats
podman stats
```

**But Podman Desktop gives you a nice visual interface for all of this!** 🎉

---

**Open Podman Desktop now and click on "Containers" in the left sidebar to see your running microservices!** 🚀

