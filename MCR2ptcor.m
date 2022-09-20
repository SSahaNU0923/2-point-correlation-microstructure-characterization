% master script for two-point correlation MCR of binary image
% assumes
function [optImg,History] = MCR2ptcor(IMG,tolerance,rate,maxIter,cycle, Tinit)
binImg = IMG;
Star = TwoPIso(binImg);
phsfrac = Star(1,2);
% if there are more zeros than ones, then it will be faster to characterize
% with respect to the zeros, so invert and then invert back at the end.
% invertFlag tracks if there are more zeros or ones
invertFlag = 1;
if phsfrac > 0.5
binImg = mod(binImg+1,2);
Star = TwoPIso(binImg);
invertFlag = 0;
end
% create a randomized binary matrix with the same phase fraction as IMG
Ainit = zeros(length(binImg));
Ainit( randperm(numel(Ainit),ceil(phsfrac*numel(Ainit)))) = 1;
Sinit = TwoPIso(Ainit);
[Sopt,optImg,History] = simAF2(Star,Sinit,Ainit,tolerance,rate,maxIter,cycle,Tinit);
if invertFlag == 0
optImg = mod(binImg+1,2);
end
plot(Star(:,1),Star(:,2),'-r');
hold on
plot(Sopt(:,1),Sopt(:,2),'-b');
end