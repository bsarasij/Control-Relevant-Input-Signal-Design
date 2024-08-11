clear
s=tf('s','TimeUnit','minutes');
Ts=1; % Sampling = 1 min 
load est_switch1.mat
iodat=est_switch1(540:1200,:); %Data from 9 am to 8 pm

% load ol_data2.mat
% iodat=ol_data(540:1200,:); %Data from 9 am to 8 pm


io_iddat=iddata(iodat(:,1),iodat(:,2:end),Ts,'TimeUnit','minutes');
mydataed = detrend(io_iddat,0);                       
Opt = procestOptions;                               


msg = "Integrator_Delay/FOPDT";
opts = ["Integrator" "First-Order"];
choice = menu(msg,opts);
if choice==1
    P0DI = procest(mydataed,{'P0DI', 'P0DI', 'P0DI'} , Opt);
    fitper=P0DI.Report.Fit.FitPercent;
    K=P0DI(1).Kp;
    theta=P0DI(1).Td;
    ptilde=exp(-theta*s)*K/s
else
    P1D = procest(mydataed,{'P1D', 'P1D', 'P1D'} , Opt);
    fitper=P1D.Report.Fit.FitPercent;
    K=P1D(1).Kp;
    theta=P1D(1).Td;
    taup=P1D(1).Tp1;
    ptilde=exp(-theta*s)*K/(taup*s+1)
end
pdel=ptilde.OutputDelay;
[z_pt,p_pt,k_pt]=zpkdata(ptilde);
z_pt_nonmin=z_pt{1}(find(real(z_pt{:})>0));
z_pt_min=z_pt{1}(find(real(z_pt{:})<=0));

p_nonmin=zpk(z_pt_nonmin,[],1)*exp(-pdel*s)%nonmin of ptilte
p_min=zpk(z_pt_min,p_pt,k_pt,'TimeUnit','minutes')%min of ptilte



if choice==1
    lambda=5;
    filt=((2*lambda+theta)*s+1)/(lambda*s+1)^2
    eta=p_nonmin*filt
    epsilon=1-eta
    dist=1/s^2
    Av_func=filt*epsilon*p_min^(-1)*dist %eta
%     Av_func.TimeUnit='minutes';
else
    lambda=2;
    filt2=1/(lambda*s+1)
    eta2=p_nonmin*filt2
    epsilon2=1-eta2
    r_set=1/s
    Av_func2=filt2*epsilon2*p_min^(-1)*r_set %eta
%     Av_func2.TimeUnit='minutes'
end
% eta*epsilon*ptilde^(-1)*dist




opts=bodeoptions;
opts.MagUnits='abs';
opts.MagScale='log';
opts.Xlim=[0.0001,100];
if choice==1
    figure;bodemag(Av_func,opts);title(['Relative Magnitudes of the frequencies. Fit= ' num2str(fitper)])
else
    figure;bodemag(Av_func2,opts);title(['Relative Magnitudes of the frequencies. Fit= ' num2str(fitper)])
end
Ns=660; %Length of the sequence( 11 hours of data)
ns=ceil(Ns/2);

omegavec=logspace(log10(2*pi/Ns/Ts),log10(pi/Ts),ns);

if choice==1
    magval=freqresp(Av_func,omegavec);
else
    magval=freqresp(Av_func2,omegavec);
end
magval=magval(:); 
magval_abs=abs(magval);


figure;loglog(omegavec,magval_abs);title('Relevant Magnitudes Plot (ns active frequencies)')
% if choice==1
%     save mag_vec_int2.mat magval_abs
% else
%     save mag_vec_fo2.mat magval_abs
% end

% call sig generator script now


% Main_MultiSin_LS