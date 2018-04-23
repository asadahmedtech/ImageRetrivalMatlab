function cmp_vec = compress(vec)
cmp_vec = vec;
% 256 
for i = 0 : 255 
    bin = de2bi(i,8);
    no = 0;
    prev = bin(1);
    for j = 2 : 8 
        if( bin(j) ~= prev)
            no = no + 1;
        end
        prev = bin(j);
    end
    if(prev ~= bin(1))
        no = no + 1;
    end
    if(no <= 2)
        cmp_vec(i+1) = 1;
    else
        cmp_vec(i+1) = 0;
    end
end   
end