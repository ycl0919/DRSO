# Dynamic Request Scheduling Optimization in Mobile Edge Computing for IoT Applications

## Problem 1: Power Allocation

PA.m (PA function)

SubGrad.m (Subgradient function)

NCGG.m (Implementation of NCGG algorithm)

SA.m (Implementation of SA algorithm)

PSO.m (Implementation of Inertia Weighted Particle Swarm Optimisation algorithm)

### Results

1. Energy consumption vs Number of Mobile Users (pmax = 5W).

<img src=".\fig\E_diff_u_diff_method.jpg" width="100%"/>

2. Energy consumption vs Maximum Power (pmax).

<img src=".\fig\E_diff_u_diff_pmax.jpg" width="100%"/>

3. Convergence Property of NCGG vs Number of Mobile Users (pmax = 5W, y axis is E, not Error of E in the paper).

<img src=".\fig\E_u_conv.jpg" width="100%"/>

## Problem 2: Joint Request Offloading and Computing Resource Scheduling

JRORS.m (JRORS function)

Welfare_PSO.m (Implementation of Binary Particle Swarm Optimisation)

### Results

1. Performance versus different number of mobile users ($I_q = 700KB$).

<img src=".\fig\Welf_diff_u_diff_wq.jpg" width="100%"/>

2. Performance versus different request workload ($U = 60, I_q = 700 KB$).

<img src=".\fig\Welf_diff_w_u60.jpg" width="100%"/>

3. Performance versus different request input ($U = 60, w_q = 1500$ Magacycles).

<img src=".\fig\Welf_diff_i_wq1500.jpg" width="100%"/>

