%% This function plots a customizable PSTH using the input signal
% Created by Naveen on 06/02/15 at CUMC

function PSTH = PSTH_ONE_n(Signal,Align_time,Start_time,End_time,Sigma,Colour,LineWidth,SURPRESS)

%

% Signal*      : n x 1   : a structure (array of spike timings for a single trial
% Align_time*  : 1 x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% Sigma*       : 1 x 1   : Standard deviation of the gaussian
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% LineWidth    : 1 x 1   : Line Width of the PSTH [Default: 2]
% SURPRESS     : 1 x 1   : 1 to surpress the figure, 0 to show [Default: 1]



if nargin<5
    error('Incomplete input to the function Raster_n');
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    Colour      = [0 0 0];
    LineWidth   = 2;
    SURPRESS    = 1;
elseif nargin==6
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    LineWidth   = 2;
    SURPRESS    = 1;
elseif nargin==7
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    varargin{7} = LineWidth;
    SURPRESS    = 1;
elseif nargin==8
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
    varargin{6} = Colour;
    varargin{7} = LineWidth;
    varargin{8} = SURPRESS;
else
    error('Too many inputs to the function PSTH_ONE_n');
end


time = Start_time:End_time;
Matrix = zeros(1,End_time-Start_time+1);



clear Aligned_signal;
Aligned_spikes = round(Signal-Align_time)-(Start_time)+1;
temp = Aligned_spikes(find(0<Aligned_spikes & Aligned_spikes<End_time-Start_time+1));

%     Aligned_spikes = round(Signal-Align_time);
%     temp = Aligned_spikes(find(Start_time<Aligned_spikes & Aligned_spikes<End_time));


Matrix(1,temp)=1;



%% Gaussian Kernel :
% Sigma=25;
PI=22/7;
Kernel=[-5*Sigma:5*Sigma];
BinSize=length(Kernel);
Half_BW=(BinSize-1)/2;
Kernel=[-BinSize/2:BinSize/2];
Factor=1000/(Sigma*sqrt(2*PI));
Kernel=Factor*(exp(-(0.5*((Kernel./Sigma).^2))));


Kernel=Kernel; %make Kernel to a column vector
PSTH=convn(Matrix,Kernel,'same');% convolving raw columns of histogram








% PLOTTING THE PSTH --------------------------------------------

if SURPRESS==0
    
    % F = figure();
    hold on;
    % axes('box','off','tickdir','out','Linewidth',1.25,'FontSize',12)
    clear ylim;
    
    
    plot(time,PSTH,'color',Colour,'LineWidth',LineWidth);
    plot([0 0],ylim,'--','color',[0 0 0],'LineWidth',0.5);
    xlim([time(1) time(length(time))]);
    xlabel('Time in ms','FontSize',10);
    ylabel('Spike rate (Hz)','FontSize',8);
    set(gca,'FontSize',8,'LineWidth',0.7)
    set(gcf, 'PaperUnits','inches','PaperSize',[8 8],'PaperPosition',[1 1 6.65 5])
    hold off;
    box off;
    
end











end