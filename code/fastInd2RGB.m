function Io = fastInd2RGB(Iidx, M)

    [Ny, Nx] = size(Iidx);

    IoR = Iidx(:);
    IoR = M(1+IoR,1);
    IoR = reshape(IoR,Ny,Nx);

    IoG = Iidx(:);
    IoG = M(1+IoG,2);
    IoG = reshape(IoG,Ny,Nx);
    
    IoB = Iidx(:);
    IoB = M(1+IoB,3);
    IoB = reshape(IoB,Ny,Nx);
    
    Io = cat(3, IoR, IoG, IoB);

end