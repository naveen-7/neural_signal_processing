
cd(Results_dir_adv);

% diff = TEMPO_Saccade_n(:,1)-TEMPO_Target_n(:,1);
%
% min_Sacc_n(i) = min(diff);
% max_Sacc_n(i) = max(diff);
LFP_COLOR = [0 0.6 0.6];
SPK_COLOR = [0.1216    0.7412    0.8980];

f1 = figure();
axes('box','off','tickdir','out','Linewidth',1.25,'FontSize',12)
xlabel('time in ms')
ylabel('LFP')


sp = [3 2 1 4 8 0 5 6 7];
diff=NaN(size(TEMPO_Target_n(:,1)));
for i=1:length(sp)
    
    if (i~=5)
        
        subplot(3,3,i)
        
        x = -N/2:N/2;
        X=[x,fliplr(x)];
        y1 = 1* ( LFP_avg_T(sp(i)+1,:) + LFP_std_T(sp(i)+1,:) );
        y2 = 1* ( LFP_avg_T(sp(i)+1,:) - LFP_std_T(sp(i)+1,:) );
        y1(isnan(y1))=0;
        y2(isnan(y2))=0;
        Y=[y1,fliplr(y2)];
        fi = fill(X,Y,[0 0.6 0.6],'linestyle','none');
        set(fi,'FaceAlpha',0.3);
        hold on;
        plot(x , LFP_avg_T(sp(i)+1,:),'color',[0 0.6 0.6],'linewidth',0.25);
        xlim([-100 600]);
        ylim([-450 300]);
        YLIM(i,:) = ylim;
%         title(strcat('Position-',num2str(sp(i))));
        box off;
        set(gca,'xtick', [-100 0 400 600],'FontSize',10);
        
        if (sp(i)==4) ylabel('Amplitude  (\mu volts)');   end
        if (sp(i)==6) xlabel('Time (msec)');              end
        
    end
end


Y_LIM_t(1) = min(YLIM(:,1));
Y_LIM_t(2) = max(YLIM(:,2));

print(gcf,'MG_LFP_avg_disp8_t_FIG.pdf','-dpdf','-r400')
% print(gcf,'MG_LFP_avg_disp8_t_FIG_WITHOUTERROR.pdf','-dpdf','-r400')
