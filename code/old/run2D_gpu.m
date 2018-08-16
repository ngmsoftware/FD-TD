clear();
clc();

Nx = 500;
Ny = 500;
Nt = 10000;

Hx = zeros(Nx,Ny,'gpuArray');
Hy = zeros(Nx,Ny,'gpuArray');
Ez = zeros(Nx,Ny,'gpuArray');

dx = 1/Nx;
dy = 1/Ny;

ur = 1;
er = 1;
u0 = 1;
e0 = 1;
e = er*e0;
u = ur*u0;
s = 0.0;


CLF = inv(sqrt(u*e))*sqrt(inv(dx^2)+inv(dy^2));
dt = 0.1/CLF;

parameters.epsilon = e0*er;
parameters.mu = u0*ur;
parameters.dt = 0.1/CLF;
parameters.dx = dx;
parameters.dy = dy;
parameters.sigma = s;
parameters.boundary = 1;

C = zeros(size(Ez));

for n = 1:Nt
%    tic();
    
    t = n/Nt;

%    Ez(Nx/2, Ny/4) = 10*exp(-20000*(t-0.03).^2);
    Ez(:, Nx/4) = sin(6*2*pi*t);
%    Ez(Nx/4, Nx/4) = 10*sin(10*2*pi*t);

    
    Nb = 2*0;
    for i=1:Nb/2
        Ez(i:Nb:end,Ny/2) = 0;
    end

    [Ez, Hx, Hy] = leapFrog2D(Ez, Hx, Hy, parameters);

    if (mod(n,12)==0)
%        toc();
        imagesc(Ez,[-1 1]);
        drawnow();
%        toc();
    end
    
    %energy_left = sum(sum(Ez(:,1:Ny/2).^2))/(Nx*Ny);
    %energy_right = sum(sum(Ez(:,Ny/2:end).^2))/(Nx*Ny);
    
    %title(sprintf('E_L = %.4f,   E_R = %.4f',energy_left,energy_right))

end