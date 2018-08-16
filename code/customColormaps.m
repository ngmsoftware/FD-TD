function [M1, M2, M3, M4] = customColormaps(name)

switch name
    case 'default'
        % custom colormaps
        beta = 8;
        M1 = zeros(255,3);
        M2 = zeros(255,3);
        M3 = zeros(255,3);
        M4 = zeros(255,3);
        for i=1:255
            M1(i,:) = [(pi/2+atan(beta*(60-i)/255))/pi 0 (pi/2+atan(beta*(i-196)/255))/pi];
            M2(i,:) = [(pi/2+atan(beta*(i-196)/255))/pi (pi/2+atan(beta*(i-196)/255))/pi (pi/2+atan(beta*(60-i)/255))/pi];
            M3(i,:) = [(pi/2+atan(beta*(i-128)/255))/pi (pi/2+atan(beta*(i-128)/255))/pi (pi/2+atan(beta*(i-128)/255))/pi];
            M4(i,:) = [0 (pi/2+atan(beta*(i-128)/255))/pi (pi/2+atan(beta*(i-128)/255))/pi];
        end
        M1 = M1/max(max(M1));
        M2 = M2/max(max(M2));
        M3 = M3/max(max(M3));
        M4 = M4/max(max(M4));
    
end