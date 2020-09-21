%% This function plots a customizable PSTH using the input signal
% Created by Naveen on 06/02/15 at CUMC

function PSTH = PSTH_Temporal_n(X_POS,CV2,Align_time,Start_time,End_time,Sigma,Colour,LineWidth)

% let number of trials be N

% X_POS*       : N x 1   : a structure (array of trials; each cell being an array of timings of CV2 for that trial)
% CV2*         : N x 1   : a structure (array of trials; each cell being an array of values of CV2 for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% Sigma*       : 1 x 1   : Standard deviation of the gaussian
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% LineWidth    : 1 x 1   : Line Width of the PSTH [Default: 1]


if nargin<6
    error('Incomplete input to the function Raster_n');
elseif nargin==6
    varargin{1} = X_POS;
    varargin{2} = CV2;
    varargin{3} = Align_time;
    varargin{4} = Start_time;
    varargin{5} = End_time;
    varargin{6} = Sigma;
    Colour      = [0 0 0];
    LineWidth   = 1;
elseif nargin==7
    varargin{1} = X_POS;
    varargin{2} = CV2;
    varargin{3} = Align_time;
    varargin{4} = Start_time;
    varargin{5} = End_time;
    varargin{6} = Sigma;
    varargin{7} = Colour;
    LineWidth   = 1;
elseif nargin==8
    varargin{1} = X_POS;
    varargin{2} = CV2;
    varargin{3} = Align_time;
    varargin{4} = Start_time;
    varargin{5} = End_time;
    varargin{6} = Sigma;
    varargin{7} = Colour;
    varargin{8} = LineWidth;
else
    error('Too many inputs to the function PSTH_n');
end


time = Start_time:End_time;
Matrix = zeros(length(X_POS),End_time-Start_time+1);


for i=1:length(X_POS)
    clear Aligned_signal;
    Aligned_spikes = round( X_POS{i,1}-Align_time(i,1))+abs(Start_time)+1;
    ind = find(0<Aligned_spikes & Aligned_spikes<End_time-Start_time+1);
    temp = Aligned_spikes(ind);
    Matrix(i,temp)= CV2{i,1}(ind,1);
    
    if isempty(X_POS{i,1})
        Matrix(i,:) = NaN;
    end
end

% Matrix(find(Matrix==0))=NaN;


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


 
PSTH=PSTH/1000;




% PLOTTING THE PSTH --------------------------------------------


% F = figure();
hold on;
% axes('box','off','tickdir','out','Linewidth',1.25,'FontSize',12)
clear ylim;




plot(time,Vertical_mean,'color',Colour,'LineWidth',LineWidth);
plot(time,PSTH,'-y','LineWidth',LineWidth);


% plot([0 0],ylim,'--','color',[0 0 0],'LineWidth',2.5);
plot([0 0],ylim,'-','color',[0 0 0],'LineWidth',1);
xlim([time(1) time(length(time))]);
xlabel('Time in ms','FontSize',12);
ylabel('CV2/s','FontSize',12);
set(gca,'FontSize',12,'LineWidth',1)
set(gcf, 'PaperUnits','inches','PaperSize',[8 8],'PaperPosition',[1 1 6.65 5])
hold off;
box off;











end