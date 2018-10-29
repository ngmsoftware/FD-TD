function S = configSimulation(name, className)

% coordinates are absolute considering the height of the space equal to 1.0
% example 1: Nx = 400; Ny = 200 imply that the center of the image is cx = 1
% and cy = 0.5;
% example 2: Nx = 300; Ny = 900 imply that the center of the image is cx = 0.3333
% and cy = -1.5;

% default values (change inside switch case if needed)

% FD-TD grid
S.Nx = 800;
S.Ny = 416;
S.Nx = 2048; % CASE HIRES
S.Ny = 1065; % CASE HIRES
S.Nt = 1500;

%S.Nx = 2*S.Nx; % CASE SUPER HIRES
%S.Ny = 2*S.Ny; % CASE SUPER HIRES

S.dy = 1/max([S.Ny S.Nx]);
S.dx = S.dy;

CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));

S.dt = 1/CLF;

% Absorving boundaries
p.L = 50;
p.maxS = 150;
S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);

S.wire = ones(S.Ny,S.Nx,className);
S.er = ones(S.Ny,S.Nx,className);
S.ur = ones(S.Ny,S.Nx,className);

% boundary
S.boundary = 1;

% sources config

S.sources_name{1} = 'pulse';
S.sources_parameters{1}.cx = 0.25;
S.sources_parameters{1}.cy = 0.5;
S.sources_parameters{1}.amplitude = 1000;
S.sources_parameters{1}.width = 0.01;
S.sources_parameters{1}.t0 =  S.sources_parameters{1}.width*6 + 0.03;
S.sources_parameters{1}.time = 0;


switch name

    
    case '4F Colimator'
    
        sc = 2.56;
        sc = 1.5;
        
        % FD-TD grid
        S.Nx = round(800*sc);
        S.Ny = round(416*sc);

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));
        
        S.dt = 1/CLF;
        
        % Absorving boundaries

        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);
        S.s = zeros(S.Ny,S.Nx,className);
        
        % Absorving boundaries
        p.L = 60*sqrt(sc);
        p.maxS = 120*sqrt(sc);
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);
        
        
        
        % lens support
        p.upper_left_x = 0.87;
        p.upper_left_y = 0.001;
        p.lower_right_x = 0.92;
        p.lower_right_y = 0.25;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        
        p.upper_left_x = 0.87;
        p.upper_left_y = 0.75;
        p.lower_right_x = 0.92;
        p.lower_right_y = 0.99;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        
        for i = 1:21
            S.s = conv2(S.s,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        end

        
        
        % lens
        p.cx = 0.9;
        p.cy = 0.5;
        p.r_left = 0.08;
        p.r_right = 0.08;
        p.R = 0.3;
        p.er = 3;
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'lens', p),className);

        
        
        

        % sources config

        % sine
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.25;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 100;
        S.sources_parameters{1}.width = 0.03;
        S.sources_parameters{1}.t0 =  S.sources_parameters{1}.width*6 + 0.03;
        S.sources_parameters{1}.time = 0;
        S.sources_parameters{1}.s2 = 0.03;
        S.sources_parameters{1}.frequency = 80;

        
        % sine
        S.sources_name{2} = 'sine';
        S.sources_parameters{2}.cx = 0.25;
        S.sources_parameters{2}.cy = 0.75;
        S.sources_parameters{2}.amplitude = 50;
        S.sources_parameters{2}.width = 0.03;
        S.sources_parameters{2}.t0 =  S.sources_parameters{1}.width*6 + 0.03;
        S.sources_parameters{2}.time = 0;
        S.sources_parameters{2}.s2 = 0.03;
        S.sources_parameters{2}.frequency = 60;
        
    
    case 'RV'

        p.L = 100;
        p.maxS = 450;
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);
       
        % sine
        S.sources_name{1} = 'rotating_sin';
        S.sources_parameters{1}.cx = 0.5;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 800;
        S.sources_parameters{1}.frequency = 40;
        S.sources_parameters{1}.angularVelocity = 8;
        S.sources_parameters{1}.rotationRadius = 0.15;
        S.sources_parameters{1}.time = 0;


        
    
    case 'antireflex'
        % use this and change p.imScale for atmofere
        %S.Nx = 2048;
        %S.Ny = 1065;
        
        sc = 1.0;
        
        % FD-TD grid
        S.Nx = 800*sc;
        S.Ny = 416*sc;

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));
        
        S.dt = 1/CLF;
        
        % Absorving boundaries

        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);
        S.s = zeros(S.Ny,S.Nx,className);

        
        
       
% +--------------------------
% | division
        p.name = 'images/antireflex_s.png';
        p.cx = 0.5*(S.Nx/S.Ny);
        p.cy = 0.5;
        p.scale = 150;
        p.imScale = sc;
        S.s = S.s + toClass(generateEpsilon(S.Nx, S.Ny, 'image', p),className);
        
        
        p.upper_left_x = 0.725;
        p.upper_left_y= 0.001;
        p.lower_right_x = 0.775;
        p.lower_right_y = 0.15;
        p.value = 150;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        p.upper_left_x = 0.725;
        p.upper_left_y= 0.35;
        p.lower_right_x = 0.775;
        p.lower_right_y = 0.5;
        p.value = 150;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

        
        p.cx = 0.75;
        p.cy = 0.25;
        p.r_left = 0.06;
        p.r_right = 0.05;
        p.R = 0.11;
        p.er = 1.1;
        S.er = S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'lens', p),className) - 1;

        
        p.upper_left_x = 0.725;
        p.upper_left_y= 0.5;
        p.lower_right_x = 0.775;
        p.lower_right_y = 0.65;
        p.value = 150;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        p.upper_left_x = 0.725;
        p.upper_left_y= 0.85;
        p.lower_right_x = 0.775;
        p.lower_right_y = 0.999;
        p.value = 150;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

        
        p.cx = 0.75;
        p.cy = 0.75;
        p.r_left = 0.06;
        p.r_right = 0.05;
        p.R = 0.11;
        p.er = 1.1;
        S.er = S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'lens', p),className) - 1;

        
        
%         p.cx = 0.6 ;
%         p.cy = 0.25;
%         p.lensTickness = 0.025;
%         p.angle = 0.0;
%         p.lensHeight = 0.1;
%         p.er = 1.1;
% 
%         S.er = S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'lens2', p),className);
%             
%         
%         p.cx = 0.6 ;
%         p.cy = 0.75;
%         p.lensTickness = 0.025;
%         p.angle = 0.0;
%         p.lensHeight = 0.1;
%         p.er = 1.1;
% 
%         S.er = S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'lens2', p),className);
%         
        
% +--------------------------
% | cristal
%
        p.name = 'images/antireflex_er2.png';
        p.cx = 0.5*(S.Nx/S.Ny);
        p.cy = 0.5;
        p.scale = 1.47;
        p.imScale = sc;
        %p.imScale = 2.5;  % CASE HIRES
        S.er = S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'image', p),className) -1;
        
        
        % sources config

        % sine
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.25;
        S.sources_parameters{1}.cy = 0.25;
        S.sources_parameters{1}.amplitude = 300;
        S.sources_parameters{1}.frequency = 40*sc;
        %S.sources_parameters{1}.frequency = 80; % CASE HIRES
        S.sources_parameters{1}.time = 0;
    
        S.sources_name{2} = 'sine';
        S.sources_parameters{2}.cx = 0.25;
        S.sources_parameters{2}.cy = 0.75;
        S.sources_parameters{2}.amplitude = 300;
        S.sources_parameters{2}.frequency = 40*sc;
        %S.sources_parameters{2}.frequency = 80; % CASE HIRES
        S.sources_parameters{2}.time = 0;
    
    
    
    case 'fabry perot'

        p.value = 800;

        p.upper_left_x = 0.9;
        p.upper_left_y = 0.0;
        p.lower_right_x = 0.94;
        p.lower_right_y = 0.99;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

        p.value = 2000;

        p.upper_left_x = 1.25;
        p.upper_left_y = 0.0;
        p.lower_right_x = 1.29;
        p.lower_right_y = 0.99;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

        % sources config

        S.sources_name{1} = 'plain_sine_x';
        S.sources_parameters{1}.cx = 0.2;
        S.sources_parameters{1}.amplitude = 10;
        S.sources_parameters{1}.frequency = 15;
        S.sources_parameters{1}.offset = round(S.Ny*0.05);
        S.sources_parameters{1}.time = 0;

        S.sources_name{2} = 'plain_sine_x';
        S.sources_parameters{2}.cx = 0.2;
        S.sources_parameters{2}.amplitude = 10;
        S.sources_parameters{2}.frequency = 12.5;
        S.sources_parameters{2}.offset = round(S.Ny*0.05);
        S.sources_parameters{2}.time = 0;

        S.sources_name{3} = 'plain_sine_x';
        S.sources_parameters{3}.cx = 0.2;
        S.sources_parameters{3}.amplitude = 10;
        S.sources_parameters{3}.frequency = 10;
        S.sources_parameters{3}.offset = round(S.Ny*0.05);
        S.sources_parameters{3}.time = 0;

        S.sources_name{4} = 'plain_sine_x';
        S.sources_parameters{4}.cx = 0.2;
        S.sources_parameters{4}.amplitude = 10;
        S.sources_parameters{4}.frequency = 7.5;
        S.sources_parameters{4}.offset = round(S.Ny*0.05);
        S.sources_parameters{4}.time = 0;

        S.sources_name{5} = 'plain_sine_x';
        S.sources_parameters{5}.cx = 0.2;
        S.sources_parameters{5}.amplitude = 10;
        S.sources_parameters{5}.frequency = 5;
        S.sources_parameters{5}.offset = round(S.Ny*0.05);
        S.sources_parameters{5}.time = 0;

        S.sources_name{6} = 'plain_sine_x';
        S.sources_parameters{6}.cx = 0.2;
        S.sources_parameters{6}.amplitude = 10;
        S.sources_parameters{6}.frequency = 2.5;
        S.sources_parameters{6}.offset = round(S.Ny*0.05);
        S.sources_parameters{6}.time = 0;        

        
    case 'wavefront sensor'
        % use this and change p.imScale for atmofere
        %S.Nx = 2048;
        %S.Ny = 1065;
        
        sc = 1.5;
        
        % FD-TD grid
        S.Nx = 800*sc;
        S.Ny = 416*sc;

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));
        
        S.dt = 1/CLF;
        
        % Absorving boundaries
        p.L = 60*sqrt(sc);
        p.maxS = 120*sqrt(sc);
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);

        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);

        
        
        x = 1.6;
        boxHeigth = 0.02;
        boxWidth = 0.02;

% +--------------------------
% | Lens support
%        
        p.upper_left_x = x-boxWidth/2;
        p.upper_left_y = 0.001;
        p.lower_right_x = x+boxWidth/2;
        p.lower_right_y = 0.04 + boxHeigth/2;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        for i=2:5
            p.upper_left_x = x-boxWidth/2;
            p.upper_left_y = boxWidth/2 + 0.04 + 0.0001+(i-1)*(0.2-0.02) - boxHeigth/2;
            p.lower_right_x = x+boxWidth/2;
            p.lower_right_y = boxWidth/2 + 0.04 - 0.0001 + (i-1)*(0.2-0.02) + boxHeigth/2;
            p.value = 550;
            S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        end
        p.upper_left_x = x-boxWidth/2;
        p.upper_left_y = 1.0-boxHeigth/2 - 0.04;
        p.lower_right_x = x+boxWidth/2;
        p.lower_right_y = 0.999;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

            
            
% +--------------------------
% | Lens array
%
        S.er = ones(S.Ny,S.Nx,className);
        for i=1:5
           
            p.cx = x ;
            p.cy = 0.04+0.1+(i-1)*(0.2-0.02);
            p.lensTickness = 0.025;
            p.angle = 0.0;
            p.lensHeight = (0.2-0.02)/2+0.01;
            p.er = 1.1;

            S.er = S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'lens2', p),className);
            
        end
        

        
% +--------------------------
% | Detector
%
        p.name = 'images/detector.png';
        p.cx = 0.5*(S.Nx/S.Ny);
        p.cy = 0.5;
        p.scale = 550;
        p.imScale = sc;
        S.s = S.s + toClass(generateEpsilon(S.Nx, S.Ny, 'image', p),className);
        
        
        
% +--------------------------
% | Atmosfere
%
        p.name = 'images/atmosfere2.png';
        p.cx = 0.5*(S.Nx/S.Ny);
        p.cy = 0.5;
        p.scale = 2;
        p.imScale = sc;
        %p.imScale = 2.5;  % CASE HIRES
        S.er = -1 + S.er + toClass(generateEpsilon(S.Nx, S.Ny, 'image', p),className);
        
        
        % sources config

        % sine
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.25;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 300;
        S.sources_parameters{1}.frequency = 80*sc;
        %S.sources_parameters{1}.frequency = 80; % CASE HIRES
        S.sources_parameters{1}.time = 0;

       
        
    case 'single lens'

        
        sc = 1.5;
        
        % FD-TD grid
        S.Nx = 800*sc;
        S.Ny = 416*sc;

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));
        
        S.dt = 1/CLF;
        
        % Absorving boundaries

        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);
        S.s = zeros(S.Ny,S.Nx,className);
        
        % Absorving boundaries
        p.L = 60*sqrt(sc);
        p.maxS = 120*sqrt(sc);
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);
        
        
        
        % lens
        p.cx = 0.9;
        p.cy = 0.5;
        p.r_left = 0.15;
        p.r_right = 0.15;
        p.R = 0.5;
        p.er = 4;
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'lens', p),className);


        % sources config

        % sine
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.25;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 1000;
        S.sources_parameters{1}.width = 0.03;
        S.sources_parameters{1}.t0 =  S.sources_parameters{1}.width*6 + 0.03;
        S.sources_parameters{1}.time = 0;
        S.sources_parameters{1}.s2 = 0.03;
        S.sources_parameters{1}.frequency = 100;




        
    case 'simple pulse'
        
        % default value
        
    case 'fss'

        % fss
        p.cx = 1;
        p.wire_vector = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
        S.wire = toClass(generateWire(S.Nx,S.Ny,'fss_x',p),className);
        
        p.cx = 1;
        p.er = 4;
        p.width = 0.05;
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'plane_x', p),className);


        % sources config

        % first burst
        S.sources_name{1} = 'burst';
        S.sources_parameters{1}.cx = 0.3333;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 800;
        S.sources_parameters{1}.frequency = 60;
        S.sources_parameters{1}.width = 0.03;
        S.sources_parameters{1}.t0 =  0;
        S.sources_parameters{1}.time = 0;

        % second burst
        S.sources_name{2} = 'burst';
        S.sources_parameters{2}.cx = 0.3333;
        S.sources_parameters{2}.cy = 0.5;
        S.sources_parameters{2}.amplitude = 800;
        S.sources_parameters{2}.frequency = 10;
        S.sources_parameters{2}.width = 0.03;
        S.sources_parameters{2}.t0 =  0;
        S.sources_parameters{2}.time = 0;
        
        
    case 'double slit'
        
        % fss
        S.wire = ones(S.Ny,S.Nx,className);
        S.wire(:,end/2) = 0;
        S.wire(round(S.Ny/2 - S.Ny/12 + ((-S.Ny*0.02):(S.Ny*0.02))),end/2) = 1;
        S.wire(round(S.Ny/2 + S.Ny/12 + ((-S.Ny*0.02):(S.Ny*0.02))),end/2) = 1;
        

        % sources config

        % source
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.3333;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 400;
        S.sources_parameters{1}.frequency = 30;
        S.sources_parameters{1}.time = 0;

    case '%-)'
        
       
        
        p.name = 'images/maxwell.png';
        p.cx = 0.75*(S.Nx/S.Ny);
        p.cy = 0.5;
        p.scale = 3;
        p.imScale = 1;
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'image', p),className);


        % sources config

        % first burst
%         S.sources_name{1} = 'sine';
%         S.sources_parameters{1}.cx = 0.3333;
%         S.sources_parameters{1}.cy = 0.5;
%         S.sources_parameters{1}.amplitude = 400;
%         S.sources_parameters{1}.frequency = 20;
%         S.sources_parameters{1}.time = 0;

        % first burst
        S.sources_name{1} = 'burst';
        S.sources_parameters{1}.cx = 0.3333;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 800;
        S.sources_parameters{1}.frequency = 60;
        S.sources_parameters{1}.width = 0.03;
        S.sources_parameters{1}.t0 =  S.sources_parameters{1}.width*4;
        S.sources_parameters{1}.time = 0;

        
    case 'wall'
        
       
        p.upper_left_x = 0.1;
        p.upper_left_y= 0.1;
        p.lower_right_x = 1.01;
        p.lower_right_y = 0.4;
        S.wire = toClass(generateWire(S.Nx, S.Ny, 'box', p),className);

        p.upper_left_x = 0.1;
        p.upper_left_y= 0.6;
        p.lower_right_x = 1.01;
        p.lower_right_y = 0.9;
        S.wire = S.wire.*toClass(generateWire(S.Nx, S.Ny, 'box', p),className);
        
        
    case 'waveguide'

        % FD-TD grid
        S.Nx = 810;
        S.Ny = 810;

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));

        S.dt = 1/CLF;

        % Absorving boundaries
        p.L = 50;
        p.maxS = 150;
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);




        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);
        
        p.cx = 0.5;
        p.cy = 0.5;
        p.name = 'images/waveguide.png';
        p.imScale = 1;
        p.scale = 17;
        
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);
        
       
        % first burst
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.0679;
        S.sources_parameters{1}.cy = 0.6506;
        S.sources_parameters{1}.amplitude = 200;
        S.sources_parameters{1}.frequency = 10;
        S.sources_parameters{1}.time = 0;    
        
        
        
    case 'reflector'
        
    
        p.focus_x = 0.2; 
        p.focus_y = 0.5;
        p.base_dist = 0.1; 
        p.width = 0.03;
        p.angle = 0; 
        p.limit_D = 0.5;
        S.wire = toClass(generateWire(S.Nx, S.Ny, 'parabolic_reflector', p),className);

        p.focus_x = 1.6; 
        p.base_x = 1.7; 
        p.angle = pi; 
        S.wire = S.wire.*toClass(generateWire(S.Nx, S.Ny, 'parabolic_reflector', p),className);

        
    case 'percolation'
        
        p.upper_left_x = 0.9;
        p.upper_left_y= 0.0;
        p.lower_right_x = 1.1;
        p.lower_right_y = 1.0;
        p.percent = 0.5;
        p.amplitude = 3;
        p.scale = 0.2;
        
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'percolation',p),className);
        
       
        % first burst
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.3333;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 800;
        S.sources_parameters{1}.frequency = 20;
        S.sources_parameters{1}.time = 0;        
        
        
    case 'refraction1'
        
        % FD-TD grid
        S.Nx = 400;
        S.Ny = 400;

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));

        S.dt = 1/CLF;

        % Absorving boundaries
        p.L = 50;
        p.maxS = 150;
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);

        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);


        % reflector
        p.focus_x = 0.3; 
        p.focus_y = 0.9;
        p.base_dist = 0.01; 
        p.width = 0.0025;
        p.angle = pi/3; 
        p.limit_D = 0.2;
        S.wire = toClass(generateWire(S.Nx, S.Ny, 'parabolic_reflector', p),className);

        
        a = p.angle;
        
        p.point_x = 0.5;
        p.point_y = 0.5;
        p.angle = 0;
        p.amplitude = 8;
        
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'interface',p),className);
        
        
%        S.sources_parameters{1}.cx = p.focus_x + 0.03*cos(a);
%        S.sources_parameters{1}.cy = p.focus_y - 0.03*sin(a);
        % first burst
       S.sources_name{1} = 'sine';
       S.sources_parameters{1}.cx = p.focus_x + 0.03*cos(a);
       S.sources_parameters{1}.cy = p.focus_y - 0.03*sin(a);
       S.sources_parameters{1}.amplitude = 1600;
       S.sources_parameters{1}.frequency = 20;
       S.sources_parameters{1}.time = 0;                

    case 'device'
        
        p.cx = 1.0;
        p.cy = 0.5;
        p.name = 'images/er2.png';
        p.imScale = 1;
        p.scale = 6;
        
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);
        
       
        % first burst
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.3333;
        S.sources_parameters{1}.cy = 0.5;
        S.sources_parameters{1}.amplitude = 800;
        S.sources_parameters{1}.frequency = 20;
        S.sources_parameters{1}.time = 0;        
        
    case 'refraction2'
  
        aperture = 0.45;
        pos = 0.1;
        x = 0.5;
        p.upper_left_x = x;
        p.upper_left_y = 0.01;
        p.lower_right_x = x+0.07;
        p.lower_right_y = aperture+pos;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        p.upper_left_x = x;
        p.upper_left_y = 1-aperture+pos;
        p.lower_right_x = x+0.07;
        p.lower_right_y = 1-0.01;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

        p.cx = x;
        p.cy = 0.5+pos;
        p.imScale = 1;
        p.name = 'images/lens.png';
        p.scale = 4;        
        %S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);
        p.cx = x;
        p.cy = 0.5+pos;
        p.r_left = 0.06;
        p.r_right = 0.0;
        p.R = 0.2;
        p.er = 2;
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'lens', p),className);
        


        px = 0.8;
        er = 2;
        p.point_x = px;
        p.point_y = 0.5;
        p.angle = pi/4;
        p.amplitude = er;
        S.er = S.er.*toClass(generateEpsilon(S.Nx, S.Ny, 'interface',p),className);
        p.point_x = px+0.6;
        p.amplitude = -1+1/(er+1);
        S.er = S.er.*toClass(generateEpsilon(S.Nx, S.Ny, 'interface',p),className);
        

        % first burst
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.2;
        S.sources_parameters{1}.cy = 0.5+pos+0.01;
        S.sources_parameters{1}.amplitude = 100;
        S.sources_parameters{1}.frequency = 120;
        S.sources_parameters{1}.time = 0;        

        S.sources_name{2} = 'sine';
        S.sources_parameters{2}.cx = 0.2;
        S.sources_parameters{2}.cy = 0.5+pos+0.01;
        S.sources_parameters{2}.amplitude = 100;
        S.sources_parameters{2}.frequency = 30;
        S.sources_parameters{2}.time = 0;  
        
    case 'optical ckt'
  
        % FD-TD grid
        S.Nx = round(2.2*810);
        S.Ny = 810;

        S.dy = 1/max([S.Ny S.Nx]);
        S.dx = S.dy;

        CLF = sqrt(inv(S.dx^2)+inv(S.dy^2));
        
        S.dt = 1/CLF;

        % Absorving boundaries
        p.L = 80;
        p.maxS = 150;
        S.s = toClass(generateConductivity(S.Nx, S.Ny, 'boundary', p),className);

        S.wire = ones(S.Ny,S.Nx,className);
        S.er = ones(S.Ny,S.Nx,className);
        S.ur = ones(S.Ny,S.Nx,className);
        
       
        aperture = 0.46;
        pos = 0.192;
        x = 0.3;
        p.upper_left_x = x;
        p.upper_left_y = 0.01;
        p.lower_right_x = x+0.05;
        p.lower_right_y = aperture+pos;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        p.upper_left_x = x;
        p.upper_left_y = 1-aperture+pos;
        p.lower_right_x = x+0.05;
        p.lower_right_y = 1-0.01;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);

        
        p.cx = 1.68;
        p.cy = 0.5;
        p.name = 'images/waveguide.png';
        p.imScale = 1;
        p.scale = 17;
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);
        
        p.cx = x-0.005;
        p.cy = 0.5+pos;
        p.imScale = 1;
        p.name = 'images/lens_small.png';
        p.scale = 4;        
        S.er = S.er.*toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);

        p.cx = 0.8;
        p.cy = 0.5;
        p.imScale = 1;
        p.name = 'images/fiber_curve.png';
        p.scale = 6;        
        S.er = S.er.*toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);
        
        
        %fiber
        p.upper_left_x = x+0.05;
        p.upper_left_y = aperture+pos;
        p.lower_right_x = 1.9;
        p.lower_right_y = 1-aperture+pos;
        p.value = 2;
        %S.er = S.er.*toClass(generateEpsilon(S.Nx, S.Ny, 'box', p),className);
      

%         S.sources_name{1} = 'periodic_burst';
%         S.sources_parameters{1}.cx = 0.15;
%         S.sources_parameters{1}.cy = 0.5+pos;
%         S.sources_parameters{1}.amplitude = 2000;
%         S.sources_parameters{1}.wave_frequency = 10*2.2;
%         S.sources_parameters{1}.burst_frequency = 0.5*2.2;
%         S.sources_parameters{1}.time = 0;      
%         S.sources_parameters{1}.sharpness = 60;    
%         S.sources_parameters{1}.displace_percentage = -0.99;
  
  
        % second burst
        S.sources_name{1} = 'burst';
        S.sources_parameters{1}.cx = 0.15;
        S.sources_parameters{1}.cy = 0.5+pos;
        S.sources_parameters{1}.amplitude = 2000;
        S.sources_parameters{1}.frequency = 2.2*10;
        S.sources_parameters{1}.width = 0.03;
        S.sources_parameters{1}.t0 =  0.1;
        S.sources_parameters{1}.time = 0;
        
        
    case 'optical fiber'
   
        aperture = 0.37;
        pos = 0.1;
        x = 0.4;
        p.upper_left_x = x;
        p.upper_left_y = 0.01;
        p.lower_right_x = x+0.07;
        p.lower_right_y = aperture+pos;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
        p.upper_left_x = x;
        p.upper_left_y = 1-aperture+pos;
        p.lower_right_x = x+0.07;
        p.lower_right_y = 1-0.01;
        p.value = 550;
        S.s = S.s + toClass(generateConductivity(S.Nx, S.Ny, 'box', p),className);
 
        p.cx = x;
        p.cy = 0.5+pos;
        p.name = 'images/lens.png';
        p.imScale = 1;
        p.scale = 4;        
        S.er = toClass(generateEpsilon(S.Nx, S.Ny, 'image',p),className);
 
        %fiber
        p.upper_left_x = x+0.05;
        p.upper_left_y = aperture+pos;
        p.lower_right_x = 1.9;
        p.lower_right_y = 1-aperture+pos;
        p.value = 2;
        S.er = S.er.*toClass(generateEpsilon(S.Nx, S.Ny, 'box', p),className);
       
 
        % first burst
        S.sources_name{1} = 'sine';
        S.sources_parameters{1}.cx = 0.15;
        S.sources_parameters{1}.cy = 0.5+pos+0.01-0.25;
        S.sources_parameters{1}.amplitude = 200;
        S.sources_parameters{1}.frequency = 50;
        S.sources_parameters{1}.time = 0;          
        
end


