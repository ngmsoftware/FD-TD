function s = generateConductivity(Nx, Ny, type, parameters)

[x, y] = meshgrid(linspace(0,Nx/Ny,Nx), linspace(0,1,Ny));


switch type 
   
    case 'boundary'
        sx = zeros(Ny,Nx);
        sy = zeros(Ny,Nx);

        L = parameters.L;
        MaxS = parameters.maxS;

        id = (1:L)';
        o1 = ones(1,Nx);
        sx(L:-1:1,:) = MaxS*(id(:,o1)./L).^2;
        sx(end-L+1:end,:) = MaxS*(id(:,o1)./L).^2;

        id = (1:L);
        o1 = ones(Ny,1);
        sy(:,L:-1:1) = MaxS*(id(o1,:)./L).^2;
        sy(:,end-L+1:end) = MaxS*(id(o1,:)./L).^2;

        Nspikes = 10;
        slx = cos(Nspikes*2*pi*x).^2;
        sly = cos(Nspikes*2*pi*y).^2;

        
        
        
        
        s = (sx.*slx + sy.*sly) + ((sx+sy).^2)/MaxS;  
        
        
    case 'image'
        name = parameters.name;
        cx = parameters.cx; 
        cy = parameters.cy;
        scale = parameters.scale;
        
        Ifile = imread(name);
        Ifile = double(Ifile(:,:,1));
        Ifile = Ifile(end:-1:1,:);
        
        s = scale*placeSubImage(Nx, Ny, cx*Ny, cy*Ny, Ifile)/255;
        
    case 'box'
        ulx = 1+fix(Ny*parameters.upper_left_x);
        uly = 1+fix(Ny*parameters.upper_left_y);
        lrx = 1+fix(Ny*parameters.lower_right_x);
        lry = 1+fix(Ny*parameters.lower_right_y);
        value = parameters.value;
        
        s = zeros(Ny,Nx);
        
        s(uly:lry,ulx:lrx) = value;        
        
end




end


