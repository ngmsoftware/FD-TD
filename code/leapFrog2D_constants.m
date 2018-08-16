function [c1, c2, c3, c4] = leapFrog2D_constants(er, ur, s, dt)

    a = (1 - dt*s./(2*er));
    b = (1 + dt*s./(2*er));
    
    c1 = a./b;
    c2 = (dt./er)./b;
    
    c3 = dt./ur;
    c4 = dt./ur;

end