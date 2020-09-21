%% This function plots a customizable raster using the input signal
% Created by Naveen on 07/10/17 at CUMC


function  Aligned_mat = RasterBAR_n(Signal,Align_time,Start_time,End_time,Colour,MS,Other_time,Show)


%let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the raster
% End_time*    : 1 x 1   : end time of the raster
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% MS           : 1 x 1   : Marker size of the rasters   [Default: 0.7]
% Other_time   : N x 1   : a array of timings of another event
% Show         : 1 X 1   : 1 to Show; 0 to Hide the raster plot [Default: 1]
% TickShape    : char    : shape of the tick [Default: 'o']

if nargin<4
    error('Incomplete input to the function Raster_n');
elseif nargin==4
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    Colour      = [0 0 0];
    MS          = 1;
    Other_time  = NaN(size(Signal,1),1);
    Show        = 1;
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Colour;
    MS          = 1;
    Other_time  = NaN(size(Signal,1),1);
    Show        = 1;
elseif nargin==6
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Colour;
    varargin{6} = MS;
    Other_time  = NaN(size(Signal,1),1);
    Show        = 1;
elseif nargin==7
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Colour;
    varargin{6} = MS;
    varargin{7} = NaN(size(Signal,1),1);
    Show        = 1;
elseif nargin==8
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Colour;
    varargin{6} = MS;
    varargin{7} = NaN(size(Signal,1),1);
    varargin{8} = 1;   
else
    error('Too many inputs to the function RasterBAR_n');
end


% Other_time = Other_time - Align_time;





% PLOTTING THE RASTER --------------------------------------------

if Show==1
    % F = figure();
    hold on;
    clear ylim;
end

Aligned_mat = cell(size(Signal));

for i=1:length(Signal)
    clear Aligned_signal;
    Aligned_signal = Signal{i,1}-Align_time(i,1);
    Aligned_mat{i,1} = Aligned_signal;
    if Show==1
        for j=1:length(Signal{i,1})
%             plot(Aligned_signal(j),i,TickShape,'color',Colour,'MarkerFaceColor',Colour,'Markersize',MS); 
            plot([Aligned_signal(j) Aligned_signal(j)],[i-1 i],'-','color',Colour,'linewidth',MS)     
        end
        plot(Other_time(i,1),i,'*','color',[0 0 0]);
    end
end


if Show==1
    xlim([Start_time End_time]);
    if length(Signal)>1
    ylim([1 length(Signal)]);
    end
%     plot([0 0],ylim,'--','color',[0 0 0],'LineWidth',2.5);
    plot([0 0],ylim,'-','color',[0 0 0],'LineWidth',1);
    xlabel('Time in ms','FontSize',10);
    ylabel('Trials','FontSize',10);
    set(gca,'FontSize',10,'LineWidth',1)
%     set(gcf, 'PaperUnits','inches','PaperSize',[8 8],'PaperPosition',[1 1 6.65 5])
    hold off;
    box off;
end

end