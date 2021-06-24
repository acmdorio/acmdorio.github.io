---
title: "PCSEA - Projet Système d'Exploitation"
excerpt: "A simple x86 OS from scratch"
last_modified_at: 2021-04-30
header:
  teaser: https://ensiwiki.ensimag.fr/images/5/58/CalvadOS3.png
tags:
  - Linux
---

This was a project developed during my exchange in Ensimag which I find particularly interesting: we had to build an Operating System from scratch for an x86 architecture.

![CalvadOS](https://ensiwiki.ensimag.fr/images/5/58/CalvadOS3.png)

Of course, we didn't need to include every feature a modern Linux distribution might have.
In fact, our OS is very simple:
- VGA text UI, with a single TTY for a single user.
- No files (in fact, the entire thing runs on 256MiB of RAM).
- A very primitive shell and not that many syscalls.

However, the reason I like it is that we had the opportunity to really go low on the stack and implement (mostly using C, sometimes resorting to x86/IA-32 assembly):
- Drivers for periphals such as the [8259 PIC](https://wiki.osdev.org/8259_PIC), the [8253/8254 PIT](https://wiki.osdev.org/Programmable_Interval_Timer) and [PS/2](https://wiki.osdev.org/PS/2) keyboard and mouse cursor.
- Multiple process trees time-sharing a single CPU, with a priority-based preemptive scheduler (although the kernel itself is not preemptive).
- Inter-process communication and synchronization mechanisms: message queues and semaphores.
- Kernel and user-space separation, including dynamic virtual memory through paging, protection mechanisms and syscalls.
- Init daemon and a system shell which allows users to launch programs either in the foreground or in the background.

You can [read more about the project](https://ensiwiki.ensimag.fr/index.php?title=Projet_système_PC_:_2021_-_MARTIN_Maxime,_B.SANT%27ANNA_Gabriel,_CANTORI_Thibault,_RAVENEL_Pierre,_BRIANCON_Antoine) and check out its [GPL'ed source](https://gitlab.com/baioc/pcsea).
Also, shoutout to the [OSDev](https://wiki.osdev.org/) wiki and community, which helped quite a lot.
{: .notice--info}
