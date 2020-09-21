%% This function computes a PSTH using the input signal
%% Calculates PSTH in bins
% Created by Naveen on 06/27/17 at CUMC

function [PSTH_mean,PSTH_std] = PSTH_BIN_n(Signal,Align_time,Start_time,End_time,w_bin,s_bin,Colour,LineWidth)

% let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% w_bin*       : 1 x 1   : bin width
% s_bin*       : 1 x 1   : bin shift
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% LineWidth    : 1 x 1   : Line Width of the PSTH [Default: 2]


if nargin<6
    error('Incomplete input to the function Raster_n');
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
    error('Too many inputs to the function PSTH_BIN_n');
end


time = Start_time:End_time;
Matrix = zeros(length(Signal),End_time-Start_time+1);
PSTH_mean = NaN(1,length(time));
PSTH_std = NaN(1,length(time));

for i=1:length(Signal)
    clear Aligned_signal temp;
    Aligned_spikes = round( Signal{i,1}-Align_time(i,1))+abs(Start_time)+1;
    temp = Aligned_spikes(find(0<Aligned_spikes & Aligned_spikes<End_time-Start_time+1));
    Matrix(i,temp)=1;
    
    if isempty(Signal{i,1})
        Matrix(i,:) = NaN;
    end
end



for j=1:size(Matrix,2)
    Vertical_mean(j) = nanmean(Matrix(:,j));
end


%%%%%%%



% w_bin = 50; % bin width
% s_bin = 10;  % shift in bin




%%%%
% clear PSTH_mean PSTH_std


for i=1:s_bin:size(Matrix,2)
    if i <= size(Matrix,2)-w_bin  
        SIG = (Vertical_mean(:,i:i+w_bin))*1000;
        PSTH_mean((i+i+w_bin)/2) = nanmean(SIG); 
        PSTH_std((i+i+w_bin)/2) = nanstd(SIG); 
        clear SIG
    end
end

PSTH_mean(find(PSTH_mean==0))=NaN;
PSTH_std(find(PSTH_std==0))=NaN;

PSTH_mean = interpolate_NaN_n(PSTH_mean);
PSTH_std = interpolate_NaN_n(PSTH_std);



%%%













end