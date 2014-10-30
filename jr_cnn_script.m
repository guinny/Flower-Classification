%JR_CNN_SCRIPT Script generates photo file names and passes them to jr_cnn
%and saves the returned feature vector

% flowerSetNumber allows easy switching of flower sets. 3, 17 or 102
flowerSetNumber = 3;

% import vector of flower file names, change format from cell to matrix
imageName = jr_import_flower_file_names;
imageName = cell2mat(imageName);

% find max index of flowers
maxFlowerIndex = size(imageName, 1);

% generate vector of image categorisation labels
imageLabels = load('oxfordflower3/jpg/labels.mat');
imageLabels = (cell2mat(struct2cell(imageLabels)));
if flowerSetNumber == 3
    imageLabels = imageLabels(1:maxFlowerIndex);
end

% define vectors containing the indeces of training and testing data
trainingIndexVector = [1:40, 81:120, 161:200];
testIndexVector = [41:80, 121:160, 201:240];




% generate trainingInstanceMatrix storing training flower feature data
if ~exist('trainingInstanceMatrix.mat')
    trainingInstanceMatrix = ones(size(trainingIndexVector, 2), 1000);
    for i = 1 : size(trainingIndexVector, 2)
        trainingInstanceMatrix(i, :) = jr_cnn(imageName(trainingIndexVector(i), :));
    end
    save('trainingInstanceMatrix.mat', 'trainingInstanceMatrix');
end
    
% generate testInstanceMatrix storing training flower feature data
if ~exist('testInstanceMatrix.mat')
    testInstanceMatrix = ones(size(trainingIndexVector, 2), 1000);
    for i = 1 : size(trainingIndexVector, 2)
        testInstanceMatrix(i, :) = jr_cnn(imageName(testIndexVector(i), :));
    end
    save('testInstanceMatrix.mat', 'testInstanceMatrix')
end

% generate labelVectors
if 1
   lableVectorOne = -ones(120, 1);
   lableVectorOne(1:40) = 1;
   
   lableVectorTwo = -ones(120,1);
   lableVectorTwo(41:80) = 1;
   
   lableVectorThree = -ones(120,1);
   lableVectorThree(81:120) = 1;
end

% train and test models 
jr_svm_script


