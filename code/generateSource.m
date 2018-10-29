function I = generateSource(Nx, Ny, type, parameters)

switch type 

    case 'plain_square_x'
        cx = parameters.cx; 
        A = parameters.amplitude;
        f = parameters.frequency;
        t = parameters.time;
        off = parameters.offset;
        
        I = zeros(Ny, Nx);
        
        I((1+off):(end-off), round(Ny*cx)) = A*atan(10*sin(2*pi*f*t))/pi;


        
        
        
    case 'plain_sine_x'
        cx = parameters.cx; 
        A = parameters.amplitude;
        f = parameters.frequency;
        t = parameters.time;
        off = parameters.offset;
        
        I = zeros(Ny, Nx);
        
        I((1+off):(end-off), round(Ny*cx)) = A*sin(2*pi*f*t);
    case 'sine'
        cx = parameters.cx; 
        cy = parameters.cy;
        A = parameters.amplitude;
        f = parameters.frequency;
        t = parameters.time;
        
        I = zeros(Ny, Nx);
        
        I(round(Ny*cy), round(Ny*cx)) = A*sin(2*pi*f*t);

        
    case 'sweep'
        cx = parameters.cx; 
        cy = parameters.cy;
        A = parameters.amplitude;
        f = parameters.frequency;
        df = parameters.deltaFrequency;
        t = parameters.time;
        
        I = zeros(Ny, Nx);
        
        I(round(Ny*cy), round(Ny*cx)) = A*sin(2*pi*(f+t*df)*t);
        

        
    case 'rotating_sin'
        cx = parameters.cx; 
        cy = parameters.cy;
        A = parameters.amplitude;
        f = parameters.frequency;
        w = parameters.angularVelocity;
        r = parameters.rotationRadius;
        t = parameters.time;
        
        I = zeros(Ny, Nx);
        
        I(round(Ny*(cy+r*cos(w*t))), round(Ny*(cx+r*sin(w*t)))) = A*sin(2*pi*f*t);

        for i=1:10
            I = conv2(I,[0 1 1 0; 1 1 1 1; 1 1 1 1; 0 1 1 0]/12,'same');
        end
        
        
        
    case 'pulse'
        cx = parameters.cx; 
        cy = parameters.cy;
        A = parameters.amplitude;
        t0 = parameters.t0;
        s2 = parameters.width^2;
        t = parameters.time;
        
        I = zeros(Ny, Nx);
        
        I(round(Ny*cy), round(Ny*cx)) = A*exp(-(t-t0).^2/(2*s2));

    case 'burst'
        cx = parameters.cx; 
        cy = parameters.cy;
        A = parameters.amplitude;
        t0 = parameters.t0;
        s2 = parameters.width^2;
        t = parameters.time;
        f = parameters.frequency;
        
        I = zeros(Ny, Nx);
        
        I(round(Ny*cy), round(Ny*cx)) = A*sin(2*pi*f*t)*exp(-(t-t0).^2/(2*s2));

    case 'periodic_burst'
        cx = parameters.cx; 
        cy = parameters.cy;
        A = parameters.amplitude;
        t = parameters.time;
        f1 = parameters.wave_frequency;
        d = parameters.displace_percentage;
        f2 = parameters.burst_frequency;
        s = parameters.sharpness;
        
        I = zeros(Ny, Nx);
        
        I(round(Ny*cy), round(Ny*cx)) = A*sin(2*pi*f1*t).*(0.5+(atan(s*(sin(2*pi*f2*t)+d))/pi)) ;

end    

end