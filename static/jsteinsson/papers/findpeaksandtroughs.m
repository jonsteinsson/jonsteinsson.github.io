function [peaks,troughs] = findpeaksandtroughs(u,size)

T           =length(u);
peaks       =zeros(T,1);
troughs     =zeros(T,1);

% Initial Conditions
% Finding the first peak
firstpeak=0;
candidate=1;
t        =1;
while firstpeak==0
t        =t+1;
if u(t)<u(candidate)
    candidate=t;
else % u(t)>=u(candidate)
if u(t)>=u(candidate)+size % u has increased by more than x since our candidate for peak
    firstpeak=candidate;
end
end
end

% Finding the first trough
firsttrough=0;
candidate  =1;
t          =1;
while firsttrough==0
t        =t+1;
if u(t)>u(candidate)
    candidate=t;
else % u(t)<=u(candidate)
if u(t)<=u(candidate)-size % u has decreased by more than x since our candidate for trough
    firsttrough=candidate;
end
end
end

% Inititial search depending on date first peak and date first trough
if firstpeak<=firsttrough
    lookingfor='peak';%t=1 is a candidate for a peak
else
    lookingfor='trough';%t=1 is a candidate for a trough
end

candidate = 1;

for t=2:T
   if strcmp(lookingfor,'peak')% if we are looking for a peak
        if u(t)<u(candidate)
            candidate=t;% our candidate for a peak becomes t
        else % u(t)>=u(candidate)
        if u(t)>=u(candidate)+size % u has increased by more than x since our candidate for peak
            peaks(candidate)=1; %our candidate is a peak indeed
            lookingfor        ='trough';% we now look for a trough
            candidate         =t;% t is the first candidate for such a trough
        end
        end
   end
   if strcmp(lookingfor,'trough')% if we are looking for a trough
        if u(t)>u(candidate)
            candidate=t;% our candidate for a trough becomes t
        else % u(t)<=u(candidate)
        if u(t)<=u(candidate)-size % u has decreased by more than x since our candidate for trough
            troughs(candidate)=1; %our candidate is a trough indeed
            lookingfor        ='peak';% we now look for a peak
            candidate         =t;% t is the first candidate for such a peak
        end
        end
   end       
end

% Final call
if strcmp(lookingfor,'trough')
   troughs(candidate)=1;
end
if strcmp(lookingfor,'peak')
   peaks(candidate)=1;
end

end

