%% This function plots a customizable PSTH using the input signal
% Created by Naveen on 06/02/15 at CUMC

function PSTH = PSTH_n(Signal,Align_time,Start_time,End_time,Sigma,Colour,LineWidth,SURPRESS)

% let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
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
    error('Too many inputs to the function PSTH_n');
end


time = Start_time:End_time;
Matrix = zeros(length(Signal),End_time-Start_time+1);


for i=1:length(Signal)
    clear Aligned_signal;
    Aligned_spikes = round( Signal{i,1}-Align_time(i,1))-(Start_time)+1;
    temp = Aligned_spikes(find(0<Aligned_spikes & Aligned_spikes<End_time-Start_time+1));
    Matrix(i,temp)=1;
    
    if isempty(Signal{i,1})
        Matrix(i,:) = NaN;
    end
end




for j=1:size(Matrix,2)
    Vertical_mean(j) = nanmean(Matrix(:,j));
end


%% Gaussian Kernel :
% Sigma=4;
PI=22/7;
Kernel=[-5*Sigma:5*Sigma];
BinSize=length(Kernel);
Half_BW=(BinSize-1)/2;
Kernel=[-BinSize/2:BinSize/2];
Factor=1000/(Sigma*sqrt(2*PI));
Kernel=Factor*(exp(-(0.5*((Kernel./Sigma).^2))));


Kernel=Kernel; %make Kernel to a column vector
PSTH=convn(Vertical_mean,Kernel,'same');% convolving raw columns of histogram








% PLOTTING THE PSTH --------------------------------------------

if SURPRESS==0
    
    % F = figure();
    hold on;
    % axes('box','off','tickdir','out','Linewidth',1.25,'FontSize',12)
    clear ylim;
    
    
    plot(time,PSTH,'color',Colour,'LineWidth',LineWidth);
    % plot([0 0],ylim,'--','color',[0 0 0],'LineWidth',2.5);
    plot([0 0],ylim,'-','color',[0 0 0],'LineWidth',1);
    xlim([time(1) time(length(time))]);
    xlabel('Time in ms','FontSize',7);
    ylabel('Sp/s','FontSize',7);
    set(gca,'FontSize',5,'LineWidth',0.5)
    hold off;
    box off;
    set(gca,'TickDir','out');
end













end