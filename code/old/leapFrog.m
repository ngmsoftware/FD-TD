function [E, H] = leapFrog(E, H, parameters)

    e = parameters.epsilon;
    u = parameters.mu;
    dt = parameters.dt;
    dx = parameters.dx;
    dy = parameters.dy;
    dz = parameters.dz;
    s = parameters.sigma;
    
    Nx = size(E.x,1);
    Ny = size(E.y,2);
    Nz = size(E.z,3);
    
    i_p_0 = 2:Nx-1;
    j_p_0 = 2:Ny-1;
    k_p_0 = 2:Nz-1;
    
    i_p_1 = 3:Nx;
    j_p_1 = 3:Ny;
    k_p_1 = 3:Nz;

    i_m_1 = 1:Nx-2;
    j_m_1 = 1:Ny-2;
    k_m_1 = 1:Nz-2;
    
    cte_sp = (1+(s*dt)/(2*e));
    cte_sm = (1-(s*dt)/(2*e));
    
    cte_t = cte_sm/cte_sp;

    cte_x = (dt/(u*dx));
    cte_y = (dt/(u*dy));
    cte_z = (dt/(u*dz));

    cte_x = cte_x/cte_sp;
    cte_y = cte_y/cte_sp;
    cte_z = cte_z/cte_sp;
    
    E.x(i_p_0, j_p_0, k_p_0) = cte_t*E.x(i_p_0, j_p_0, k_p_0) - cte_z*(  H.y(i_p_0, j_p_0, k_p_0) - H.y(i_p_0,j_p_0,k_m_1)  )  +  cte_y*(  H.z(i_p_0, j_p_0, k_p_0) - H.z(i_p_0,j_m_1,k_p_0)  );
    E.y(i_p_0, j_p_0, k_p_0) = cte_t*E.y(i_p_0, j_p_0, k_p_0) - cte_x*(  H.z(i_p_0, j_p_0, k_p_0) - H.z(i_m_1,j_p_0,k_p_0)  )  +  cte_z*(  H.x(i_p_0, j_p_0, k_p_0) - H.x(i_p_0,j_p_0,k_m_1)  );
    E.z(i_p_0, j_p_0, k_p_0) = cte_t*E.z(i_p_0, j_p_0, k_p_0) - cte_y*(  H.x(i_p_0, j_p_0, k_p_0) - H.x(i_p_0,j_m_1,k_p_0)  )  +  cte_x*(  H.y(i_p_0, j_p_0, k_p_0) - H.y(i_m_1,j_p_0,k_p_0)  );
    
    
    H.x(i_p_0, j_p_0, k_p_0) = H.x(i_p_0, j_p_0, k_p_0) + cte_z*(  E.y(i_p_0, j_p_0, k_p_1) - E.y(i_p_0,j_p_0,k_p_0)  )  -  cte_y*(  E.z(i_p_0, j_p_1, k_p_0) - E.z(i_p_0,j_p_0,k_p_0)  );
    H.y(i_p_0, j_p_0, k_p_0) = H.y(i_p_0, j_p_0, k_p_0) + cte_x*(  E.z(i_p_1, j_p_0, k_p_0) - E.z(i_p_0,j_p_0,k_p_0)  )  -  cte_z*(  E.x(i_p_0, j_p_0, k_p_1) - E.x(i_p_0,j_p_0,k_p_0)  );
    H.z(i_p_0, j_p_0, k_p_0) = H.z(i_p_0, j_p_0, k_p_0) + cte_y*(  E.x(i_p_0, j_p_1, k_p_0) - E.x(i_p_0,j_p_0,k_p_0)  )  -  cte_x*(  E.y(i_p_1, j_p_0, k_p_0) - E.y(i_p_0,j_p_0,k_p_0)  );

    

    
        E.x(Nx/2,Nx/2,:) = E.x(Nx/2,Nx/2,:) + sin(10*2*pi*n/Nt);
    H.y(Nx/2,Nx/2,:) = H.y(Nx/2,Nx/2,:) - sin(10*2*pi*(n-1)/Nt);

end