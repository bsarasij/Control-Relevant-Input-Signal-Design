%This script is just a function form of the Main_MultiSin_LS
%Called by sig_generator script
%Sarasij Banerjee, 5/22/23


%   MultiSin_cust This function generates a Pseudo-Random Multi sines signal
%   based on the following Specifications:
%   T : Sampling time
%   Amp: Signal amplitude (+/-).
%   Deadtime: Deadtime at the beginning of the sequence
%   FinalDeadtime: Deadtime at the end of the sequence
%   SignalBias: Added bias to the signal
%   MultiRelMags: relative magnitudes of the frequencies with non-zero
%   power (ns)
%   MultisineSeqLength: Length of Signal (Ns)

% As an output the input signal sequence is obtained
%   u: The input signal sequence
%   t: The time associated with the designed input signal
%   To run this function crest2 effval four2time msinl2p randomphase MSfunc lnorm are needed 

%MSINL2P This function minimizes the L2p-norm of a multisine.
% Use X=msinl2p(p,X,Nmax,Fa,W,H,iterno,relerr) with
%		Input arguments :
%		-	p  : Value of p in L2p
%		-	X  : Matrix with input spectra (1=DC)
%		-	Nmax   : Max. number of points in time domain               <- May have to put some logic in to handle this MWB 
%		-	Fa : Set of the additional harmonic numbers (DC = 1)
%									(auto power spectrum not restricted)
%  - W  : Weighting row vector, e.g., W=[1 2];
%         shortcuts :  W=0 -> same crest factors (default)
%                      W=1 -> same amplitudes
%		-	H  : Transfer function matrix 
%									(no.row=no.freq.;no.col.=1 (SISO version))
%  - iterno : Max. number of iterations
%		-	relvar : Max. relative variation of L2p-norm
%		Output arguments :
%		-	X  : Matrices with optimal input spectra
% Example :      X=ones(32,1);X(1)=0; % X(1) -> DC
%                p=2;
%                while p<200
%                   X=msinl2p(p,X,2048,[],0,[],10,1e-6);
%                   p=ceil(p*2);
%                end
% See also SCHROEDER, CREST1, CREST2.




% load magval_abs3.mat

function [design_signal]= Main_MultiSin_LS_func(magval_abs,T,Amp,Deadtime,FinalDeadtime,SignalBias,MultisineSeqLength,Cycles)


%crest Factor 
MaxIter=20;
MaxVar=1e-6;
Maxp=600;

MultiRelMags=magval_abs;

minSeqLength = 2*length(MultiRelMags);


if MultisineSeqLength < minSeqLength
    disp(['Multisine: Sequence length is shorter than 2x the length of custom amplitude vector.Sequence Length must be greater or equal to ',num2str(minSeqLength),'.']);
    error("adjust sequence length");
end

MultisineSinusoids=length(MultiRelMags);

[sig_val,sig_t]=MultiSin_cust(T,Amp,Deadtime,FinalDeadtime,SignalBias,Cycles,MaxIter,MaxVar,Maxp,MultiRelMags,MultisineSeqLength);

sig_v=(sig_val-min(sig_val))/(max(sig_val)-min(sig_val)); %scale from 0 to 1
% sig_t=sig_t; %Time should not start from t=0

mypsd(sig_v,MultisineSeqLength,T)
% figure;hold on;stairs(sig_t,sig_v);hold off;

design_signal.t=sig_t;
design_signal.u=sig_v;
design_signal.SamplingTime=T;
design_signal.AmplitudeScaling=Amp;
design_signal.MultiRelMags=MultiRelMags;
design_signal.MultisineSeqLength=MultisineSeqLength;
design_signal.MaxIter=MaxIter;
design_signal.MaxVar=MaxVar;
design_signal.Maxp=Maxp;

end
% sig_cell{2}=design_sigal
% save design_signa3.mat design_sigal

%% Function for generating the signal


function [u,t] = MultiSin_cust(T,Amp,Deadtime,FinalDeadtime,SignalBias,Cycles,MaxIter,MaxVar,Maxp,MultiRelMags,MultisineSeqLength)    

    if isnumeric(Cycles)~=1
        warning('A numeric value for the number of cycles must be entered.')
        return
    end
    
    if Cycles<1
        warning('Number of cycles must be >= 1.')
        return
    end
    
    
    

%   Minimum Crest Factor
    MultiRelMags = randomphase(MultiRelMags); % First randomize the phases
    p = 2; % p is the p in l_p     
    while p < Maxp                  
        
        MultiRelMags=msinl2p(p,MultiRelMags,2048,[],0,[],MaxIter,MaxVar);
        
        p=ceil(p*2);
    end
    

        

    u=four2tim(MultiRelMags,MultisineSeqLength);
    
    uOneCycle=Amp*(2*u/(max(u)-min(u))+(1-2/(max(u)-min(u))*max(u)))+SignalBias;
    tOneCycle=0:T:MultisineSeqLength*T-T;
    
    
    u=Amp*(2*u/(max(u)-min(u))+(1-2/(max(u)-min(u))*max(u)))+SignalBias;
    u=([zeros(Deadtime/T,1); repmat(u,Cycles,1); zeros(FinalDeadtime/T,1)]);
    disp(length(u))
    t=0:T:(Deadtime+FinalDeadtime+MultisineSeqLength*T*Cycles-T);
    t=t';
end

