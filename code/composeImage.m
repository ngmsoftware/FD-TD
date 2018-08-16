function I = composeImage(s, wire, er, M2, M3, M4)

%    Ezs = 40*Ez+130;
%    IEz = fastInd2RGB(uint8(Ezs),M1);

    Ss = s/2+128;
    Is = fastInd2RGB(uint8(Ss),M2);

    Ws = 255*(1-wire);
    Iw = fastInd2RGB(uint8(Ws),M3);

    Ers = 255*(er-1)/2;
    Ier = fastInd2RGB(uint8(Ers),M4);
        
    I = uint8(255*(Ier + Is + Iw)/2);
    
end