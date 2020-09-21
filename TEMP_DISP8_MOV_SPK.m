
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
ylabel('SPK')


sp = [3 2 1 4 8 0 5 6 7];
diff=NaN(size(TEMPO_Target_n(:,1)));
for i=1:length(sp)
    
    if (i~=5)
        
        subplot(3,3,1)
        
        x = N/2-1500:N/2+500;
%         X=[x,fliplr(x)];
%         y1 = 1* ( SPK_avg_T(sp(i)+1,:) + SPK_std_T(sp(i)+1,:) );
%         y2 = 1* ( SPK_avg_T(sp(i)+1,:) - SPK_std_T(sp(i)+1,:) );
%         y1(isnan(y1))=0;
%         y2(isnan(y2))=0;
%         Y=[y1,fliplr(y2)];
%         fi = fill(X,Y,[0 0.6 0.6],'linestyle','none');
%         set(fi,'FaceAlpha',0.3);
        hold on;
        sig = smooth(SPK_avg_S(sp(i)+1,N/2-1500:N/2+500),0.1,'sgolay',5);
        plot(x , sig,'color',SPK_COLOR,'linewidth',0.75);
         xlim([5000 6200]);
        ylim([0 50]);
        YLIM(i,:) = ylim;
%         title(strcat('Position-',num2str(sp(i))));
        box off;
        value = [5700 5800 6000 6200];
        value2 = [0 20 40 60];
set(gca, 'XTick', value);
set(gca, 'XTickLabel', {'-300','-200','0','200'},'fontsize',10);

set(gca, 'YTick', value2);
set(gca, 'YTickLabel', {'0','20','40','60'},'fontsize',10);
        
        
%         set(gca,'xtick', [-250 0 250 500 1000],'FontSize',10);
        
        if (sp(i)==4) ylabel('Sp/s');   end
        if (sp(i)==6) xlabel('Time (msec)');              end
        
    end
end


Y_LIM_t(1) = min(YLIM(:,1));
Y_LIM_t(2) = max(YLIM(:,2));

xlim([5700 6200]);
ylim([0 60]);


% print(gcf,'MG_SPK_avg_disp8_t_FIG.pdf','-dpdf','-r400')
print(gcf,'MG_SPK_avg_disp8_s_FIG_WITHOUTERROR.pdf','-dpdf','-r400')
