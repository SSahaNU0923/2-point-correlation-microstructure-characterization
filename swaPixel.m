function [In] = swaPixel(I,numswap)
[m,n]=size(I);
Zind = zeros(n,1); %creates index values storage
Vind = zeros(n,1);
ind1 = 1;
ind0 = 1;
for i=1:m
for j=1:n
if I(i,j) == 0
Zind(ind0) = sub2ind([m,n],i,j);
ind0=ind0+1;
else
Vind(ind1) = sub2ind([m,n],i,j);
ind1 = ind1+1;
end
end
end
for i = 1:numswap
tempz = randi(numel(Zind)); %gets random index of zero element
temp1 = randi(numel(Vind));
p = I(ind2sub([m,n],tempz));
I(ind2sub([m,n],tempz))=I(ind2sub([m,n],temp1));
I(ind2sub([m,n],temp1))= p;
end
In = I;
end