function [Puu,f]=mypsd(u,Ns,T,flag,mflag);   
% function [Puu,f]=psd(u,Ns,T);   
% FFT of input signal
%
if nargin ==3
   flag=1;
end

[m,n]= size(u);
if m>n
   u=u';  %always (channel) m <n (signal length)
   [m,n]= size(u);
end 

udata=u(:,1:Ns);
u=[];
u=udata;

fs=1/(T);
f=2*pi*fs*(1:(ceil(Ns/2)-1))/Ns;

U=[];
Puu=[];

for k=1:m
   U(k,:)=fft(u(k,:));
   Puu(k,:)=U(k,:).*conj(U(k,:))/Ns;
end

col=['k' 'r' 'b' 'm' 'g' 'c'];
shp=['p' 'x' 'o' '+' '*' 's' 'h'];

mc=length(col);
ms=length(shp);

%whos Puu f
%fidm=fopen('mypsdexec.m','wt+');
%fprintf(fidm,'function []=mypsedexec(f,Puu,Ns)');
%fprintf(fidm,'\nwhos f Puu');
%fprintf(fidm,'\nloglog(f,Puu(%d,2:ceil(Ns/2)),''%s%s''); hold on;',1,col(mod(k,mc)+1), shp(mod(k,ms)+1));

if flag==1
   if m>=1
      for k=1:m
         if k==1
            %fprintf(fidm,'\nloglog(f,Puu(%d,2:ceil(Ns/2)),''%s%s''); hold on;',k,col(mod(k,mc)+1), shp(mod(k,ms)+1));
            opt=sprintf('%s%s',col(mod(k,mc)+1), shp(mod(k,ms)+1));
            loglog(f,Puu(k,2:ceil(Ns/2)),opt,"LineWidth",1.5); hold on;
         else
            
            %fprintf(fidm,'\nloglog(f,Puu(%d,2:ceil(Ns/2)),''%s%s''); ',k,col(mod(k,mc)+1), shp(mod(k,ms)+1));
            opt=sprintf('%s%s',col(mod(k,mc)+1), shp(mod(k,ms)+1));
            loglog(f,Puu(k,2:ceil(Ns/2)),opt,"LineWidth",1.5);
         end
      end
   end
   

   
   %if flag ==1
   %figure;
   %pause(0.5);
   %pause(0.3);
   %mypsdexec(f,Puu,Ns);pause(0.3);
   title('Power Spectral Density');
   xlabel('Frequency \omega (rad/time)');
   %legend('PSD of input signal');
   ylabel('|U(j\omega)|^2');
   %axis([10^-3 10^1 10^-5 10^5]) %Axis for hf=0
   
   axis([f(1)*0.7 f(ceil(Ns/2)-1)*1.5 max(Puu(1,:))*10^-3 max(Puu(1,:))*10^0]);
end


