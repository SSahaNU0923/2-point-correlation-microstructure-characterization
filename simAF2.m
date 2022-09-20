% simAF2 is a simmulated annealing algorithm that attempts to reconstruct
% a binary image with the same two-point-correlation as a specified target
function [Sopt,Aopt,History] = simAF2(Star,Sinit,Ainit,tolerance,rate,maxIter,cycle,Tinit)
tic
% simAF2 takes as input the elements below
% STar is the target correlation of image
% A is the initial random binary image matrix
% S is the initial correlation of A
% tolerance a window of optimality for the solution
% rate is the rate of decrease of T with respect to iterations
% should be a value beween 0 and 1, higher is faster decrease.
% cycle is the number of iterations between checking for optimality
% maxIter is the maximum number of iterations, it is adjusted to the
% nearest multiple of cycle
maxIter = cycle*floor(maxIter/cycle);
% Sopt is the best correlation binning found
% Aopt is the binary matrix corresponding to Sopt
% Scur is the current correlation binning
% Acur is the binary matrix corresponding to Scur
Sopt = Sinit;
Aopt = Ainit;
Scur = Sinit;
Acur = Ainit;
History = Sinit;
% Errcur is the sum of squared error (SSE) between Scur and Star
Errcur = 0;
SC = 10^8;
% calculating the SSE between Star and S, initial error
for i = 1:(min(length(Star),length(Sinit)))
Errcur = Errcur + abs(Star(i,2) - Sinit(i,2)) ;
end
Errcur = SC*Errcur/(min(length(Star),length(Sinit)));
% Erropt is the SSE between Sopt and Star, want to minimize to zero
Erropt = Errcur;
% k and T help define the probability of accepting a less optimal solution
%k = 1.3806e-23;
T = Tinit;
% flag monitors if an optimum within tolerance is found
flag = 1;
numSwap = 10;
for j = 1:maxIter
tic
for i = 1:cycle
disp('error')
disp(Errcur*1e-4)
% swaPixel swaps numSwap pixels in Acur to make a new matrix, Atemp
Atemp = swaPixel(Acur,numSwap);
% TwoPIso calculates the correlation for Atemp
Stemp = TwoPIso(Atemp);
% Errtemp is the SSE between Scur and Stemp
Errtemp = 0;
for b = 1:(min(length(Star),length(Stemp)))
Errtemp = Errtemp + abs(Star(b,2) - Stemp(b,2));
end
Errtemp = SC*Errtemp/(min(length(Star),length(Stemp)));
% if the SSE of Atemp is larger than the SSE of Aopt
% there is a probability that Atemp is only our new Acur
% elseif the error of Atemp is only larger than the error of Aopt
% then Atemp is only our new Acur
% otherwise (SEE of Atemp is less than or equal to Aopt SSE)
% Atemp is both our new Acur and Aopt
if Errtemp > Errcur
% calculate a probability that we still
% accept Atemp as our new Acur
prob = exp( -(Errtemp-Errcur)/(T));
disp('prob')
disp(prob)
r = rand();
if prob > r
Acur = Atemp;
Scur = Stemp;
Errcur = Errtemp;
end
elseif Errtemp > Erropt
Acur = Atemp;
Scur = Stemp;
Errcur = Errtemp;
else %condition: Errtemp <= Erropt
Aopt = Atemp;
Acur = Atemp;
Sopt = Stemp;
Scur = Stemp;
Errcur = Errtemp;
Erropt = Errtemp;
end
end
toc
% T decreases every cycle, making it less likely to accept succesively
% worse Stemp/Atemp as our new Scur/Acur as iterations increase
T = T*(1-rate);
if numSwap > 1
numSwap = numSwap - 1;
end
History = [History, Sopt(:,2)];
% if the current Sopt is within tolerance of Star
% then accept current Aopt and Sopt as our optimum and stop looking
% otherwise
% keep looking for another cycle
if (Erropt*1e-4) < tolerance
flag = 0;
break;
end
end
% determine whether the current Sopt/Aopt are an optimum within tolerance
% or if no Sopt/Aopt within tolerance was found within the max iterations
if flag == 0
disp('Solution within tolerance found');
end
if flag == 1
disp('Max iterations reached before solution within tolerance found');
disp('Best solution found');
end
end