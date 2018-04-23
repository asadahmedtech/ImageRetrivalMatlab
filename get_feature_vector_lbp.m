function feature_vector = get_feature_vector_lbp(patpic)

tpic=zeros(size(patpic,1),size(patpic,2)) ;  % find out y it had worked with 3 * 3
lbp=patpic;
lbp = 0 * lbp;
for i = 2 : size(patpic,1)-1
    for j = 2 : size(patpic,2)-1
        cur=patpic(i,j);
        tpic(i-1,j-1) = patpic(i-1,j-1) >= cur;
        tpic(i-1,j) = patpic(i-1,j) >= cur;
        tpic(i-1,j+1) = patpic(i-1,j+1) >= cur;
        tpic(i,j+1) = patpic(i,j+1) >= cur;
        tpic(i+1,j+1) = patpic(i+1,j+1) >= cur;
        tpic(i+1,j) = patpic(i+1,j) >= cur;
        tpic(i+1,j-1) = patpic(i+1,j-1) >= cur;
        tpic(i,j-1) = patpic(i,j-1) >= cur;
        %  anticlockwise
         lbp(i,j)=tpic(i-1,j-1) * 2^3 + tpic(i-1,j) * 2^2 + tpic(i-1,j+1) * 2^1 + tpic(i,j+1) * 2^0 + tpic(i+1,j+1) * 2^7 + tpic(i+1,j) * 2^6 + tpic(i+1,j-1) * 2^5 + tpic(i,j-1) * 2^4;
    end
end
%figure,imshow(lbp);
vec = zeros(256,1);
vec = compress(vec);
vec1 = fill_vec(lbp,vec);
feature_vector = vec1;
end
