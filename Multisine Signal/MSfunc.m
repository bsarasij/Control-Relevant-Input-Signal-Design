function MSfunc
SamplingTime = 1;
AmplitudeScaling=1;
Deadtime=0;
FinalDeadtime=0;
SignalBias = 0;

MultisineCycles=1;
MultiAlpha=2;
                    
MultiBeta=2;

MultiTauDomLo=1;

MultiTauDomHi=2;

MultisineSinusoidsOpt=0;

%crest Factor 
MaxIter=20;
                
MaxVar=1e-6;

Maxp=600;

OmegaLow = 1/(MultiBeta*MultiTauDomHi);
OmegaHi = MultiAlpha/MultiTauDomLo;

NsLow = max([2*MultisineSinusoidsOpt ceil(2*pi/(1/(MultiBeta*MultiTauDomHi)*SamplingTime))]);

MultisineSeqLength = ceil(NsLow/2)*2;

Lambda = MultiTauDomLo/MultiAlpha;
alp    = exp(-SamplingTime/MultiTauDomLo); 
delta  = exp(-1.55*SamplingTime/Lambda);
fnum = conv([1 -delta^2],[1 -alp]);
fnum = (1-delta)^2*[0 0 fnum]; 
fden = conv([1 -delta],[1 -delta]);
fden = conv(fden,fden);
fp   = 2*pi*(1:MultisineSeqLength)/MultisineSeqLength;
H    = freqz(fnum,fden,fp);  %%%%%%%%%%%%%%%%%%%%%% This makes it require the signal processing toolbox!!!!  %%%%%%%%%%%%%%%
ff   = fp(1:MultisineSeqLength/2)/SamplingTime;
MultiRelMags  = abs(H(1:MultisineSeqLength/2))';
MultisineSinusoids=length(MultiRelMags);


MultiRelMags = randomphase(MultiRelMags); 

p = 2; % p is the p in l_p     
while p < Maxp                  
    
    MultiRelMags=msinl2p(p,MultiRelMags,2048,[],0,[],20,1e-6);
    
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
    
    p=ceil(p*2);
end

u=four2tim(MultiRelMags,MultisineSeqLength);

uOneCycle=AmplitudeScaling*(2*u/(max(u)-min(u))+(1-2/(max(u)-min(u))*max(u)))+SignalBias;
tOneCycle=0:SamplingTime:MultisineSeqLength*SamplingTime-SamplingTime;


u=AmplitudeScaling*(2*u/(max(u)-min(u))+(1-2/(max(u)-min(u))*max(u)))+SignalBias;
u=([zeros(Deadtime/SamplingTime,1); repmat(u,MultisineCycles,1); zeros(FinalDeadtime/SamplingTime,1)]);
t=0:SamplingTime:(Deadtime+FinalDeadtime+MultisineSeqLength*SamplingTime*MultisineCycles-SamplingTime);
t=t';
end