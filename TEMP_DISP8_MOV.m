
cd(Results_dir_adv);

LFP_COLOR = [0 0.6 0.6];
SPK_COLOR = [0.1216    0.7412    0.8980];


f2 = figure();
axes('box','off','tickdir','out','Linewidth',1.25,'FontSize',12)
xlabel('time in ms')
ylabel('LFP')


sp = [3 2 1 4 8 0 5 6 7];
diff=NaN(size(TEMPO_Target_n(:,1)));

for i=1:length(sp)
    
    if (i~=5)
        
        subplot(3,3,1)
%         hold on;
%         x = -N/2:N/2;
%         X=[x,fliplr(x)];
%         y1 = 1* ( LFP_avg_S(sp(i)+1,:) + LFP_std_S(sp(i)+1,:) );
%         y2 = 1* ( LFP_avg_S(sp(i)+1,:) - LFP_std_S(sp(i)+1,:) );
%         y1(isnan(y1))=0;
%         y2(isnan(y2))=0;
%         Y=[y1,fliplr(y2)];
%         fi = fill(X,Y,[0.3098    0.5804    0.8039],'linestyle','none');
%         set(fi,'FaceAlpha',0.3);
        hold on;
        plot(-N/2:N/2,LFP_avg_S(sp(i)+1,:),'color',LFP_COLOR,'linewidth',0.75);
        xlim([-300 200]);
        ylim([-600 300]);
%         title(strcat('Position-',num2str(sp(i))));
        box off;
        
        if (sp(i)==4) ylabel('Amplitude  (\mu volts)');   end
        if (sp(i)==6) xlabel('Time from saccade(msec)');              end
        
    end
end



% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


set(gcf, 'PaperUnits','inches','PaperSize',[8 8],'PaperPosition',[1 1 6.65 5])


print(gcf,'MG_LFP_avg_disp8_s_FIG.pdf','-dpdf','-r400')
% print(gcf,'MG_LFP_avg_disp8_s_FIG_WITHOUTERROR.pdf','-dpdf','-r400')
