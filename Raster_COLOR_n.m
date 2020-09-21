%% This function plots a customizable raster using the input signal
% Created by Naveen on 06/02/15 at CUMC


function  Aligned_mat = Raster_COLOR_n(Signal,Align_time,Start_time,End_time,COLOR,MS,Other_time,Show,TickShape)


%let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the raster
% End_time*    : 1 x 1   : end time of the raster
% COLOR        : N x 3   : colour matrix [Default: black]
% MS           : 1 x 1   : Marker size of the rasters   [Default: 0.3]
% Other_time   : N x 1   : a array of timings of another event
% Show         : 1 x 1   : 1 to Show; 0 to Hide the raster plot [Default: 1]
% TickShape    : char    : shape of the tick [Default: 'o']


if nargin<4
    error('Incomplete input to the function Raster_n');
elseif nargin==4
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    COLOR       = zeros(length(Signal),3);
    MS          = 0.3;
    Other_time  = NaN(size(Signal,1),1);
    Show        = 1;
    TickShape   = 'o';
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = COLOR;
    MS          = 0.3;
    Other_time  = NaN(size(Signal,1),1);
    Show        = 1;
    TickShape   = 'o';
elseif nargin==6
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = COLOR;
    varargin{7} = MS;
    Other_time  = NaN(size(Signal,1),1);
    Show        = 1;
    TickShape   = 'o';
elseif nargin==7
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = COLOR;
    varargin{6} = MS;
    varargin{7} = Other_time- Align_time;
    Show        = 1;
    TickShape   = 'o'; 
elseif nargin==8
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = COLOR;
    varargin{6} = MS;
    varargin{7} = Other_time- Align_time;
    TickShape   = 'o';
elseif nargin==9
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = COLOR;
    varargin{6} = MS;
    varargin{7} = Other_time- Align_time;
    varargin{8} = TickShape; 
else
    error('Too many inputs to the function Raster_n');
end


Other_time = Other_time - Align_time;





% PLOTTING THE RASTER --------------------------------------------

if Show==1
    hold on;
end

Aligned_mat = cell(size(Signal));

for i=1:length(Signal)
    clear Aligned_signal;
    Aligned_signal = Signal{i,1}-Align_time(i,1);
    Aligned_mat{i,1} = Aligned_signal;
    if Show==1
        for j=1:length(Signal{i,1})
%             plot(Aligned_signal(j),i,TickShape,'color',COLOR(i,:),'MarkerFaceColor',COLOR(i,:),'Markersize',MS); 
            plot([Aligned_signal(j) Aligned_signal(j)],[i-1 i],'-','color',COLOR(i,:),'linewidth',MS)   
        end
%         plot(Other_time(i,1),i,'*','color',[0 0 0]);
    end
end


if Show==1
    hold on;
    xlim([Start_time End_time]);
    ylim([1 length(Signal)]);
    plot([0 0],ylim,'-','color',[0 0 0],'LineWidth',1);
    xlabel('Time in ms','FontSize',8);
    ylabel('Trials','FontSize',8);
    set(gca,'FontSize',8,'LineWidth',0.4)
end

end