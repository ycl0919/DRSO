% Program Initialization
clc;
close all;
clear all;


u = 32; % Number of mobile users
n = 8; % Number of BSs equipped with edge servers
B = 20*(10^6); % Fixed bandwidth
H = 10; % Fixed altitude of BS
Iq = 700*(2^10); % Input data of request q
Tgq = 0.5; % Ideal delay of request q
Tbq = 0.65; % Tolerable delay of request q
Tavg = (Tgq + Tbq)/2; % Average delay of request q
pmax = 5; % Maximum transmitting power of mobile user
PBS = 7500; % Average power consumption of BS
sig2 = 0.01; % Background white Gaussian noise power
PC = 15000; % Average power consumption of macro-BS
Rn = 70*10^9; % Computing capacity of BS (edge server) n 
Rc = 120*10^9; % Computing capacity of micro-BS with a deep cloud server C
Rqn = randi(Rn,u,1); % Computing resources that BS n schedules to request q
numvar = u; % Number of variables in the PSO optimization
U = 1:u; % Set of mobile users
N= 1:n; % Set of BSs equipped with edge servers
xqn = zeros(u,1) ; % Indicator of allocating request q to BS n (0 for macro BS, 1 for BS n)
put = zeros(u,2); % Location of mobile users (Row u has coordinates for user u)
pnt = zeros(n,2); % Location of base stations (Row n has coordinates for BS n)
rng(42);
for user = U
    xu = randi([0 50],1); % X coordinate of mobile user at time t
    yu = randi([0 50],1); % Y coordinate of mobile user at time t 
    put(user,1) = xu; 
    put(user,2) = yu;
end
for bs = N
    xn = randi([0 50],1); % X coordinate of base station at time t
    yn = randi([0 50],1); % Y coordinate of base station at time t 
    pnt(bs,1) = xn; 
    pnt(bs,2) = yn;
end
punt = pmax*ones(u,n); % Transmitting power from mobile user u to BS n
alloted_bs = zeros(1,length(U)); % Base station alloted to each user (the closest one)
for u = U
  dmin = 100000;  
  for n = N
        d = ((put(u,1)- pnt(n,1))^2 + (put(u,2)- pnt(n,2))^2)^0.5;
        if d < dmin
            dmin = d;
            nopt = n;
        end
  end
  alloted_bs(u) = nopt;
end
for u = 1:length(U)
     n = alloted_bs(u);
     user_profile(u) = punt(u,n);
end
g0 = 0.1; % Channel power gain at reference distance d0
gunt = zeros(u,n); % Channel power gain between mobile user u to BS n
for u = U
    for n = N
        d = (put(u,1)-pnt(n,1))^2 + (put(u,2)-pnt(n,2))^2 + H^2;
        gun = g0/d;
        gunt(u,n) = gun;
    end
end

PA_fun = @(user_profile)PA(user_profile,alloted_bs,gunt,U,sig2,B,Iq); % Creating a function handle
SubGrad_fun = @(user_profile,u)SubGrad(user_profile,u,alloted_bs,gunt,U,sig2,B,Iq);

p0 = pmax*ones(1,length(U)); % Initializing with all values set to pmax
p1 = pmax*ones(1,length(U));
r = 0;
Delta = 10000;
while Delta > 1e-6
    disp(r);
    r = r + 1;
    mur = 1 / sqrt(r);
    for u = U
        grad = SubGrad_fun(p1, u);
        deltaur = mur * grad;
        pur = p1(u) - deltaur;
        if pur < 0
            pur = 1e-8;
        end
        p1(1,u) = pur;
    end
    Delta = 0;
    for u = U
        Delta = Delta + (p0(u) - p1(u))^2;
    end
    p0 = p1;
    e = PA_fun(p1);
    disp(e);
end