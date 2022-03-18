clear all; close all; clc;

%SaliencyMap Path
SalMapPath = '../SalMap/';
%Models = {'LHM','DESM','CDB','ACSD','GP','LBE','CDCP','SE','MDSF','DF','CTMF','PDNet','PCF'};%'TPF'
%Models = {'PCF','PDNet','CTMF','DF','MDSF','SE','CDCP','LBE','GP','ACSD','CDB','DESM','LHM'};
% Datasets = {'DES'};
% Models = {'DF','MDSF','AFNet','PCF','MMCI','TANet','CTMF','CPFP','D3Net','DMRA','Ours'};%DES

% Datasets = {'NLPR'};
% Models = {'DF','MDSF','CTMF','AFNet','PCF','MMCI','TANet','CPFP','DMRA','D3Net','Ours'};%'NLPR'

Datasets = {'LFSD'};
Models = {'MDSF','CTMF','AFNet','PCF','MMCI','TANet','DF','D3Net','CPFP','DMRA','Ours'};%LFSD

% Datasets = {'NJU2K'};
% Models = {'DF','MDSF','CTMF','AFNet','PCF','MMCI','TANet','CPFP','DMRA','D3Net','Ours'};%'NJU2K'

% Datasets = {'STERE'};
% Models = {'DF','MDSF','CTMF','AFNet','PCF','TANet','MMCI','CPFP','D3Net','Ours'};%'STERE'
%Deep Model
%DeepModels = {'DF','PDNet','CTMF','PCF'};%TPF-missing, MDSF-svm,

modelNum = length(Models);
groupNum = floor(modelNum/3)+1;

%Datasets
DataPath = '../Dataset/';
% Datasets = {'SSD'};
% Datasets = {'STERE'};%'STERE' 'DES','NLPR','NJU2K','LFSD'
%Datasets = {'GIT','SSD','DES'};
% Datasets = {'SSD','DES','LFSD','STERE','NJU2K','GIT','NLPR','SIP'};
%Datasets = {'SSD','DES','LFSD','STERE','NJU2K','NLPR','SIP'};
% 
%Results
ResDir = '../Result_overall/WeiFm_Sm/';

method_colors = linspecer(groupNum);

% colors
%str=['r','r','r','g','g','g','b','b','b','c','c','c','m','m','m','y','y','y','k','k','k','g','g','b','b','m','m','k','k','r','r','b','b','c','c','m','m'];

% str=['r','r','g','g','b','b','y','y','c','c','k','k','m','m'];
str=['y','g','b','y','c','k','m','y','g','b','r','c','m','k'];

% point label
Pstr = ['p','>','<','^','v','d','s','*','x','o','.','h'];


datasetNum = length(Datasets);
for d = 1:datasetNum
    close all;
    dataset = Datasets{d};
    fprintf('Processing %d/%d: %s Dataset\n',d,datasetNum,dataset);
    
    matPath = [ResDir dataset '-mat/'];
    plotMetrics     = gather_the_results(modelNum, matPath, Models);
    
    %% plot the WeiFm_Sm curves
    figure(1);
    hold on;
    grid on;
    axis([0 1 0 1]);
    set(gca,'XTick',[0.72:0.04:0.92]);
%     title(dataset);
    xlabel('Structure Similarity');
    ylabel('Weighted F-measure');
    set(gca,'linewidth',1.5)
    set(get(gca,'XLabel'),'FontSize',21)
    set(get(gca,'YLabel'),'FontSize',21)
    
    for i = 1 : length(plotMetrics.Alg_names)%[200 200 200]/255
%         if mod(i,2)==0
%             plot(plotMetrics.Smeasure(1,i), plotMetrics.WeiFm(1,i), '.', 'Color', str(i), 'markersize', 20);   
%         elseif mod(i,2)==1
%             plot(plotMetrics.Smeasure(1,i), plotMetrics.WeiFm(1,i), '.', 'Color', str(i), 'markersize', 20);
%         end
%         [~,max_idx] = max(plotMetrics.Fmeasure_Curve(:,i));
%         h1 = plot(plotMetrics.Recall(max_idx,i), plotMetrics.Pre(max_idx,i), '.', 'Color', str(i),'markersize',20);
        text(plotMetrics.Smeasure(1,i),plotMetrics.WeiFm(1,i),Models{i},Pstr(i), 'Color', str(i), 'markersize', 20);
        set(get(get(h1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end
%     legend(plotMetrics.Alg_names(7:11),'Location','SouthWest','FontSize',17);
    set(gcf,'position',[0 600 560 420]);
    box on
    
    figPath = [ResDir 'Curve/'];
    if ~exist(figPath,'dir')
        mkdir(figPath);
    end
%     saveas(gcf, [figPath dataset '_PRCurve.fig'] );
    saveas(gcf, [figPath dataset '_WeiFm_Sm.pdf'] );
    
end



%     plotMetrics     = gather_the_results(modelNum, matPath, Models);

function plotMetrics     = gather_the_results(modelNum, matPath, alg_params_exist)

alg_names                                   = cell(modelNum,1);
thrNum                                      = 256;
% plotMetrics.Pre                             = zeros(thrNum,modelNum);
% plotMetrics.Recall                          = zeros(thrNum,modelNum);
%plotMetrics.Fmeasure                        = zeros(thrNum,modelNum);
% plotMetrics.MAE                             = zeros(1,modelNum);
plotMetrics.Smeasure                        = zeros(thrNum,modelNum);
plotMetrics.WeiFm                             = zeros(1,modelNum);


% gather the existing results
for i = 1 : modelNum
    alg_names{i}                            = alg_params_exist{1,i};
    Metrics                                 = load([matPath,alg_names{i},'.mat']);
%     plotMetrics.Pre(:,i)                    = Metrics.column_Pr;
%     plotMetrics.Recall(:,i)                 = Metrics.column_Rec;
    %plotMetrics.Fmeasure(:,i)               = Metrics.column_F;
%     plotMetrics.MAE(:,i)                    = Metrics.MAE;
    plotMetrics.Smeasure(:,i)               = Metrics.Smeasure;
    plotMetrics.WeiFm(:,i)                    = Metrics.WeiFm;
end
% plotMetrics.Fmeasure_Curve              = (1+0.3).*plotMetrics.Pre.*plotMetrics.Recall./...
%     (0.3*plotMetrics.Pre+plotMetrics.Recall);
plotMetrics.Alg_names                   = alg_names;

end

