%% This function returns a matrix of PSTH for all trials using the input signal
% Created by Naveen on 10/04/17 at CUMC

function [PSTH] = PSTH_RETURN_n(Signal,Align_time,Start_time,End_time,Sigma)

% let number of trials be N

% Signal*      : N x 1   : a structure (array of trials; each cell being an array of spike timings for that trial)
% Align_time*  : N x 1   : a array of timings, each for a trial
% Start_time*  : 1 x 1   : start time of the PSTH
% End_time*    : 1 x 1   : end time of the PSTH
% Sigma*       : 1 x 1   : Standard deviation of the gaussian

if nargin<5
    error('Incomplete input to the function PSTH_RETURN_n');
elseif nargin==5
    varargin{1} = Signal;
    varargin{2} = Align_time;
    varargin{3} = Start_time;
    varargin{4} = End_time;
    varargin{5} = Sigma;
else
    error('Too many inputs to the function PSTH_RETURN_n');
end


for i=1:size(Signal,1)
    PSTH(i,:)=PSTH_ONE_n(Signal{i,1},Align_time(i,1),Start_time,End_time,Sigma);
end


end