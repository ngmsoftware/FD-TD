function Io = placeSubImage(Nx, Ny, cx, cy, Ii)

    [Hi, Wi] = size(Ii);

    Io = zeros(Ny, Nx);
    
    if (cx<=Wi/2) || ((Nx-cx)<=Wi/2) || (Ny<=(Hi/2)) || ((Ny-cy)<=(Hi/2))
        warning('Image place forbidden');
        Io = [];
    else
        Io(fix(cy+(1:Hi)-Hi/2),fix(cx+(1:Wi)-Wi/2)) = Ii(end:-1:1,:);
    end
end