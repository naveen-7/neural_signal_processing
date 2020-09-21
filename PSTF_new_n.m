%% This function plots a customizable Fano factor plot using the input signal
%% Calculates Fano factor in bins
% Created by Naveen on 06/27/17 at CUMC
% Edited by naveen on 9/6/18 at JLG

function [PSTF]= PSTF_new_n(Signal,Align_time,Start_time,End_time,SIGMA,Colour,LineWidth)

% let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% SIGMA        : 1 x 1   : sigma [Default: 20]
% Colour       : 1 x 3   : RGB value of raster   [Default: black]
% LineWidth    : 1 x 1   : Line Width of the PSTH [Default: 2]


if nargin<4
    error('Incomplete input to the function Raster_n');
elseif nargin==4
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    SIGMA       = 20;
    Colour      = [0 0 0];
    LineWidth   = 2;
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = 20;
    Colour      = [0 0 0];
    LineWidth   = 2;
elseif nargin==6
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = 20;
    varargin{6} = [0 0 0];
    LineWidth   = 2;
elseif nargin==7
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = 20;
    varargin{6} = Colour;
    varargin{7} = 2;
else
    error('Too many inputs to the function PSTF_new_n');
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
for j=1:size(Matrix,2)    
    BIN_actual = Matrix_actual(:,j);
    BIN_actual((isnan(BIN_actual)))=0;
    FANO_mean(j) = nanvar(BIN_actual)/nanmean(BIN_actual);
%     FANO_mean(n_bin) = nanvar(reshape(Matrix(:,j:j+w_bin),1,[]))/nanmean(reshape(Matrix(:,j:j+w_bin),1,[]));
%     FANO_time(n_bin) = nanmean(time(j:j+w_bin));
end

FANO_mean(isnan(FANO_mean))=0;


PI=22/7;
clear Kernel;
Kernel=[-5*SIGMA:5*SIGMA];
BinSize=length(Kernel);
Half_BW=(BinSize-1)/2;
Kernel=[-BinSize/2:BinSize/2];
Factor=1000/(SIGMA*sqrt(2*PI));
Kernel=Factor*(exp(-(0.5*((Kernel./SIGMA).^2))));


Kernel=Kernel; %make Kernel to a column vector
PSTF=convn(FANO_mean,Kernel,'same');% convolving raw columns of histogram





end