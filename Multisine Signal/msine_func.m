function f = msine_func(phi_vec,omega_vec,amp_vec,t,Ts,G)
    u = zeros(length(t),1);
    for i = 1:length(t)
        u(i) = sum(amp_vec.*sin(omega_vec*Ts*i+phi_vec));
    end
    
%     u=(u-min(u))./((max(u)-min(u)));
    y=lsim(G,u,t,7);%lsim(c2d(G,Ts),u,t);
    f = norm(y,inf)/norm(y,2);