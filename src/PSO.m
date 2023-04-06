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


num_particles = length(U);   % Number of particles (variables in our optimization)
num_particles_size = [1 num_particles];   % Since PSO takes row vector as input, size will be 1 x num_particles
ub = pmax;      % Constraint #1 : Upper Bound of power
lb = 0;         % Constraint #2 : Lower Bound of power
swarm_size = 10;        % Swarm Size
num_iterations = 500;  % Number of Iterations
plc = 1;         % Cognitive Learning Coefficient
glc = 3;         % Social Learning Coefficient
vmax = 0.1*(ub-lb); % Maximum velocity
vmin = -vmax; % Minimum velocity
% Since we'll be tracking the cost over iterations, declaring a matrix here
current_iteration_cost = ones(num_iterations,1);

% Creating the swarm
% Here, initial_particle is a class with the objects being the parameters of particles in the swarm
initial_particle.position = [];
initial_particle.best_position = [];
initial_particle.cost = [];
initial_particle.best_cost = [];
initial_particle.velocity = [];
particle = repmat(initial_particle,swarm_size,1);
% Setting the initial optimal cost to infinity, since our algorithm is
% minimizing the objective function
Optimal.cost = inf;
% Our initial swarm paramters are all randomized
for i=1:swarm_size 
    particle(i).position = (ub-lb) * rand(num_particles_size) + lb;
    particle(i).best_position = particle(i).position;
    particle(i).velocity = zeros(num_particles_size);
    particle(i).cost = PA_fun(particle(i).position);
    particle(i).best_cost = particle(i).cost;
    % In case the particle's cost is lesser than optimal cost, we must
    % update the optimal parameters
    if particle(i).best_cost < Optimal.cost 
        Optimal.cost = particle(i).best_cost;
        Optimal.position = particle(i).best_position;
    end
end

% Finally, we execute the actual PSO algorithm
for it=1:num_iterations
    for i=1:swarm_size
        w = abs(randn)/2; % Gaussian distribution to set inertia weight
        % Step 1 : Updating the particle velocity
        particle(i).velocity = w*particle(i).velocity ... % The effect of previous particle velocity
            +plc*rand(num_particles_size).*(particle(i).best_position - particle(i).position) ... % The effect of personal learning 
            +glc*rand(num_particles_size).*(Optimal.position - particle(i).position); % The effect of social learning
        % Now, we need to limit this velocity in case it exceed vmax or falls below vmin
        for k = 1:length(particle(i).velocity)
            if particle(i).velocity(k) > vmax
               particle(i).velocity(k) = vmax;
            elseif particle(i).velocity(k) < vmin
               particle(i).velocity(k) = vmin;
            end
        end
        % Step 2 : Updating the particle position
        particle(i).position = particle(i).position + particle(i).velocity;
        % Now, we need to limit this position in case it exceed ub or falls below lb
        for k = 1:length(particle(i).position)
            if particle(i).position(k) > ub
               particle(i).position(k) = ub;
            elseif particle(i).position(k) < lb
               particle(i).position(k) = lb;
            end
        end
        % Step 3 : Evaluating cost and comparing with local and global minima
        particle(i).cost = PA_fun(particle(i).position);
        % If this cost is lesser than the best cost for the particle, it
        % has achieved a new personal best, so we must update best cost and
        % poition to current values
        if particle(i).cost < particle(i).best_cost       
            particle(i).best_position = particle(i).position;
            particle(i).best_cost = particle(i).cost;
        end
        % Now, if this new best_cost is lesser than the optimal cost
        % too, then we've hit a new social best too, so we must update
        if particle(i).best_cost < Optimal.cost  
               Optimal.cost = particle(i).best_cost;
               Optimal.position = particle(i).best_position;               
        end
    end
    current_iteration_cost(it) = Optimal.cost;
    % disp(['Iteration ' num2str(it) ': Energy Consumption = ' num2str(current_iteration_cost(it))]);
end

disp(Optimal.cost);