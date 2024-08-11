function CustomStep2(arxmodel,order,t,FigName)
    [ystep,tstep] = step(arxmodel,t);
    G = dcgain(arxmodel);
    PlotinputChannels = arxmodel.InputName;
    
    fig = figure(Name=FigName);
    for i = 1:length(G)
        subplot(1,length(G),i)
        if G(i) < 0
            stairs(tstep,ystep(:,:,i),'r','linewidth',1.5); hold on
            title("      \rm"+PlotinputChannels(i)+", DC: \bf\color{red}"+sprintf("%.3g",G(i)),"FontSize",14);
        else
            stairs(tstep,ystep(:,:,i),'linewidth',1.5); hold on
            title("\rm"+PlotinputChannels(i)+", DC: "+sprintf('%s%g,%g,%g','\bf\color[rgb]{',[0.4660, 0.6740, 0.1880])+"}"+sprintf("%.3g",G(i)),"FontSize",14);
        end
        xlabel('\fontsize{12} Time (days)')
        yline(G(i),':k','linewidth',1.5);
        sgtitle({"\bf Step Responses: "+"Order ["+num2str(order)+"]"},'FontSize',14)
    end
    
    han = axes(fig,'visible','off');
    han.YLabel.Visible='on';
    % han.XLabel.Visible
