clear();
clc();

% FD-TD grid
Nx = 200;
Ny = 400;
Nt = 10000;
Nt_times = 2;

[X, Y] = meshgrid(linspace(0,1,Ny),linspace(0,1,Nx));

dx = 1/max([Nx Ny]);
dy = dx;

CLF = sqrt(inv(dx^2)+inv(dy^2));

dt = .1/CLF;


% initial values
Hx = zeros(Nx,Ny);
Hy = zeros(Nx,Ny);
Ez = zeros(Nx,Ny);
IDz = zeros(Nx,Ny);
ICxE = zeros(Nx,Ny);
ICyE = zeros(Nx,Ny);
er = ones(Nx,Ny);
ur = ones(Nx,Ny);
sx = zeros(Nx,Ny);
sy = zeros(Nx,Ny);
s = zeros(Nx,Ny);

% Conductivity
%tmp = 5000*linspace(0,1,150).^3;
%s(:,end/2+(1:150)) = tmp(ones(120,1),:);

%s(:,end/2+(1:150)) = 100000;




% PML!
L = 50;
MaxS = 150;

idx = (1:L)';
o1 = ones(1,Ny);
sx(L:-1:1,:) = MaxS*(idx(:,o1)./L).^4;
sx(end-L+1:end,:) = MaxS*(idx(:,o1)./L).^4;

idx = (1:L);
o1 = ones(Nx,1);
sy(:,L:-1:1) = MaxS*(idx(o1,:)./L).^4;
sy(:,end-L+1:end) = MaxS*(idx(o1,:)./L).^4;


slx = cos(10*2*pi*X).^2;
sly = cos(round((Nx/Ny)*10)*2*pi*Y).^2;


s = sx.*slx+ sy.*sly + ((sx+sy).^2)/MaxS;

% Permissivity
%er(:,end/2+(1:100)) = 4;



% Infinite comductivity
wire = ones(size(Ez));


% Nb = 2*6;
% for i=1:Nb/2
%     wire(i:Nb:end,Ny/2) = 0;
% end
% wire(:,Ny/2) = 0;



% lens

er = 1 + 5*(  ( ((4*(X-0.2).^2+(Y-0.5).^2)<.6)  +   ((4*(X-0.8).^2+(Y-0.5).^2)<.6) )>1   );
er = conv2(er,[0 1 0; 1 1 1; 0 1 0]/5,'same');


% Configuration
parameters.epsilon = er;
parameters.mu = ur;
parameters.dt = dt;
parameters.dx = dx;
parameters.dy = dy;
parameters.sigma_x = sx;
parameters.sigma_y = sy;
parameters.boundary = 1;
parameters.sigma = s;

%C = zeros(size(Ez));



% Fourier analisys variables
x = (0:Nx)'/Nx;
f = 0:25;

Ke = exp(-1j*2*pi*f*dt);
Ft = zeros(size(f));
Fr = zeros(size(f));
Fs = zeros(size(f));



% view 
s_view = s/max(max(s));
er_view = er/max(max(er));

   
% time loop    
ok = 1;
for n = 1:Nt*Nt_times
    t = n/Nt;

    % source 1
    %es = 700*sin(300*t - 3*dt)*dx;
    %hs = 700*sin(300*t        )*dx;
    
    % source 2
    %es = 700*exp(-5000*(t-0.03 - 3*dt).^2)*dx;
    %hs = 700*exp(-5000*(t-0.03       ).^2)*dx;

%     Ez(:, Ny/4) = Ez(:, Ny/4) + es;
%     Hx(:, Ny/4) = Hx(:, Ny/4) + hs;

    %es = 12*exp(-40000*(t-0.1).^2);
    es = 12*sin(300*t);
    hs = 12*sin(300*(t+dx/2-dt/2));

    Ez(fix(Nx/3),fix(Ny/6)) = Ez(fix(Nx/3),fix(Ny/6)) + es;
    Hx(fix(Nx/3),fix(Ny/6)) = Hx(fix(Nx/3),fix(Ny/6)) + hs;
%    Ez(fix(Nx/2),fix(Ny/6)) = Ez(fix(Nx/2),fix(Ny/4)) + es;
%
%    Ez(fix(2*Nx/3),fix(Ny/6)) = Ez(fix(2*Nx/3),fix(Ny/6)) + es;
%   

    % wave vector
    kx = Ez.*Hx;
    ky = -Ez.*Hy;
    
    
    
    % infinite conductivity regions
    Ez = Ez.*wire;
    Hx = Hx.*wire;
    Hy = Hy.*wire;
     
    
    
    % computation
    [Ez, Hx, Hy] = leapFrog2D(Ez, Hx, Hy, parameters);

    
    % DIRECTIONAL Material
    %Ez(:,end/2+0) = -Ez(:,end/2+0).*(2*(kx(:,end/2+1)>0)-1);

    
    
    
    % fourier analisys of the starting and end points (middle)
    ezt = Ez(fix(Nx/2),Ny-1);
    ezr = Ez(fix(Nx/2),2);
    
    Fs = Fs + (dt*Ke.^n)*es;
    Ft = Ft + (dt*Ke.^n)*ezt;
    Fr = Fr + (dt*Ke.^n)*ezr;
    
    
    
    
    
    
    
    % view stuff
    if (mod(n,6)==0)
%         subplot(2,1,1);

        cla();
        hold('on');
        I1 = imagesc(Ez/5 + s_view + er_view/2,[-1 1]);
%        I1.AlphaData = er;
        axis([1 Ny 1 Nx]);
        axis('equal');

%           cla();
%           hold('on')
%           plot(Ez(Nx/2,:))
%           plot(er(end/2,:))
        
%          cla();
%          hold('on');
%          mesh(10*Ez);
%          axis('equal')
%          axis([1 Ny 1 Nx -30 30])
        
        quiver(1:5:Ny, 1:5:Nx, kx(1:5:end,1:5:end), ky(1:5:end,1:5:end))
         
%         subplot(2,1,2)
%         cla();
%         hold('on');
%         plot(abs(Ft)./abs(Fs),'b');
%         plot(abs(Fr)./abs(Fs),'r');
%         plot(abs(Fs),'k');

        drawnow();
    end
    

end