function [S] = TwoPointCor(A)
[m,n] = size(A);
% rad is list of all radii
rad = zeros((m*n)*(m*n-1)/2,1);
% values is list for all these radii which are between phase of interest, 1
values = zeros((m*n)*(m*n-1)/2,1);
ind = 1;
for i = 1:m*n
for j = i:m*n
rad(ind) = sqrt( (mod((i-1),n) - mod((j-1),n))^2 ...
+ (ceil(i/n) - ceil(j/n))^2 );
values(ind) = A(i)*A(j);
ind = ind+1;
end
end
% Fin stores all the radii and "comparison" values, sorted by radius value
Fin = sortrows([rad values]);
p = size(Fin,1);
% unqR is the number of unqiue radii
unqR = size(unique(Fin),1);
% radii is the list of all the radius values
% count is the number of each radius in radii
% sum is the sum of the "comparison" values for each radius in radii
radii = zeros(unqR,1);
count = zeros(unqR,1);
sum = zeros(unqR,1);
count(1) = 1;
radii(1) = Fin(1,1);
sum(1) = Fin(1,2);
ind = 1;
for i = 1:p-1
if Fin(i,1) == Fin(i+1,1)
sum(ind) = sum(ind) + Fin(i+1,2);
count(ind) = count(ind) + 1;
else
ind = ind+1;
radii(ind) = Fin(i+1,1);
radii(ind-1) = (radii(ind-1) + Fin(i,1))/2;
sum(ind) = Fin(i+1,2);
count(ind) = 1;
sum(ind) = sum(ind) + Fin(i+1,2);
count(ind) = count(ind) + 1;
end
end
radii(ind-1) = (radii(ind-1) + Fin(p,1))/2;
prob = sum./count;
% phsfrac2 is one criteria for the max radius
phsfrac2 = (sum(1)/count(1))^2;
% find radius that has been above phsfrac2 for 50 radii
maxRind = 0;
low = 0;
higher = 0;
for i = 1:1:unqR
if prob(i) <= phsfrac2
low = 1;
maxRind = i;
higher = 0;
else
higher = higher + 1;
if (low == 1 && higher >= 50)
break;
end
end
%disp([i,low,higher,maxRind])
end
% radBin is average of radii in a single bin
% probBin is averaged probability over all radii in a single bin
radBin = zeros(ceil(0.5*(1+sqrt(1+8*maxRind)))-2,1);
sumBin = 0*radBin;
countBin = 0*radBin;
% binSize is number of radii values to be averaged in current bin
% binNum is number of radii stored in current bin
j = 1;
for binNum = 1:1:( floor(0.5*(1+sqrt(1+8*maxRind))) - 1)
radBin(binNum) = radii(j);
for binSize = 1:1:binNum
sumBin(binNum) = sumBin(binNum) + sum(j);
countBin(binNum) = countBin(binNum) + count(j);
j = j + 1;
end
radBin(binNum) = (radBin(binNum)+radii(j-1))/2;
end
probBin = sumBin./countBin;
S = [radBin,probBin];
end