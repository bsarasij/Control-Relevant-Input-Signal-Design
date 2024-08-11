clear;close all;clc
s=tf('s','TimeUnit','minutes');
Ts=1; % Sampling = 1 min 
load est_switch1.mat
iodat=est_switch1(540:1200,:); %Data from 9 am to 8 pm

io_iddat=iddata(iodat(:,1),iodat(:,2:end),Ts,'TimeUnit','minutes');


Fs = 1;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(io_iddat.y);             % Length of signal
tvec = (0:L-1)*T;        % Time vector

per=fft(io_iddat.y);
P2=abs(per/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure;loglog(f,P1) 
title("Single-Sided Amplitude Spectrum of pH(t)")
xlabel("f (Hz)")
ylabel("|CO2(f)|")


peri=fft(io_iddat.u(:,1));
P2i=abs(peri/L);
P1i = P2i(1:L/2+1);
P1i(2:end-1) = 2*P1i(2:end-1);
figure;loglog(f,P1i) 
title("Single-Sided Amplitude Spectrum of CO2(t)")
xlabel("f (Hz)")
ylabel("|CO2(f)|")


pert=fft(io_iddat.u(:,2));
P2t=abs(pert/L);
P1t = P2t(1:L/2+1);
P1t(2:end-1) = 2*P1t(2:end-1);
figure;loglog(f,P1t) 
title("Single-Sided Amplitude Spectrum of Temp(t)")
xlabel("f (Hz)")
ylabel("|Temp(f)|")

perr=fft(io_iddat.u(:,3));
P2r=abs(perr/L);
P1r = P2r(1:L/2+1);
P1r(2:end-1) = 2*P1r(2:end-1);
figure;loglog(f,P1r) 
title("Single-Sided Amplitude Spectrum of rad(t)")
xlabel("f (Hz)")
ylabel("|rad(f)|")

%%
% Implementing a high-pass filter to attain stationarity
io_iddatf = idfilt(io_iddat,5,0.037159,'high');%idfilt(io_iddat,5,0.031831,'high');

%Getting rid of transients 
io_iddatfe = io_iddatf([166:661]);         

%Fit a suitable model                                               
 Opt = arxOptions;                             
 na = 4;                                       
 nb = [4 4 4];                                 
 nk = [6 1 1];                                 
                                               
 arx446 = arx(io_iddatfe,[na,nb,nk], Opt);                                     



%Get the continuous version of the model
% figure;step(arx446);
c_arx446=d2c(arx446);
stepi=stepinfo(c_arx446);
outval=step(c_arx446);
ss_val=outval(end,:);
tau_val=0.632*ss_val;
t95_val=0.95*ss_val;
% figure;plot(c_arx446(:,1))

CustomStep2(c_arx446,[na nb nk],[1:1000],"Step_Arx446_Continuous")

%%
tau_all=[170,172,175]%;[92,77,100]; %Obtained from the step response plot
K_all=dcgain(c_arx446);
theta_all=[5,0,0];
s=tf('s','TimeUnit','minutes');
for i=1:3
    ptilde_all(i)=K_all(i)*exp(-theta_all(i)*s)/(tau_all(i)*s); % Tau*s+1 is rewritten as Tau*s as Tau>>1
end


ptilde=ptilde_all(1);
theta=theta_all(1);

pdel=ptilde.IODelay;
[z_pt,p_pt,k_pt]=zpkdata(ptilde);
z_pt_nonmin=z_pt{1}(find(real(z_pt{:})>0));
z_pt_min=z_pt{1}(find(real(z_pt{:})<=0));

p_nonmin=zpk(z_pt_nonmin,[],1)*exp(-pdel*s)%nonmin of ptilte
p_min=zpk(z_pt_min,p_pt,k_pt,'TimeUnit','minutes')%min of ptilte



lambda=5; %minutes
filt=((2*lambda+theta)*s+1)/(lambda*s+1)^2
eta=p_nonmin*filt
epsilon=1-eta
dist=1/s^2
Av_func=filt*epsilon*p_min^(-1)*dist %eta
%     Av_func.TimeUnit='minutes';





opts=bodeoptions;
opts.MagUnits='abs';
opts.MagScale='log';
opts.Xlim=[0.0001,100];
figure;bodemag(Av_func,opts);title(['Relative Magnitudes of the frequencies'])


Ns=660; %Length of the sequence( 11 hours of data)
ns=ceil(Ns/2);

omegavec=logspace(log10(2*pi/Ns/Ts),log10(pi/Ts),ns);
magval=freqresp(Av_func,omegavec);

magval=magval(:); 
magval_abs=abs(magval);


figure;loglog(omegavec,magval_abs);title('Relevant Magnitudes Plot (ns active frequencies)')

% save mag_vec_int4.mat magval_abs

% call sig generator script now


% Main_MultiSin_LS

tvec=hours(9):minutes(1):hours(20);
% figure;
% subplot(4,1,1);plot(tvec,io_iddat.y)
% xtickformat('hh:mm:ss')
% subplot(4,1,2);plot(tvec,io_iddat.u(:,1)*(60*1000))
% xtickformat('hh:mm:ss')
% subplot(4,1,3);plot(tvec,io_iddat.u(:,2))
% xtickformat('hh:mm:ss')
% subplot(4,1,4);plot(tvec,io_iddat.u(:,3))
% xtickformat('hh:mm:ss')

figure;
subplot(5,1,1);plot(tvec,io_iddat.y)
xtickformat('hh:mm:ss')
subplot(5,1,2);plot(tvec,io_iddat.u(:,1)*(60*1000))
xtickformat('hh:mm:ss')
subplot(5,1,3);plot(tvec,io_iddat.u(:,2))
xtickformat('hh:mm:ss')
subplot(5,1,4);plot(tvec,io_iddat.u(:,3))
xtickformat('hh:mm:ss')
subplot(5,1,5);plot(tvec,io_iddat.u(:,3))
xtickformat('hh:mm:ss')
