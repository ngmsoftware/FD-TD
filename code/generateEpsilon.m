function I = generateEpsilon(Nx, Ny, type, parameters)

[x, y] = meshgrid(linspace(0,Nx/Ny,Nx), linspace(0,1,Ny));


switch type 
   
    case 'lens'
        cx = parameters.cx; 
        cy = parameters.cy;
        r2 = parameters.r_left;
        r1 = parameters.r_right;
        R = parameters.R;
        er = parameters.er;
        
        xx1 = (R^2-r1^2)/(2*r1);
        Cr1 = xx1+r1;
        xx2 = (R^2-r2^2)/(2*r2);
        Cr2 = xx2+r2;
        
        
        I = er*(  ( (((x-(cx-xx1)).^2+(y-cy).^2) < Cr1^2)  +   (x>cx) ) > 1    );
        I = I + er*(  ( (x<cx)  +   (((x-(cx+xx2)).^2+(y-cy).^2) < Cr2^2) ) > 1    );
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = 1+conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');

    case 'lens2'
        
        cx = parameters.cx; 
        cy = parameters.cy;
        lensTickness = parameters.lensTickness;
        angle = parameters.angle;
        lensHeight = parameters.lensHeight;
        er = parameters.er;

        R = (lensTickness^2+lensHeight^2)/(2*lensTickness);
        
        c1x = cx + (R-lensTickness)*cos(angle);
        c1y = cy + (R-lensTickness)*sin(angle);
        c2x = cx - (R-lensTickness)*cos(angle);
        c2y = cy - (R-lensTickness)*sin(angle);
        
        I = er*(  ( ((x-c1x).^2+(y-c1y).^2)<R^2 )&( ((x-c2x).^2+(y-c2y).^2)<R^2 )    );
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        I = conv2(I,[0 1 0; 1 1 1; 0 1 0]/5,'same');
        
        
    case 'plane_x'
        cx = parameters.cx; 
        er = parameters.er;
        width = parameters.width;
        
        I = ones(Ny,Nx);
        
        I(:,round((Ny*cx):(Ny*(cx+width)))) = er;
        
    case 'image'
        name = parameters.name;
        cx = parameters.cx; 
        cy = parameters.cy;
        scale = parameters.scale;
        imScale = parameters.imScale;
        
        Ifile = imread(name);
        Ifile = imresize(Ifile,imScale);
        Ifile = double(Ifile(:,:,1));
        Ifile = Ifile(end:-1:1,:);
        
        I = 1 + scale*placeSubImage(Nx, Ny, cx*Ny, cy*Ny, Ifile)/255;
       
        
    case 'percolation'
        ulx = 1+fix(Ny*parameters.upper_left_x);
        uly = 1+fix(Ny*parameters.upper_left_y);
        lrx = 1+fix(Ny*parameters.lower_right_x*.999);
        lry = 1+fix(Ny*parameters.lower_right_y*.999);
        p = parameters.percent;
        a = parameters.amplitude;
        s = parameters.scale;
        
        I = ones(Ny,Nx);
        
        B = zeros(size(I(uly:lry,ulx:lrx)));
        
        C = imresize(B,s);
        
        C = fix(rand(size(C))<p);
        
        B = imresize(C,size(B))>0.5;
        
        I(uly:lry,ulx:lrx) = 1+a*B;
   
    case 'interface'
        A = parameters.amplitude;
        a = parameters.angle;
        px = x-parameters.point_x;
        py = y-parameters.point_y;
        
        I = 1+(-(px*cos(a)-py*sin(a))<0)*A;

    case 'box'
        ulx = 1+fix(Ny*parameters.upper_left_x);
        uly = 1+fix(Ny*parameters.upper_left_y);
        lrx = 1+fix(Ny*parameters.lower_right_x);
        lry = 1+fix(Ny*parameters.lower_right_y);
        value = parameters.value;
        
        I = ones(Ny,Nx);
        
        I(uly:lry,ulx:lrx) = 1+value;            
end


end