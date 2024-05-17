clear all; close all; clc
% % 获取当前工作目录
% currentDir = pwd;
% 
% % 将当前目录及其所有子目录添加到MATLAB路径中
% addpath(genpath(currentDir));
% 
% % 显示已经添加到路径中的文件夹
% disp(['Added ', currentDir, ' and its subdirectories to the MATLAB path.']);

task = 'speedTest';
numberOfChannelsList = [4, 8, 16, 32, 62, 128];
oversamplingFactorList = [2, 3/2, 5/4];
setupEnvironment = 'Simulation';
evaluationEnvironment = 'Simulation';
numberOfRepeats = 2;

for cIdx = 1:length(numberOfChannelsList)
    for oIdx = 1:length(oversamplingFactorList)
        numberOfChannels = numberOfChannelsList(cIdx);
        oversamplingFactor = oversamplingFactorList(oIdx);
        decimationFactor = round(numberOfChannels/oversamplingFactor);
        prototypeFilterLength = round(4*numberOfChannels/(oversamplingFactor-1));
        % Mex single thread - all subbands
        runAdaptiveProcessing(task, 'mexSubbandAllChannels', numberOfChannels, decimationFactor, prototypeFilterLength, false, setupEnvironment, evaluationEnvironment, numberOfRepeats, 2, false);
        % Mex single thread - only relevant subbands
        runAdaptiveProcessing(task, 'mexSubband', numberOfChannels, decimationFactor, prototypeFilterLength, false, setupEnvironment, evaluationEnvironment, numberOfRepeats, 2, false);
        % Mex multi-threaded - only relevant subbands
        runAdaptiveProcessing(task, 'mexSubbandParallel', numberOfChannels, decimationFactor, prototypeFilterLength, false, setupEnvironment, evaluationEnvironment, numberOfRepeats, 2, false);
    end
end

% Mex full-rate
runAdaptiveProcessing(task, 'mexFullrate', numberOfChannels, decimationFactor, prototypeFilterLength, false, setupEnvironment, evaluationEnvironment, numberOfRepeats, 2, false);

