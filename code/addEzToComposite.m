function Io = addEzToComposite(Ii, Ez, M)

    Ezs = 40*Ez+130;
    
%     beta = 8;
%     ItmpR = 255*(pi/2+atan(beta*(60-Ezs)/255))/pi;
%     ItmpG = zeros(size(Ezs));
%     ItmpB = 255*(pi/2+atan(beta*(Ezs-190)/255))/pi;
% 
%     Io = uint8(cat(3,ItmpR,ItmpG,ItmpB)/2 + double(Ii));
    
    Io = uint8(255*fastInd2RGB(uint8(Ezs),M) + double(Ii));
end

