%% This function plots a customizable PSTH using the input signal
% Created by Naveen on 07/31/17 at CUMC

function [PSTH] = PSTHe_n(Signal,Align_time,Start_time,End_time,Sigma,Colour,LW,SURPRESS,Style)

% let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% Sigma*       : 1 x 1   : Standard deviation of the gaussian
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% LineWidth    : 1 x 1   : Line Width of the PSTH [Default: 2]
% SURPRESS     : 1 x 1   : 1 to surpress the figure, 0 to show [Default: 1]
% Style        : 1 x 1   : Marker style [Default: -]

if nargin<5
    error('Incomplete input to the function PSTHe_n');
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    Colour      = [0 0 0];
    LineWidth   = 1.5;
    SURPRESS    = 1; 
    Style       = '-';
elseif nargin==6
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    LineWidth   = 1.5;
    SURPRESS    = 1; 
    Style       = '-';
elseif nargin==7
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    varargin{7} = LW;
    SURPRESS    = 1; 
    Style       = '-';
elseif nargin==8
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    varargin{7} = LW;
    varargin{8} = SURPRESS;
    Style       = '-';
elseif nargin==9
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    varargin{7} = LW;
    varargin{8} = SURPRESS;
    varargin{9} = Style;
else
    error('Too many inputs to the function PSTH_n');
end






for i=1:size(Signal,1)
    TEMP=PSTH_ONE_n(Signal{i,1},Align_time(i,1),Start_time-200,End_time+200,Sigma,Colour,1,1);
    PSTH(i,:) = TEMP(201:end-200);
end



PSTH_mean = nanmean(PSTH,1);
PSTH_std = nanstd(PSTH);
PSTH_sem = nanstd(PSTH)/sqrt(size(Signal,1));


time = Start_time:End_time;



% PLOTTING THE PSTH --------------------------------------------

if SURPRESS==0
    
    hold on;
    clear ylim;
    errorline_n(time,PSTH_mean,PSTH_sem,1,Colour,0.3,0,LW,Style);
    plot([0 0],ylim,'--','color',[0 0 0],'LineWidth',0.4);
    xlim([time(1) time(length(time))]);
    xlabel('Time in ms','FontSize',10);
    ylabel('sp/s','FontSize',10);
    set(gca,'FontSize',10,'LineWidth',0.4)
    hold off;
    box off;
    
end
    
    
PSTH = [PSTH_mean; PSTH_std; PSTH_sem];

end