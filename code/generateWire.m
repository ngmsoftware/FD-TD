function I = generateWire(Nx, Ny, type, parameters)

%  1 = empty space
%  0 = metal

[x, y] = meshgrid(linspace(0,Nx/Ny,Nx), linspace(0,1,Ny));


switch type 
   
    case 'parabolic_reflector'
        fx = parameters.focus_x; 
        fy = parameters.focus_y;
        bd = parameters.base_dist; 
        w = parameters.width;
        a = -parameters.angle;
        lD = parameters.limit_D;

        base_x = fx-bd*cos(a);
        base_y = fy-bd*sin(a);
        
        D1 = sqrt((x-fx).^2+(y-fy).^2);
        
        px = x-base_x;
        py = y-base_y;
        
        cx = cos(a);
        cy = sin(a);
        
        D2 = px*cx+py*cy;
        
        I = abs(D1-D2)>(0.5*w./(abs(D1).^0.5+.25)) | (D1>lD);

    case 'circular_reflector'
        cx = parameters.cx; 
        cy = parameters.cy;
        r = parameters.r;
        w = parameters.width;
        a = parameters.angle;
        
        I = -(x-cx)*cos(a)-(y-cy)*sin(a)>0;
        
        I = 1 - (I & xor( (((x-cx).^2 + (y-cy).^2) < r^2) , (((x-cx).^2 + (y-cy).^2) < (r+w)^2) ));        
        
    case 'fss_x'
        cx = parameters.cx; 
        wv = parameters.wire_vector;

        I = ones(Ny,Nx);
        
        Nv = length(wv);
        
        for i=1:Nv
            ji = fix((Ny/Nv)*(i-1))+1;
            jf = fix((Ny/Nv)*i);
            if jf>Ny
                jf = Ny;
            end
            I(ji:jf,round(cx*Ny)) = wv(i);            
        end
        
    case 'box'
        ulx = 1+fix(Ny*parameters.upper_left_x);
        uly = 1+fix(Ny*parameters.upper_left_y);
        lrx = 1+fix(Ny*parameters.lower_right_x);
        lry = 1+fix(Ny*parameters.lower_right_y);
        
        I = ones(Ny,Nx);
        
        I(uly:lry,ulx:lrx) = 0;
        
        
end



end