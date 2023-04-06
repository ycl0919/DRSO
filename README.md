# Dynamic Request Scheduling Optimization in Mobile Edge Computing for IoT Applications

## Problem 1: Power Allocation

PA.m (PA function)

SubGrad.m (Subgradient function)

NCGG.m (Implementation of NCGG algorithm)

SA.m (Implementation of SA algorithm)

PSO.m (Implementation of Inertia Weighted Particle Swarm Optimisation algorithm)

### Results

1. Energy consumption vs Number of Mobile Users (pmax = 5W).

![E_diff_u_diff_method](fig/E_diff_u_diff_method.jpg)

2. Energy consumption vs Maximum Power (pmax).

![E_diff_u_diff_pmax](fig/E_diff_u_diff_pmax.jpg)

3. Convergence Property of NCGG vs Number of Mobile Users (pmax = 5W, y axis is E, not Error of E in the paper).

![E_u_conv](fig/E_u_conv.jpg)

## Problem 2: Joint Request Offloading and Computing Resource Scheduling

JRORS.m (JRORS function)

Welfare_PSO.m (Implementation of Binary Particle Swarm Optimisation)

### Results

1. Performance versus different number of mobile users ($I_q = 700KB$).

![Welf_diff_u_diff_wq](fig/Welf_diff_u_diff_wq.jpg)

2. Performance versus different request workload ($U = 60, I_q = 700 KB$).

![Welf_diff_w_u60](fig/Welf_diff_w_u60.jpg)

3. Performance versus different request input ($U = 60, w_q = 1500$ Magacycles).

![Welf_diff_i_wq1500](fig/Welf_diff_i_wq1500.jpg)