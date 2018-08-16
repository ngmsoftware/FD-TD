clear();
clc();

% FD-TD grid
Nx = 400;
Ny = 200;
Nt = 10000;
Nt_times = 2;

[X, Y] = meshgrid(linspace(0,Nx/Ny,Nx), linspace(0,1,Ny));

dy = 1/max([Ny Nx]);
dx = dy;

CLF = sqrt(inv(dx^2)+inv(dy^2));

dt = .1/CLF;


% initial values
Hx = zeros(Ny,Nx);
Hy = zeros(Ny,Nx);
Ez = zeros(Ny,Nx);
IDz = zeros(Ny,Nx);
ICxE = zeros(Ny,Nx);
ICyE = zeros(Ny,Nx);
er = ones(Ny,Nx);
ur = ones(Ny,Nx);




% Absorving boundaries
p.L = 50;
p.maxS = 150;
s = generateConductivity(Nx, Ny, 'boundary', p);




% wires
p.cx = 0.25;
p.cy = 0.75;
p.r = 0.1;
p.width = 0.01;
p.angle = 0;
wire = generateWire(Nx,Ny,'reflector',p);

p.cx = 0.6;
%p.wire_vector = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
p.wire_vector = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 ];
wire = generateWire(Nx,Ny,'fss_x',p);




% lens
p.cx = 1.25;
p.cy = 0.5;
p.r = 0.1;
p.R = 0.5;
p.er = 5;
er = generateEpsilon(Nx, Ny, 'lens', p);








% Configuration
parameters.epsilon = er;
parameters.mu = ur;
parameters.dt = dt;
parameters.dx = dx;
parameters.dy = dy;
parameters.boundary = 1;
parameters.sigma = s;


% sources config
p_source{1}.cx = 0.25;
p_source{1}.cy = 0.5;
p_source{1}.amplitude = 10;
p_source{1}.frequency = 80;
p_source{1}.time = 0;

p_source{2}.cx = 0.25;
p_source{2}.cy = 0.5;
p_source{2}.amplitude = 10;
p_source{2}.width = 0.005;
p_source{2}.t0 = 6*p_source{2}.width;
p_source{2}.time = 0;




% view 
s_view = s/max(max(s));
er_view = er/max(max(er));

viewQuiver = 0;

beta = 8;
M1 = zeros(255,3);
M2 = zeros(255,3);
M3 = zeros(255,3);
M4 = zeros(255,3);
for i=1:255
    M1(i,:) = [(pi/2+atan(beta*(60-i)/255))/pi 0 (pi/2+atan(beta*(i-190)/255))/pi];
    M2(i,:) = [(pi/2+atan(beta*(i-190)/255))/pi (pi/2+atan(beta*(i-190)/255))/pi (pi/2+atan(beta*(60-i)/255))/pi];
    M3(i,:) = [(pi/2+atan(beta*(i-128)/255))/pi (pi/2+atan(beta*(i-128)/255))/pi (pi/2+atan(beta*(i-128)/255))/pi];
    M4(i,:) = [0 (pi/2+atan(beta*(i-128)/255))/pi (pi/2+atan(beta*(i-128)/255))/pi];
end
M1 = M1/max(max(M1));
M2 = M2/max(max(M2));
M3 = M3/max(max(M3));
M4 = M4/max(max(M4));


   
% time loop    
ok = 1;
for n = 1:Nt*Nt_times
    t = n/Nt;

    p_source{1}.time = t;
    Ez = Ez + generateSource(Nx, Ny, 'sine', p_source{1});

    
    % wave vector
    ky = Ez.*Hy;
    kx = -Ez.*Hx;

    
    magK = abs(kx.^2+ky.^2).^0.4;
    kx = kx./(magK+1e-10);
    ky = ky./(magK+1e-10);

    
    % infinite conductivity regions
    Ez = Ez.*wire;
    Hx = Hx.*wire;
    Hy = Hy.*wire;
     
    
    
    % computation
    [Ez, Hy, Hx] = leapFrog2D(Ez, Hy, Hx, parameters);

    
    
    
    
    
    % view stuff
    if (mod(n,6)==0)

        cla();
        hold('on');
        Ezs = 40*Ez+130;
        IEz = ind2rgb(uint8(Ezs),M1);

        Ss = s/2+128;
        Is = ind2rgb(uint8(Ss),M2);

        Ws = 255*(1-wire);
        Iw = ind2rgb(uint8(Ws),M3);

        Ers = 255*(er-1)/6;
        Ier = ind2rgb(uint8(Ers),M4);
        
        imagesc((Ier + IEz + Is + Iw)/2);

        
        %imagesc(Ez/5 + 0*s_view + 0*er_view/2 + 0*(1-wire)/2,[-1 1]);
        axis('equal');
        axis('off');
        

%           cla();
%           hold('on')
%           plot(Ez(Ny/2,:))
%           plot(er(end/2,:))
        
%          cla();
%          hold('on');
%          mesh(10*Ez);
%          axis('equal')
%          axis([1 Ny 1 Nx -30 30])
        
        if  viewQuiver
            quiver(1:5:Nx, 1:5:Ny, ky(1:5:end,1:5:end), kx(1:5:end,1:5:end))
        end
         

        drawnow();
    end
    

end