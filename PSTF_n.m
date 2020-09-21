%% This function plots a customizable Fano factor plot using the input signal
%% Calculates Fano factor in bins
% Created by Naveen on 06/27/17 at CUMC

function [FANO_mean,FANO_time]= PSTF_n(Signal,Align_time,Start_time,End_time,w_bin,s_bin,Colour,LineWidth)

% let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% w_bin        : 1 x 1   : bin width [Default: 100]
% s_bin        : 1 x 1   : bin shift [Default: 100]
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% LineWidth    : 1 x 1   : Line Width of the PSTH [Default: 2]


if nargin<4
    error('Incomplete input to the function Raster_n');
elseif nargin==4
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    w_bin       = 100;
    s_bin       = 100;
    Colour      = [0 0 0];
    LineWidth   = 2;
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = w_bin;
    s_bin       = 100;
    Colour      = [0 0 0];
    LineWidth   = 2;
elseif nargin==6
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = w_bin;
    varargin{6} = s_bin;
    Colour      = [0 0 0];
    LineWidth   = 2;
elseif nargin==7
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = w_bin;
    varargin{6} = s_bin;
    varargin{7} = Colour;
    LineWidth   = 2;
elseif nargin==8
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = w_bin;
    varargin{6} = s_bin;
    varargin{7} = Colour;
    varargin{8} = LineWidth;
else
    error('Too many inputs to the function FANO_BIN_n');
end


time = Start_time:End_time;
Matrix = zeros(length(Signal),End_time-Start_time+1);


nonnanlength = length(find(~cellfun(@isempty,Signal)));
nonnanindex = find(~cellfun(@isempty,Signal));

for i=1:length(Signal)
    clear Aligned_signal temp;
    Aligned_spikes = round( Signal{i,1}-Align_time(i,1))+abs(Start_time)+1;
    temp = Aligned_spikes(find(0<Aligned_spikes & Aligned_spikes<End_time-Start_time+1));
    Matrix(i,temp)=1;
    
    if isempty(Signal{i,1})
        Matrix(i,:) = NaN;
    end
end

Matrix_actual = Matrix(nonnanindex,:);


n_bin = 0;
clear FANO_mean FANO_time;
for j=1:s_bin:size(Matrix,2)-w_bin
    n_bin=n_bin+1;
    
    %     if n_bin==64
    %          BIN_actual = Matrix_actual(:,j:j+w_bin);
    %     BIN_actual_count = nansum(BIN_actual,2);
    %     BIN_actual_count(BIN_actual_count==0)=NaN;
    %
    %     FANO_mean(n_bin) = nanstd(BIN_actual_count)^2/nanmean(BIN_actual_count);
    % %     FANO_mean(n_bin) = nanvar(reshape(Matrix(:,j:j+w_bin),1,[]))/nanmean(reshape(Matrix(:,j:j+w_bin),1,[]));
    %     FANO_time(n_bin) = nanmean(time(j:j+w_bin));
    %     end
    
    
    BIN_actual = Matrix_actual(:,j:j+w_bin);
    BIN_actual_count = nansum(BIN_actual,2);
%     BIN_actual_count(BIN_actual_count==0)=NaN; %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     BIN_actual_count(BIN_actual_count<=3)=NaN; %%%%%%%%%%%%%%%%%%%%%%%%%%%
          

        
clear tempyyy;
tempyyy = reshape(Matrix(:,j:j+w_bin),1,[]);


     FANO_mean(n_bin) = nanvar(tempyyy)/nanmean(tempyyy);
     FANO_time(n_bin) = nanmean(time(j:j+w_bin));
    
%      FANO_mean(n_bin) = nanstd(BIN_actual_count)^2/nanmean(BIN_actual_count);     
%      allvar(n_bin) = nanstd(BIN_actual_count)^2;
%      allavg(n_bin) = nanmean(BIN_actual_count);
    
     allvar(n_bin) = nanvar(reshape(Matrix(:,j:j+w_bin),1,[]));
     allavg(n_bin) = nanmean(reshape(Matrix(:,j:j+w_bin),1,[]));

     tempysum(n_bin) = nansum(tempyyy);
     tempyPSTH(n_bin) = nansum(tempyyy)*1000/(size(Matrix_actual,1)*w_bin);
end


figure()
subplot(3,3,1)
plot(allavg,allvar);
xlabel('mean'); ylabel('var');

subplot(3,3,2)
hold on;
plot(FANO_time,allvar); plot(FANO_time,allavg);
xlim([FANO_time(1) FANO_time(end)])

subplot(3,3,3)
[ax,h1,h2] = plotyy(FANO_time,allvar,FANO_time,allavg);
xlim(ax(1), [FANO_time(1) FANO_time(end)]);
xlim(ax(2), [FANO_time(1) FANO_time(end)]);

subplot(3,3,5)
plot(FANO_time,FANO_mean);
xlim([FANO_time(1) FANO_time(end)])

end