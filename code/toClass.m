function A = toClass(B, className)

switch className 
    
    case 'double'
        A = B;
        
    case 'gpuArray'
        A = gpuArray(B);
end