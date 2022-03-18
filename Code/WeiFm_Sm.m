clear all; close all; clc;

%SaliencyMap Path
SalMapPath = '../SalMap/';  %The saliency map results can be downloaded from our webpage: http://dpfan.net/d3netbenchmark/
% SalMapPath = '../SalMap/Ablation_study/';  %The saliency map results can be downloaded from our webpage: http://dpfan.net/d3netbenchmark/


%Evaluated Models
% Models = {'MDSF','DF','CTMF','AFNet','PCF','MMCI','TANet','CPFP','DMRA','D3Net','LGY06'};
% Models = {'Ours-cvpr','LHM','DESM','ACSD','GP','LBE','SE','DCMC'};
% Models = {'MDSF','DF','CTMF','AFNet','PCF','MMCI','TANet','CPFP','D3Net','LGY06'};
% Models = {'MDSF','DF','CTMF','AFNet','PCF','MMCI','TANet','CPFP','DMRA','D3Net','LGY06','Ours-cvpr','LHM','DESM','ACSD','GP','LBE','SE','DCMC'};
% Models = {'AS_all_cvpr','AS_Kernal','AS_Dila','AS_no_Cross','AS_no_crosslayer','AS_no_DeepSup','AS_no_sharingWei','AS_wo_depthwei','AS_wo_selfwei'};AS_wo_selfwei_4
Models = {'DTM'};


%Datasets
DataPath = '../Dataset/';
Datasets = {'LFSD','DES','NJU2K','NLPR','SSD','SIP','STERE'};
% Datasets = {'LFSD','DES','NJU2K','NLPR','STERE'};
% Datasets = {'SIP'};
% Datasets = {'SSD','SIP','STERE'};

%Evaluated Score Results
ResDir = '../Result_overall/WeiFm_Sm/';

%Initial paramters setting
Thresholds = 1:-1/255:0;
datasetNum = length(Datasets);
modelNum = length(Models);

for d = 1:datasetNum
    
    tic;
    dataset = Datasets{d};
    fprintf('Processing %d/%d: %s Dataset\n',d,datasetNum,dataset);
    
    ResPath = [ResDir dataset '-mat/'];
    if ~exist(ResPath,'dir')
        mkdir(ResPath);
    end
    resTxt = [ResDir dataset '_result-WeiFm_Sm.txt'];
    fileID = fopen(resTxt,'w');
    
    for m = 1:modelNum
        model = Models{m};
        
        gtPath = [DataPath dataset '/GT/'];
                
        salPath = [SalMapPath model '/' dataset '/'];
        
        imgFiles = dir([salPath '*.png']);
        imgNUM = length(imgFiles);
        
        [Smeasure, weiFm] =deal(zeros(1,imgNUM));
        
        parfor i = 1:imgNUM  %parfor i = 1:imgNUM  You may also need the parallel strategy. 
            
            fprintf('Evaluating(%s Dataset,%s Model): %d/%d\n',dataset, model, i,imgNUM);
            name =  imgFiles(i).name;
            
            %load gt
            
            gt = imread([gtPath name ]);
            
            if (ndims(gt)>2)
                gt = rgb2gray(gt);
            end
            
            if ~islogical(gt)
                gt = gt(:,:,1) > 128;
            end
            
            %load salency

             sal  = imread([salPath name]);
%              imwrite(sal,[salPath '/a/' name]);
            
            %check size
            if size(sal, 1) ~= size(gt, 1) || size(sal, 2) ~= size(gt, 2)
                sal = imresize(sal,size(gt));
                imwrite(sal,[salPath name]);
                fprintf('Error occurs in the path: %s!!!\n', [salPath name]); %check whether the size of the salmap is equal the gt map.
            end
            
            sal = im2double(sal(:,:,1));
            
            %normalize sal to [0, 1]
            sal = reshape(mapminmax(sal(:)',0,1),size(sal));
            Sscore = StructureMeasure(sal,logical(gt));
            Smeasure(i) = Sscore;
          
            [weiFm(i)]= WFb(sal,gt);

        end
         
        %Smeasure score
        Smeasure = mean2(Smeasure);
   
        %weighted F-m score
        WeiFm = mean2(weiFm);
        
        %Save the mat file so that you can reload the mat file and plot the PR Curve
        save([ResPath model],'Smeasure','WeiFm');
       
        fprintf(fileID, '(Dataset:%s; Model:%s) Smeasure:%.3f; WeiFm:%.3f.\n',dataset,model,Smeasure,WeiFm);   
    end
    toc;
    
end


