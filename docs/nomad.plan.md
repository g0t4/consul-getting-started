Nomad Plan is new in v0.4

ssh into one of the nodes `vagrant ssh nyc-consul-server1` and check nomad's status:
```bash
+ export NOMAD_ADDR=http://172.20.20.31:4646
+ NOMAD_ADDR=http://172.20.20.31:4646
+ nomad status
No running jobs
```

`nomad plan` tells you what nomad will do when you call `nomad run`, try this on the web job:

```bash 
+ nomad plan /vagrant/jobs/web.hcl
+ Job: "web"
+ Task Group: "webs" (5 create)
  + Task: "web" (forces create)

Scheduler dry-run:
- All tasks successfully allocated.

Job Modify Index: 0
To submit the job with version verification run:

nomad run -check-index 0 /vagrant/jobs/web.hcl

When running the job with the check-index flag, the job will only be run if the
server side version matches the the job modify index returned. If the index has
changed, another user has modified the job and the plan's results are
potentially invalid.
```

now run the job
```bash
+ nomad run /vagrant/jobs/web.hcl
==> Monitoring evaluation "cae8d2e2"
    Evaluation triggered by job "web"
    Allocation "5a3a935a" created: node "ee93f090", group "webs"
    Allocation "c2ad82a9" created: node "c947ddd7", group "webs"
    Allocation "f66a0f9f" created: node "a4fb2030", group "webs"
    Allocation "23db4125" created: node "7c40c267", group "webs"
    Allocation "4f4c89eb" created: node "ee93f090", group "webs"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "cae8d2e2" finished with status "complete"
```

once it is running, modify the task count, and run plan again to see the proposed changes:
```bash
+ sed -i 's/count\s*=\s*[0-9]*/count = 3/' /vagrant/jobs/web.hcl
+ nomad plan /vagrant/jobs/web.hcl
+/- Job: "web"
+/- Task Group: "webs" (2 destroy, 3 in-place update)
  +/- Count: "5" => "3" (forces destroy)
      Task: "web"

Scheduler dry-run:
- All tasks successfully allocated.

Job Modify Index: 338
To submit the job with version verification run:

nomad run -check-index 338 /vagrant/jobs/web.hcl

When running the job with the check-index flag, the job will only be run if the
server side version matches the the job modify index returned. If the index has
changed, another user has modified the job and the plan's results are
potentially invalid.
```
Notice that the plan mentions that 2 tasks will be destroyed and 3 will remain in-place. 
Each task in this example links to a docker container, so two containers will be destroyed.
This is a plan of action if circumstances remain the same. Note the check-index for optimistic concurrency.
 
Try changing the container's image version:
```bash
+ sed -i 's/nginx/nginx:1\.10-alpine/' /vagrant/jobs/web.hcl
+ nomad plan /vagrant/jobs/web.hcl
+/- Job: "web"
+/- Task Group: "webs" (3 create/destroy update, 2 destroy)
  +/- Count: "5" => "3" (forces destroy)
  +/- Task: "web" (forces create/destroy update)
    +/- Config {
      +/- image:             "nginx" => "nginx:1.10-alpine"
          port_map[0][http]: "80"
    }

Scheduler dry-run:
- All tasks successfully allocated.
- Rolling update, next evaluation will be in 30s.

Job Modify Index: 338
...
```
Notice that 2 containers will be destroyed and 3 will be recreated. Also notice the rolling update, every 30 seconds.

Run these changes with `nomad run /vagrant/jobs/web.hcl`, this takes a while because only one node will update every 30 seconds!

More details about `nomad plan` here: https://www.nomadproject.io/docs/commands/plan.html

## Node/allocation statistics

Nomad now collects and reports detailed node and allocation statistics to monitor and optimize load.

First, get the status of the web job to find running allocations. Allocations are placements of docker containers in this web job example.
```bash
+ nomad status web
ID          = web
Name        = web
Type        = service
Priority    = 50
Datacenters = nyc
Status      = running
Periodic    = false

Allocations
ID        Eval ID   Node ID   Task Group  Desired  Status
986784b2  ace5aa88  c947ddd7  webs        run      running
700b4328  02d8995d  c947ddd7  webs        run      running
662b9224  2135103b  7c40c267  webs        run      running
c2ad82a9  cae8d2e2  c947ddd7  webs        stop     complete
...
```
All of the `complete` allocations can be ignored, those are old and haven't yet been GC'd.

Pick one of the running allocation IDs and get the status of the allocation with detailed statistics:

```bash
+ nomad alloc-status -stats 986784b2
ID            = 986784b2
Eval ID       = ace5aa88
Name          = web.webs[2]
Node ID       = c947ddd7
Job ID        = web
Client Status = running

Task "web" is "running"
Task Resources
CPU    Memory          Disk     IOPS  Addresses
0/100  1.4 MiB/10 MiB  300 MiB  0     http: 172.20.20.23:30128

Memory Stats
Cache   Max Usage  RSS      Swap
76 KiB  1.5 MiB    1.4 MiB  0 B

CPU Stats
Percent  Throttled Periods  Throttled Time
0.00%    0                  0

Recent Events:
Time                   Type      Description
07/09/16 23:01:52 UTC  Started   Task started by client
07/09/16 23:01:51 UTC  Received  Task received by client

```

Grab the `Node ID` to get node level statistics:

```bash
+ nomad node-status -stats c947ddd7
ID     = c947ddd7
Name   = nyc-worker3
Class  = <none>
DC     = nyc
Drain  = false
Status = ready
Uptime = 3h56m26s

Allocated Resources
CPU       Memory          Disk            IOPS
200/4008  20 MiB/489 MiB  600 MiB/58 GiB  0/0

Allocation Resource Utilization
CPU     Memory
0/4008  2.7 MiB/489 MiB

Host Resource Utilization
CPU       Memory           Disk
119/4008  130 MiB/489 MiB  1.3 GiB/62 GiB

CPU Stats
CPU    = cpu0
User   = 0.99%
System = 1.98%
Idle   = 97.03%

Memory Stats
Total     = 489 MiB
Available = 359 MiB
Used      = 130 MiB
Free      = 143 MiB

Disk Stats
Device         = /dev/mapper/vagrant--vg-root
MountPoint     = /
Size           = 62 GiB
Used           = 1.3 GiB
Available      = 58 GiB
Used Percent   = 2.16%
Inodes Percent = 1.54%

Device         = /dev/sda1
MountPoint     = /boot
Size           = 235 MiB
Used           = 38 MiB
Available      = 185 MiB
Used Percent   = 16.04%
Inodes Percent = 0.48%

Allocations
ID        Eval ID   Job ID  Task Group  Desired Status  Client Status
986784b2  ace5aa88  web     webs        run             running
700b4328  02d8995d  web     webs        run             running
c2ad82a9  cae8d2e2  web     webs        stop            complete
...
```
  
Notice we have two allocations (nginx docker containers) on this node, 200 CPU shares of 4000 are reserved.
But, we're not really using any CPU (allocation resource utilization).
Send in some web requests to see these values change. 
See the alloc-status above for the url to an allocation's nginx container.