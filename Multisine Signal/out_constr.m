function [c,ceq] = out_constr(phi_vec,omega_vec,amp_vec,t,Ts,y_min,y_max,G)
    u = zeros(length(t),1);
    for i = 1:length(t)
        u(i) = sum(amp_vec.*sin(omega_vec*Ts*i+phi_vec));
    end
    
%     u=(u-min(u))./((max(u)-min(u)));

    y=lsim(G,u,t);%lsim(c2d(G,Ts),u,t);
    y_c=lsim(G,min(u)*ones(size(u)),t);
    c = [y_min*ones(length(y),1)+y_c-y;
        y-y_max*ones(length(y),1)-y_c];
%          zeros(length(u),1)-u];
    plot(c);hold on;

    ceq=[];