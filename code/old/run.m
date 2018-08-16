clear();
clc();

Nx = 100;
Ny = 100;
Nz = 10;
Nt = 10000;

H.x = zeros(1+Nx+1,1+Ny+1,1+Nz+1);
H.y = zeros(1+Nx+1,1+Ny+1,1+Nz+1);
H.z = zeros(1+Nx+1,1+Ny+1,1+Nz+1);
E.x = zeros(1+Nx+1,1+Ny+1,1+Nz+1);
E.y = zeros(1+Nx+1,1+Ny+1,1+Nz+1);
E.z = zeros(1+Nx+1,1+Ny+1,1+Nz+1);

dx = 1/Nx;
dy = 1/Ny;
dz = 1/Nz;

u = 1;
e = 1;
s = 0.0;

CLF = inv(sqrt(u*e))*sqrt(inv(dx^2)+inv(dy^2)+inv(dz^2));

parameters.epsilon = e;
parameters.mu = u;
parameters.dt = 0.05/CLF;
parameters.dx = dx;
parameters.dy = dy;
parameters.dz = dz;
parameters.sigma = s;



for n = 1:Nt

    [E, H] = leapFrog(E, H, parameters);

    mesh(H.z(:,:,Nz/2));
    axis([1 Nx 1 Ny -1 1])

    drawnow();
end