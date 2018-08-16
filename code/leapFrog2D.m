function [Ezo, Hxo, Hyo] = leapFrog2D(Ezi, Hxi, Hyi, parameters)

    Ezo = Ezi;
    Hxo = Hxi;
    Hyo = Hyi;


    c1 = parameters.c1;
    c2 = parameters.c2;
    c3 = parameters.c3;
    c4 = parameters.c4;
    dx = parameters.dx;
    dy = parameters.dy;
    boundary = parameters.boundary; 
    wire = parameters.wire;
    
   
    Nx = size(Ezi,1);
    Ny = size(Ezi,2);
    
    switch (boundary)
        case 1
            i_p_0_E = 1:Nx-1;
            j_p_0_E = 1:Ny-1;

            i_p_1_E = 2:Nx;
            j_p_1_E = 2:Ny;

            i_p_0_H = 1:Nx-1;
            j_p_0_H = 1:Ny-1;

            i_p_1_H = 2:Nx;
            j_p_1_H = 2:Ny;
        case 2
            i_p_0_E = 1+mod(1:Nx,Nx);
            j_p_0_E = 1+mod(1:Ny,Ny);
    
            i_p_1_E = 1+mod(2:Nx+1,Nx);
            j_p_1_E = 1+mod(2:Ny+1,Ny);

            i_p_0_H = 1+mod(1:Nx,Nx);
            j_p_0_H = 1+mod(1:Ny,Ny);
    
            i_p_1_H = 1+mod(2:Nx+1,Nx);
            j_p_1_H = 1+mod(2:Ny+1,Ny);
    end

   
    % transverse electric
  
    Ezo(i_p_1_E, j_p_1_E) = c1(i_p_1_E, j_p_1_E).*Ezi(i_p_1_E, j_p_1_E) + c2(i_p_1_E, j_p_1_E).*(  ( wire(i_p_1_E, j_p_1_E).*Hyi(i_p_1_E, j_p_1_E) - wire(i_p_0_E, j_p_1_E).*Hyi(i_p_0_E, j_p_1_E) )/dx - ( wire(i_p_1_E, j_p_1_E).*Hxi(i_p_1_E, j_p_1_E) - wire(i_p_1_E, j_p_0_E).*Hxi(i_p_1_E, j_p_0_E) )/dy   );

    Hxo(i_p_0_H, j_p_0_H) = Hxi(i_p_0_H, j_p_0_H) + c3(i_p_0_H, j_p_0_H).*(   ( wire(i_p_0_H, j_p_0_H).*Ezo(i_p_0_H, j_p_0_H) - wire(i_p_0_H, j_p_1_H).*Ezo(i_p_0_H, j_p_1_H) )/dy   );
    Hyo(i_p_0_H, j_p_0_H) = Hyi(i_p_0_H, j_p_0_H) + c4(i_p_0_H, j_p_0_H).*(   ( wire(i_p_1_H, j_p_0_H).*Ezo(i_p_1_H, j_p_0_H) - wire(i_p_0_H, j_p_0_H).*Ezo(i_p_0_H, j_p_0_H) )/dx   );
end