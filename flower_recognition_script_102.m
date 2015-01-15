% FLOWER_RECOGNITION_SCRIPT 102
% TODO resplit data, run tests again, average accuracy increase, standard
% deviation, 

use_mirror = 1;
use_jitter = 0;
do_svm = 1;

% initialise variables
flower_set_number = 102;
image_folder = 'oxfordflower102/';

% import vector of flower file names
image_name = importdata(strcat(image_folder,'files.txt'));
image_name = cell2mat(image_name);

load(strcat(image_folder, 'setid.mat'));


% generate vector of image categorisation labels
image_labels = load(strcat(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));


% load / generate instance matrix
[instance_matrix, new_image_labels] = cnn_generate_instance_matrix ...
    (image_name, image_folder, image_labels, use_mirror, use_jitter);


% generate train test matrices
[train_instance_matrix, test_instance_matrix, ...
    train_label_vector, test_label_vector] = ...
    generate_train_test_matrices ( ... 
    instance_matrix, trnid, valid, tstid, new_image_labels);


% train models 
if do_svm
[weight_matrix, model_labels] = svm_train_102( ... 
    flower_set_number, train_instance_matrix, train_label_vector);
end

% test models
if do_svm
decision_values = ...
    svm_test_102(flower_set_number, test_instance_matrix, weight_matrix);
end


% measure quality of results; confusion matrix, contingency table, ROC,
% and error (sum of false positives and false negatives)
% TODO export confusion matrices
confusion_matrix = generate_confusion_matrix_102( ... 
    decision_values, tstid, new_image_labels);


% find average accuracy = 85.3% for non mirror; 85.7% mirror
confusion_matrix_accuracy = trace(confusion_matrix) / ...
    flower_set_number;

% generate confusion matrix diagram
ImshowAxesVisible = true;
imshow(confusion_matrix, 'InitialMagnification',400) 
colormap(jet)


plot_rank_accuracy(decision_values, tstid, image_labels)

%{ 
contingency_table = generate_contingency_table( ...
    flower_set_number, decision_values);
roc_matrix = generate_roc_curve(decision_values);
error = generate_error(contingency_table);


% calculate Area Under Curve for ROC curves
area_under_curve = zeros(flower_set_number, 1);
for i = 1 : size(area_under_curve, 1)
    area_under_curve(i) = trapz(roc_matrix(2 * i + 1, :), ...
        roc_matrix(2 * i , :));
end


    
for i = 1 : flower_set_number
    plot(roc_matrix(2 * i + 1, :), roc_matrix(2 * i, :));
    hold on
end
axis([0 1 0 1])  

    
if 0
    generate_app_js(flower_set_number, image_name, decision_values, ...
    training_index_vector, test_index_vector, ...
    training_instance_matrix, test_instance_matrix);
end


%}


        

        
        
        
        