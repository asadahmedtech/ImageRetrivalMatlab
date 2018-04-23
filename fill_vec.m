% function to get 58 from 256 and add 1 to get 59
function comp_vec = fill_vec(ltrp,vec)
vec1 = imhist(ltrp);
prod = size(ltrp,1) * size(ltrp,2);
vec1 = vec1./prod;
comp_vec = zeros(59,1);
% for 58
k = 1;
for i = 1 : 256
    if(vec(i) == 1)
     comp_vec(k) = vec1(i);
     k = k + 1;
    end    
end
for i = 1 : 256
    if(vec(i) == 0 )
        comp_vec(k) = comp_vec(k) + vec1(i);
    end
end
%disp(comp_vec);
end