%% This function plots a COLOURED PSTH using the input signal, @T and @R
% Created by Naveen on 01/13/17 at CUMC

function F = PSTH_COLOUR_n(CHANGE,Infos,Signal,Sigma,NORM,CANCEL,SpikeS,SpikeC)

% Infos : required to get RT info, Corr and Wrong info
% Signal: spike input
% Sigma : default = 20
% NORM  : if 1, every trial is normalized individually. Default:0
% CANCEL: if 1, then the empty trials will be cancelled, trial numbers will be changed, 
%       : if 2, then the empty trials will remain empty, trial numbers will not be changed
%       : default is 0
% May include Spike.S and Spike.C to make a ratser. In that case, NoSpike will be 0; default NoSpike=0;



if nargin<3
    error('Incomplete input to the function PSTH_COLOUR_n');
elseif nargin==3
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    Sigma       = 20;
    NORM        = 0;
    CANCEL      = 0;
    NoSpike     = 1;
elseif nargin==4
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    NORM        = 0;
    CANCEL      = 0;
    NoSpike     = 1;
elseif nargin==5
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    varargin{5} = NORM;
    CANCEL      = 0;
    NoSpike     = 1;
elseif nargin==6
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    varargin{5} = NORM;
    varargin{6} = CANCEL;
    NoSpike     = 1;
elseif nargin==7
    error('If you want a rater, enter both spikes');
elseif nargin==8
    varargin{1} = CHANGE;
    varargin{2} = Infos;
    varargin{3} = Signal;
    varargin{4} = Sigma;
    varargin{5} = NORM;
    varargin{6} = CANCEL;
    varargin{7} = SpikeS;
    varargin{8} = SpikeC;
    NoSpike     = 1;
else
    error('Too many inputs to the function PSTH_COLOUR_n');
end







RT = Infos(:,11)-Infos(:,4);




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
    end
    
    if Align_code == 4
        Start = -450; End = 1250;
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
if CANCEL==2
    IND = find(cellfun(@isempty,Signal));
    P_T(IND,:) = NaN;
    P_M(IND,:) = NaN;
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

WID = 7;
LEN = 14;
FS=10;


% % start_stat = round(0.3*(find(x_value>CHANGE,1)-1));
% % end_stat   = (find(x_value>CHANGE,1)-1) +round(0.8*(length(x_value) - (find(x_value>CHANGE,1)-1) ) );
% % 

% clear F;
F = figure;

% suptitle(FileName1(6:17));

% ax1 = subplot(5,14,[17:17+5 31:31+5 45:45+5]);
ax1 = subplot(WID,LEN,[LEN*1+2+1:LEN*1+2+1+5 LEN*2+2+1:LEN*2+2+1+5 LEN*3+2+1:LEN*3+2+1+5]);

Start = -400;
End   = 1200;

X = Start:End;
Y = 1:size(P_T,1);
H = surf(X, Y, PSTH_SMOOTH_T,'EdgeColor','None');
z = get(H,'ZData');
set(H,'ZData',z-max(max(PSTH_SMOOTH_T)))
colormap(jet)
view(2);
xlim([Start End]);
ylim([1 size(Infos,1)]);
hold on;
plot([0 0],ylim,'-k','Linewidth',2);
plot(xlim, [CHANGE CHANGE],'--w','Linewidth',1.5);
hold on;
xlabel([]);
ax1.YTick=[];
ax1.FontSize=FS;
ax1.XTick=[];
ylabel([]);
box off;
ylim([Y(1) Y(length(Y))])



ax3 = subplot(WID,LEN,[LEN*4+2+1:LEN*4+2+1+5 LEN*5+2+1:LEN*5+2+1+5 LEN*6+2+1:LEN*6+2+1+5]);
Raster_n(SpikeS,Infos(:,4),Start,End,[0.6 0.6 0.6],0.5);
xlabel([])
hold on;
Raster_n(SpikeC,Infos(:,4),Start,End,[0.9333    0.2275    0.5490],2);
hold on;
plot(xlim,[CHANGE CHANGE],'--k','LineWidth',1);
set(gca,'FontSize',10,'LineWidth',1);
xlabel('Time from target(ms)');
% ax3.YTick=[];
ax3.FontSize=FS;
ylabel([]);
box off;
ylim([Y(1) Y(length(Y))])
xlim([Start End]);





% ax2 = subplot(5,14,[23:23+5 37:37+5 51:51+5]);
ax2 = subplot(WID,LEN,[LEN*1+2+1+5+1:LEN*1+2+1+5+1+5 LEN*2+2+1+5+1:LEN*2+2+1+5+1+5 LEN*3+2+1+5+1:LEN*3+2+1+5+1+5]);
Start = -900;
End   = 700;

X = Start:End;
Y = 1:size(P_T,1);
H = surf(X, Y, PSTH_SMOOTH_M,'EdgeColor','None');
z = get(H,'ZData');
set(H,'ZData',z-max(max(PSTH_SMOOTH_M)))
colormap(jet)
view(2);
xlim([Start End]);
ylim([Y(1) Y(length(Y))])
hold on;
plot([0 0],ylim,'-k','Linewidth',2);
plot(xlim, [CHANGE CHANGE],'--w','Linewidth',1.5);
hold on;
xlabel('Time from reward(ms)');
ax2.YTick=[];
ax2.XTick=[];
ylabel([]);
xlabel([]);
box off;
ylim([Y(1) Y(length(Y))])
ax2.FontSize=FS;
% title(strcat(FileName1(6:17),'-SS'));
%colorbar


ax4 = subplot(WID,LEN,[LEN*4+2+1+5+1:LEN*4+2+1+5+1+5 LEN*5+2+1+5+1:LEN*5+2+1+5+1+5 LEN*6+2+1+5+1:LEN*6+2+1+5+1+5]);
Raster_n(SpikeS,Infos(:,11),Start,End,[0.6 0.6 0.6],0.5);
xlabel([])
hold on;
Raster_n(SpikeC,Infos(:,11),Start,End,[0.9333    0.2275    0.5490],2);
hold on;
plot(xlim,[CHANGE CHANGE],'--k','LineWidth',1);
set(gca,'FontSize',10,'LineWidth',1);
xlabel('Time from movement(ms)');
ax4.YTick=[];
ax4.FontSize=FS;
ylabel([]);
box off;
ylim([Y(1) Y(length(Y))])
xlim([Start End]);
set(gca,'ycolor',[1 1 1])





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
    ax3 = subplot(WID,LEN,[LEN*1+1 LEN*1+2 LEN*2+1 LEN*2+2 LEN*3+1 LEN*3+2]);
    hold on;
    clear ylim yLim
    plot(XVAL,RT,'-','color',[1	0.7255	0.0588],'LineWidth',1);
    plot(XVAL,RT,'o','MarkerSize',2,'MarkerFaceColor',[0.5 0.5 0.5],'color','k');
    % xlabel('Trial number','fontweight','bold');
    % ylabel('% Correct','fontweight','bold');
    yLim = ylim;
    if yLim(1)>20
        ylim([20 yLim(2)]);
    end
    yLim = ylim;
    xlim([Y(1) Y(length(Y))]);
    plot([CHANGE CHANGE], ylim,'--','lineWidth',2,'color','k');
    title('Learning curve');
    camroll(90)
    ylabel('% Correct');
    box off;
    ax3.FontSize=FS;
    
end

% % 
% % cd(Results_dir)
% % filename = strcat(FileName1(6:17),'_PSTH_SS_TRIAL');
% % 
% % print(ff, '-depsc', filename, '-r600')
% % print(ff, '-dpdf', filename, '-r600')
% % print(ff, '-djpeg', filename, '-r600')

% subplot(7,14,[71 85])
% colorbar


end
    
