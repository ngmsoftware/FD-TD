close('all');
clear();
clc();

F = figure(1);
%A = axes('position',[0.0 0.0 1.0 0.5]);
%B = axes('position',[0.0 0.5 1.0 0.5]);
A = axes('position',[0.0 0.0 1.0 1.0]);

% cpu/gpu
%className = 'gpuArray';
className = 'double';

% view options
viewQuiver = 0;
viewMovie = 1;
generateMovie = 1;
sendToBlender = 0;
movieName = 'output/movie.avi';
colormapsName = 'default';

% simulation configuration
S = configSimulation('4F Colimator', className);
%S = configSimulation('RV', className);
%S = configSimulation('antireflex', className);
%S = configSimulation('fabry perot', className);
%S = configSimulation('single lens', className);
%S = configSimulation('simple pulse', className);
%S = configSimulation('fss', className);
%S = configSimulation('wavefront sensor', className);
%S = configSimulation('double slit', className);
%S = configSimulation('%-)', className);
%S = configSimulation('wall', className);
%S = configSimulation('waveguide', className);
%S = configSimulation('reflector', className);
%S = configSimulation('percolation', className);
%S = configSimulation('refraction1', className);
%S = configSimulation('device', className);
%S = configSimulation('refraction2', className);
%S = configSimulation('optical fiber', className);
%S = configSimulation('optical ckt', className);


% config variables
Nt = S.Nt;
dt = S.dt;
Nx = S.Nx;
Ny = S.Ny;

% initial values
Hx = zeros(S.Ny,S.Nx,className);
Hy = zeros(S.Ny,S.Nx,className);
Ez = zeros(S.Ny,S.Nx,className);

s = S.s;
er = S.er;
ur = S.ur;
wire = S.wire;

sources_parameters = S.sources_parameters;
sources_name = S.sources_name;

% Configuration
[c1, c2, c3, c4] = leapFrog2D_constants(S.er, S.ur, S.s, S.dt);

parameters.c1 = c1;
parameters.c2 = c2;
parameters.c3 = c3;
parameters.c4 = c4;
parameters.dx = S.dx;
parameters.dy = S.dy;
parameters.boundary = S.boundary;
parameters.wire = wire;

% colormaps
[M1, M2, M3, M4] = customColormaps(colormapsName);


% movie init
if generateMovie 
    vidObj = VideoWriter(movieName);
    open(vidObj);
end
       
% blender
if sendToBlender 
    conn = openBlender();
end

Imaterial = composeImage(s, wire, er, M2, M3, M4);
   

% samples for analysis
samplingStartX = 0.8;
samplingEndX = 0.9;
samplingStartEndY = 0.5;


% extra dowings
t = linspace(0,2*pi,128);
drawX = (0.5+0.15*sin(t))*Ny;
drawY = (0.5+0.15*cos(t))*Ny;


% fourier stuff
Nfourier = S.Nx*4;
X1 = zeros(1,Nfourier);
X2 = zeros(1,Nfourier);


% main time loop 
t = 0;
n = 1;
tic();
set(F,'position',[100 100 Nx Ny]);
while ishandle(F)
    n = n+1;
    t = t + S.dt;

    for i=1:length(sources_parameters);
        sources_parameters{i}.time = t;
        Ez = Ez + toClass(generateSource(Nx, Ny, sources_name{i},sources_parameters{i}),className);
    end
     
    
    if viewQuiver
        % wave vector
        ky = Ez.*Hy;
        kx = -Ez.*Hx;

        magK = abs(kx.^2+ky.^2).^0.4;
        kx = kx./(magK+1e-10);
        ky = ky./(magK+1e-10);
    end
    
    
    % computation
    [Ez, Hy, Hx] = leapFrog2D(Ez, Hy, Hx, parameters);

 
    X1(2:end) = X1(1:end-1);
    X1(1) = Ez(fix(end/2),fix(end/4));
    
    X2(2:end) = X2(1:end-1);
    X2(1) = Ez(fix(end/2),fix(5*end/6));
    
    N0 = 4;
    % view stuff
    
%    axes(B);
%    plot(w,abs(X));
    
    %axes(A);
    if (mod(n,N0)==0) && (viewMovie || generateMovie)
        cla(A);
        
        I = addEzToComposite(Imaterial, Ez, M1);
        
        figure(1)
        imagesc(I);
        axis('equal');
        axis('off');
        
        if  viewQuiver
            hold('on');
            idxX = 1:round(Ny/20):Nx;
            idxY = 1:round(Ny/20):Ny;
            [X, Y] = meshgrid(idxX, idxY);
            quiver(X, Y, ky(idxY,idxX), kx(idxY,idxX));
        end         

        
        if sendToBlender 
            if (n>1590)
                sendMeshToBlender(conn,Ez);
                printToBlender(conn,'render');
                waitForRender(conn);
            end
        end
            
%         figure(2);
%         subplot(2,1,1);
%         cla();
%         X1f = abs(fft(X1));
%         plot(X1/max(X1))
%         hold('on');
%         plot(linspace(1,Nfourier,Nfourier/32),X1f(fix(1:end/32))/max(X1f))
%         
%         subplot(2,1,2);
%         cla();
%         X2f = abs(fft(X2));
%         plot(X2/max(X2))
%         hold('on');
%         plot(linspace(1,Nfourier,Nfourier/32),X2f(fix(1:end/32))/max(X2f))
        
        % RV Stuff
%         hold('on');
% 
%         xIdx = round(Nx*samplingStartX:Nx*samplingEndX);
%         yIdxS = round(Ny*0.5);
%         yIdxT = round(Ny*0.25);
%         yIdxF = round(Ny*0.75);
%         samplingY = 5*Ez(yIdxS, xIdx);
%         plot(A, xIdx, ones(size(xIdx))*yIdxS,':','color',[0.5 0.5 0.5],'linewidth',4);
%         plot(A, xIdx, samplingY*3 + yIdxT,'w','linewidth',3);
%         tmpF = abs(fft(samplingY))/6;
%         xtmp = xIdx(1:2:end);
%         tmpF = tmpF(1:length(xtmp));
%         plot(A, xtmp, -tmpF/3 + yIdxF,'y','linewidth',3);

%         plot(A,drawX,drawY,'color',[0.5 0.5 0.5],'linewidth',4);
        

        drawnow();


        if generateMovie 
            if ishandle(A)
                frame = getframe(A);
                writeVideo(vidObj,frame);
            end
        end    
        
    end

    
end
toc();

% movie closing
if generateMovie 
     close(vidObj);
end


if sendToBlender 
    printToBlender(conn,'close');
    fclose(conn);
end