%Generates signals for all 18 days
%Called after weight_func
clear;clc;
load mag_speed_5_ts_5_mins_Nhour_10_n_cyc_6.mat

T=60*5; %Sampling every 5*60 sec
Amp=1;
Deadtime=0;
FinalDeadtime=0;
SignalBias=0;
n_cyc=6;%12; % n_cyc dictates how many cycles is the 660 mins broken down into. This is to say the length of each cycle. Use the same as the notch filter live script
Nhour=10; % Refer to notch modified script
MultisineSeqLength=Nhour*60*60/n_cyc/T;
Cycles=n_cyc; %number of cycles to generate




for i=1:18
    sig_cell{i}=Main_MultiSin_LS_func(magval_abs,T,Amp,Deadtime,FinalDeadtime,SignalBias,MultisineSeqLength,Cycles);
end

% figure;hold on;
% for i=1:18
%     plot3(sig_cell{i}.t,i*ones(length(sig_cell{i}.u),1),sig_cell{i}.u);
% end
% hold off

% save sig_speed_5_ts_5_mins_Nhour_10_n_cyc_6.mat sig_cell
%Call Initialization_input_signal after this

% figure;stairs(sig_cell{i}.t(1:MultisineSeqLength),sig_cell{i}.u);xlabel("Time(Mins)");ylabel("CO2_{scaled}");xlim([0,length(sig_cell{i}.u)]);title("Control-Relevant Input Signal for pH")
 
figure;stairs(sig_cell{i}.t(1:MultisineSeqLength)/60,sig_cell{i}.u(1:MultisineSeqLength)*7);xlabel("Time(Mins)");ylabel("CO2_{scaled}");title("Control-Relevant Input Signal for pH")

test_sig=sig_cell{1,1}
trapz(test_sig.t,test_sig.u*7)


abc=sig_cell{i}.u(1:MultisineSeqLength)*7
load proc_model_day_9.mat
G_min= P1D(1);
Ts = 5*60;
G_c=chgTimeUnit(G_min,'seconds');
G_idtf=idtf(G_c);
G = c2d(G_idtf,Ts);
y_sim=lsim(G,abc,sig_cell{i}.t(1:MultisineSeqLength));
figure;stairs(y_sim)