%% This function plots a COLOURED PSTH using the input signal, @T and @R
% Created by Naveen on 01/16/17 at CUMC

function F = PSTH_COLOUR_stats_n(CHANGE,Infos,Signal,Sigma,NORM,CANCEL)

% Infos : required to get RT info, Corr and Wrong info
% Signal: spike input
% Sigma : default = 20
% NORM  : if 1, every trial is normalized individually. Default:0
% CANCEL: if 1, then the empty trials will be cancelled, trial numbers will be changed, default: 0



if nargin<3
    error('Incomplete input to the function PSTH_COLOUR_n');
elseif nargin==3
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    Sigma       = 20;
    NORM        = 0;
    CANCEL      = 0;
elseif nargin==4
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    NORM        = 0;
    CANCEL      = 0;
elseif nargin==5
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    varargin{5} = NORM;
    CANCEL      = 0;
elseif nargin==6
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    varargin{5} = NORM;
    varargin{6} = CANCEL;
else
    error('Too many inputs to the function PSTH_COLOUR_n');
end












%% LC

n_bin = 0;  % number of bins
w_bin = round(0.075*(size(Infos,1))); % bin width
s_bin = round(0.05*(size(Infos,1)));  % shift in bin


CW = Infos(:,10);
RT = Infos(:,14);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if CANCEL==1
    IND = find(~cellfun(@isempty,Signal));
    CW = CW(IND,:);
    RT = RT(IND,:); 
    
    IND = find(cellfun(@isempty,Signal));
    Count = length(find(IND<CHANGE));
    CHANGE=CHANGE-Count;   
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TOT=length(CW);



if s_bin<CHANGE
    
    % Part 1: before CHANGE
    
    % m_bin = round((CHANGE-1)/(s_bin))-1; % max number of bins
    clear per_corr1 x_trial1 RT1
    
    for i=1:s_bin:CHANGE-1
        if(i <= CHANGE-1+1-w_bin )
            n_bin = n_bin+1;
            count = 0;
            for j=i:i+w_bin-1
                if CW(j,1)==1
                    count = count+1;
                end
            end
            per_corr1(n_bin) = (count/w_bin)*100;
            x_trial1(n_bin) = i+w_bin-1;
            RT1(n_bin) = nanmean(RT(i:i+w_bin-1,1));
        end
    end
    
    
    % Part 2: after CHANGE
    n_bin = 0;
    % m_bin = round((CW-CHANGE)/(s_bin)); % max number of bins
    clear per_corr2 x_trial2 RT2
    
    for i=CHANGE:s_bin:TOT
        if(i <= TOT+1-w_bin )                  %((m_bin-2)*s_bin+CHANGE))
            %         i
            n_bin = n_bin+1;
            count = 0;
            for j=i:i+w_bin-1
                if CW(j,1)==1
                    count = count+1;
                end
            end
            per_corr2(n_bin) = (count/w_bin)*100;
            x_trial2(n_bin) = i;
            RT2(n_bin) = nanmean(RT(i:i+w_bin-1,1));
            
        end
        
    end
    
    
    
    per_corr = NaN(length(per_corr1)+length(per_corr2),1);
    per_corr(1:length(per_corr1)) = per_corr1;
    per_corr(length(per_corr1)+1:length(per_corr1)+length(per_corr2)) = per_corr2;
    
    x_trial = NaN(length(x_trial1)+length(x_trial2),1);
    x_trial(1:length(x_trial1)) = x_trial1;
    x_trial(length(x_trial1)+1:length(x_trial1)+length(x_trial2)) = x_trial2;
    
    RT_trial = NaN(length(RT1)+length(RT2),1);
    RT_trial(1:length(RT1)) = RT1;
    RT_trial(length(RT1)+1:length(RT1)+length(RT2)) = RT2;
    
    
    
    per_corr_new = per_corr;
    x_trial_new = x_trial;
    RT_trial_new = RT_trial;
    
end

%% PSTH





for I=1:2
    if I==1 Align_code = 4; end
    if I==2 Align_code = 11; end
    
    if Align_code == 11
        Start = -950; End = 750;
        time_M = Start:End;
    end
    
    if Align_code == 4
        Start = -450; End = 1250;
        time_T = Start:End;
    end
    
    clear P
    for i=1:size(Infos,1)
        P(i,:) = PSTH_ONE_n(Signal{i,1},Infos(i,Align_code),Start,End,Sigma);
    end
    
    if I==1 P_T = P; end
    if I==2 P_M = P; end
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if CANCEL==1
    IND = find(~cellfun(@isempty,Signal));
    P_T = P_T(IND,:);
    P_M = P_M(IND,:); 
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NORM==1
    for iii=1:size(P_T,1)
        P_T(iii,:) = mat2gray(P_T(iii,:));
    end
    for iii=1:size(P_M,1)
        P_M(iii,:) = mat2gray(P_M(iii,:));
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% for i=1:size(P_T,2)
%     PSTH_SMOOTH_T(:,i) = smooth(P_T(:,i));
%     PSTH_SMOOTH_M(:,i) = smooth(P_M(:,i));
% end


PSTH_SMOOTH_T = P_T;
PSTH_SMOOTH_M = P_M;










PSTH_SMOOTH_T = PSTH_SMOOTH_T(:,1+50:size(PSTH_SMOOTH_T,2)-50);
PSTH_SMOOTH_M = PSTH_SMOOTH_M(:,1+50:size(PSTH_SMOOTH_M,2)-50);

%% LC and Simple Spike metrics 

WID = 12;
LEN = 3;
FS=10;


% % start_stat = round(0.3*(find(x_value>CHANGE,1)-1));
% % end_stat   = (find(x_value>CHANGE,1)-1) +round(0.8*(length(x_value) - (find(x_value>CHANGE,1)-1) ) );
% % 

% clear F;
F = figure('PaperOrientation','Portrait','Units','Centimeters','paperunits','centimeters','Papertype','usletter',...
    'paperposition',[0.63452 0.64732 20.305 26.624],'Position',[5.7 1.3 15.2 17.5]); %,'Color','w');



if s_bin<CHANGE
    x_value = x_trial_new;
    
    clear XVAL;
    XVAL(1:find(x_value>=CHANGE,1)-1,1) = x_value(1:find(x_value>=CHANGE,1)-1);
    XVAL(find(x_value>=CHANGE,1),1) = CHANGE;
    XVAL(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = x_value(find(x_value>=CHANGE,1):length(x_value));
    
    clear PERCORR;
    PERCORR(1:find(x_value>=CHANGE,1)-1,1) = per_corr_new(1:find(x_value>=CHANGE,1)-1);
    PERCORR(find(x_value>=CHANGE,1),1) = NaN;
    PERCORR(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = per_corr_new(find(x_value>=CHANGE,1):length(x_value));
    
    clear RT;
    RT(1:find(x_value>=CHANGE,1)-1,1) = RT_trial_new(1:find(x_value>=CHANGE,1)-1);
    RT(find(x_value>=CHANGE,1),1) = NaN;
    RT(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = RT_trial_new(find(x_value>=CHANGE,1):length(x_value));
    
    
    % Learning Curve -----------------------------
    
    % ax3 = subplot(5,6,[7 13 19]);
    ax3 = subplot(WID,LEN,[1 2 4 5]);
    hold on;
    clear ylim yLim
    plot(XVAL,RT,'-','color',[1	0.7255	0.0588],'LineWidth',2);
    plot(XVAL,RT,'o','MarkerSize',4,'MarkerFaceColor',[0.5 0.5 0.5],'color','k');
    % xlabel('Trial number','fontweight','bold');
    % ylabel('% Correct','fontweight','bold');
    yLim = ylim;
    if yLim(1)>20
        ylim([20 yLim(2)]);
    end
    yLim = ylim;
    ylim([300 900])
%     xlim([Y(1) Y(length(Y))]);
    plot([CHANGE CHANGE], ylim,'--','lineWidth',1,'color','k');
    title('Learning curve');
%     camroll(90)
    ylabel('% Correct');
    box off;
    ax3.FontSize=FS;
    xlim([1 size(Infos,1)]);
end





% ax1 = subplot(5,14,[17:17+5 31:31+5 45:45+5]);
ax1 = subplot(WID,LEN,[19 20 22 23 25 26 28 29]);

Start = -400;
End   = 1200;

X = Start:End;
Y = 1:size(P_T,1);
H = surf(X, Y, PSTH_SMOOTH_T,'EdgeColor','None');
z = get(H,'ZData');
set(H,'ZData',z-max(max(PSTH_SMOOTH_T)))
colormap(jet)
view(2);
set(gca,'Xdir','reverse')
camroll(-90)
% xlim([Start End]);
% ylim([1 size(Infos,1)]);
hold on;
plot([0 0],ylim,'-k','Linewidth',2);
plot(xlim, [CHANGE CHANGE],'--w','Linewidth',1);
hold on;
xlabel('Time from target(ms)');
ax1.YTick=[];
ax1.FontSize=FS;
% ylabel([]);
xlim([Start End]);
ylim([1 size(Infos,1)]);


% ax2 = subplot(5,14,[23:23+5 37:37+5 51:51+5]);
ax2 = subplot(WID,LEN,[7 8 10 11 13 14 16 17]);
Start = -900;
End   = 700;

X = Start:End;
Y = 1:size(P_T,1);
H = surf(X, Y, PSTH_SMOOTH_M,'EdgeColor','None');
z = get(H,'ZData');
set(H,'ZData',z-max(max(PSTH_SMOOTH_M)))
colormap(jet)
view(2);
set(gca,'Xdir','reverse')
camroll(-90)
hold on;
plot([0 0],ylim,'-k','Linewidth',2);
plot(xlim, [CHANGE CHANGE],'--w','Linewidth',1);
hold on;
xlabel('Time from reward(ms)');
ax2.YTick=[];
xlim([Start End]);
ylim([1 size(Infos,1)]);
ax2.FontSize=FS;
% title(strcat(FileName1(6:17),'-SS'));



%%%%% calculating th vlues


for i = 1:size(P_T,1)
    
    t1 = -200; t2 = 0;
    Base_val(i,1) = nanmean(P_T(i,find(time_T==t1):find(time_T==t2))); % avg
    Base_val(i,2) = nanstd(P_T(i,find(time_T==t1):find(time_T==t2)))/sqrt(find(time_T==t2)-find(time_T==t1)); % std
    
    t1 = 100; t2 = 300;
    Targ_val(i,1) = nanmean(P_T(i,find(time_T==t1):find(time_T==t2))); % avg
    Targ_val(i,2) = nanstd(P_T(i,find(time_T==t1):find(time_T==t2)))/sqrt(find(time_T==t2)-find(time_T==t1)); % std
    
    t1 = -200; t2 = 100;
    Movt_val(i,1) = nanmean(P_M(i,find(time_M==t1):find(time_M==t2))); % avg
    Movt_val(i,2) = nanstd(P_M(i,find(time_M==t1):find(time_M==t2)))/sqrt(find(time_M==t2)-find(time_M==t1)); % std
    
    t1 = 200; t2 = 400;
    Pmov_val(i,1) = nanmean(P_M(i,find(time_M==t1):find(time_M==t2))); % avg
    Pmov_val(i,2) = nanstd(P_M(i,find(time_M==t1):find(time_M==t2)))/sqrt(find(time_M==t2)-find(time_M==t1)); % std
    
end





if s_bin<CHANGE
    
    % Part 1: before CHANGE
    clear  x_trial1 Base_val1 Targ_val1 Movt_val1 Pmov_val1
    n_bin = 0;
    for i=1:s_bin:CHANGE-1
        if(i <= CHANGE-1+1-w_bin )
            n_bin = n_bin+1;
            x_trial1(n_bin) = i+w_bin-1;
            Base_val1(n_bin) = nanmean(Base_val(i:i+w_bin-1,1));
            Targ_val1(n_bin) = nanmean(Targ_val(i:i+w_bin-1,1));
            Movt_val1(n_bin) = nanmean(Movt_val(i:i+w_bin-1,1));
            Pmov_val1(n_bin) = nanmean(Pmov_val(i:i+w_bin-1,1));
        end
    end
    
    
    % Part 2: after CHANGE
    n_bin = 0;
    clear per_corr2 Base_val2 Targ_val2 Movt_val2 Pmov_val2
    
    for i=CHANGE:s_bin:TOT
        if(i <= TOT+1-w_bin )                
            n_bin = n_bin+1;
            x_trial2(n_bin) = i;
            Base_val2(n_bin) = nanmean(Base_val(i:i+w_bin-1,1));
            Targ_val2(n_bin) = nanmean(Targ_val(i:i+w_bin-1,1));
            Movt_val2(n_bin) = nanmean(Movt_val(i:i+w_bin-1,1));
            Pmov_val2(n_bin) = nanmean(Pmov_val(i:i+w_bin-1,1));
        end
    end
    
    
    x_trial = NaN(length(x_trial1)+length(x_trial2),1);
    x_trial(1:length(x_trial1)) = x_trial1;
    x_trial(length(x_trial1)+1:length(x_trial1)+length(x_trial2)) = x_trial2;
    
    Base_trial = NaN(length(Base_val1)+length(Base_val2),1);
    Base_trial(1:length(Base_val1)) = Base_val1;
    Base_trial(length(Base_val1)+1:length(Base_val1)+length(Base_val2)) = Base_val2;
    
    Targ_trial = NaN(length(Targ_val1)+length(Targ_val2),1);
    Targ_trial(1:length(Targ_val1)) = Targ_val1;
    Targ_trial(length(Targ_val1)+1:length(Targ_val1)+length(Targ_val2)) = Targ_val2;
    
    Movt_trial = NaN(length(Movt_val1)+length(Movt_val2),1);
    Movt_trial(1:length(Movt_val1)) = Movt_val1;
    Movt_trial(length(Movt_val1)+1:length(Movt_val1)+length(Movt_val2)) = Movt_val2;
    
    Pmov_trial = NaN(length(Pmov_val1)+length(Pmov_val2),1);
    Pmov_trial(1:length(Pmov_val1)) = Pmov_val1;
    Pmov_trial(length(Pmov_val1)+1:length(Pmov_val1)+length(Pmov_val2)) = Pmov_val2;
       
end








if s_bin<CHANGE
   
    clear XVAL;
    XVAL(1:find(x_value>=CHANGE,1)-1,1) = x_value(1:find(x_value>=CHANGE,1)-1);
    XVAL(find(x_value>=CHANGE,1),1) = CHANGE;
    XVAL(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = x_value(find(x_value>=CHANGE,1):length(x_value));
    
    clear BASE;
    BASE(1:find(x_value>=CHANGE,1)-1,1) = Base_trial(1:find(x_value>=CHANGE,1)-1);
    BASE(find(x_value>=CHANGE,1),1) = NaN;
    BASE(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = Base_trial(find(x_value>=CHANGE,1):length(x_value));
    
    clear TARG;
    TARG(1:find(x_value>=CHANGE,1)-1,1) = Targ_trial(1:find(x_value>=CHANGE,1)-1);
    TARG(find(x_value>=CHANGE,1),1) = NaN;
    TARG(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = Targ_trial(find(x_value>=CHANGE,1):length(x_value));
    
    clear MOVT;
    MOVT(1:find(x_value>=CHANGE,1)-1,1) = Movt_trial(1:find(x_value>=CHANGE,1)-1);
    MOVT(find(x_value>=CHANGE,1),1) = NaN;
    MOVT(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = Movt_trial(find(x_value>=CHANGE,1):length(x_value));
    
    clear PMOV;
    PMOV(1:find(x_value>=CHANGE,1)-1,1) = Pmov_trial(1:find(x_value>=CHANGE,1)-1);
    PMOV(find(x_value>=CHANGE,1),1) = NaN;
    PMOV(find(x_value>=CHANGE,1)+1:length(x_value)+1,1) = Pmov_trial(find(x_value>=CHANGE,1):length(x_value));
    
    
   MAX = nanmax(nanmax([BASE TARG MOVT PMOV]));
   MIN = nanmin(nanmin([BASE TARG MOVT PMOV]));
    
    % Learning Curve -----------------------------
    
    ax4 = subplot(WID,LEN,[31 32 34 35]);
    hold on;
    clear ylim yLim
    plot(XVAL,BASE,'-','color',[0.5 0.5 0.5],'LineWidth',2);
    plot(XVAL,BASE,'o','MarkerSize',4,'MarkerFaceColor',[0.5 0.5 0.5],'color','k');
    
    plot(XVAL,TARG,'-','color',[0.1098    0.5255    0.9333],'LineWidth',2);
    plot(XVAL,TARG,'o','MarkerSize',4,'MarkerFaceColor',[0.1098    0.5255    0.9333],'color','k');
    
    plot(XVAL,MOVT,'-','color',[0.6039    0.8039    0.1961],'LineWidth',2);
    plot(XVAL,MOVT,'o','MarkerSize',4,'MarkerFaceColor',[0.6039    0.8039    0.1961],'color','k');
    
    plot(XVAL,PMOV,'-','color',[0.9333    0.4627         0],'LineWidth',2);
    plot(XVAL,PMOV,'o','MarkerSize',4,'MarkerFaceColor',[0.9333    0.4627         0],'color','k');

    xlim([1 size(Infos,1)]);
    plot([CHANGE CHANGE], ylim,'--','lineWidth',1,'color','k');
    ylabel('Firing rate (Sp/s)');
    box off;
    ax4.FontSize=FS;
    ylim([MIN MAX])
    
    xlabel('Trail number');
    
    
end




subplot(WID,LEN,[33 36]);
axis off;
text(0,0,'BASE','color',[0.5 0.5 0.5])
text(0,0.2,'TARG','color',[0.1098    0.5255    0.9333])
text(0,0.4,'MOVT','color',[0.6039    0.8039    0.1961])
text(0,0.6,'PMOV','color',[0.9333    0.4627         0])







% % 
% % cd(Results_dir)
% % filename = strcat(FileName1(6:17),'_PSTH_SS_TRIAL');
% % 
% % print(ff, '-depsc', filename, '-r600')
% % print(ff, '-dpdf', filename, '-r600')
% % print(ff, '-djpeg', filename, '-r600')




end
    
