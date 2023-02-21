% THIS SCRIPT GENERATES A DIVERSIFIED TRAINING DATASET, USING THE ORIGINAL DATASET

% TRAINING DATASET FOR IRIS
%   - 120 inputs (40 for each label)
%   - noise tolerance of original network: < 1%

%% Run loop until valid diversified dataset obtained

condition = true;

while condition

    %%
    clc
    clear all
    close all

    %% Load original dataset

    temp = readtable('Datasets/iris_train.csv'); %last col of each row is label
    train_data = table2array(temp(:,2:size(temp,2)-1));
    train_label = table2array(temp(:,size(temp,2)));

    % temp = readtable('iris_test.csv'); %last col of each row is label
    % test_data = table2array(temp(:,2:size(temp,2)-1));
    % test_label = table2array(temp(:,size(temp,2)));

    clear temp

    %% Number of total and misclassfied inputs from each class --> from counterexample analysis of original network

    mis_label1 = 422;
    total_label1 = 326520;
    mis_label2 = 44609;
    total_label2 = 326520;
    mis_label3 = 116147;
    total_label3 = 326520;

    %% Split the inputs according to their labels

    %Initilize
    corr_train_data1 = []; 
    corr_train_label1 = []; %'Setosa'
    corr_train_data2 = [];
    corr_train_label2 = []; %'Versicolor'
    corr_train_data3 = [];
    corr_train_label3 = []; %'Virginica'

    for i = 1:size(train_data,1)

        if strcmp(train_label(i),'Setosa')
           corr_train_data1 = [corr_train_data1 ; train_data(i,:)];
           corr_train_label1 = [corr_train_label1 ; train_label(i)];
        elseif strcmp(train_label(i),'Versicolor')
           corr_train_data2 = [corr_train_data2 ; train_data(i,:)];
           corr_train_label2 = [corr_train_label2 ; train_label(i)];
        else
           corr_train_data3 = [corr_train_data3 ; train_data(i,:)];
           corr_train_label3 = [corr_train_label3 ; train_label(i)];
        end

    end

    %% Feature Correlation for each class in training dataset

    corr_label1 = corrcoef(corr_train_data1);
    corr_label2 = corrcoef(corr_train_data2);
    corr_label3 = corrcoef(corr_train_data3);

    %% Bound Determination: using noise tolerance (x) and feature extremum

    x = 0; %tolerance

    for label = 1:size(unique(train_label),1)
        for feature = 1:size(train_data,2)

           a = (1-x)*min(eval(['corr_train_data' num2str(label) '(:,' num2str(feature) ')']));
           b = (1+x)*min(eval(['corr_train_data' num2str(label) '(:,' num2str(feature) ')']));
           c = (1-x)*max(eval(['corr_train_data' num2str(label) '(:,' num2str(feature) ')']));
           d = (1+x)*max(eval(['corr_train_data' num2str(label) '(:,' num2str(feature) ')']));
            eval(['Global_Feature' num2str(feature) '_min_label' num2str(label) ' = min(min(min(a,b),c),d);'])
            eval(['Global_Feature' num2str(feature) '_max_label' num2str(label) ' = max(max(max(a,b),c),d);'])

        end
    end

    %% Bound Tightening: in case of overlaps

    % Feature 1
    P = true; %in case there is problem in bound calculation, rerun loop

    while P
        P = false;
        %Check  ranges for feature, for each label
        a = Global_Feature1_max_label1 - Global_Feature1_min_label1;
        b = Global_Feature1_max_label2 - Global_Feature1_min_label2;
        c = Global_Feature1_max_label3 - Global_Feature1_min_label3;
        [d ID] = sort([a b c]);     %to decide which label to deal with first

        %To eliminate the overlap already dealt with
        flag1 = true;
        flag2 = true;
        flag3 = true;

        for i = 1:length(unique(train_label)) 
            n = num2str(ID(i));
            if i < length(unique(train_label)) 
                m = num2str(ID(i+1));
            else
                m = 'and';
            end

            if contains('Labels 1 and 2', n) && contains('Labels 1 and 2', m) && flag1         % Overlap in Labels 1 and 2
                %-------------------------------------------------------------------------

                if ~((Global_Feature1_min_label1 >= Global_Feature1_max_label2) || (Global_Feature1_min_label2 >= Global_Feature1_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature1_min_label1 >= Global_Feature1_min_label2) && (Global_Feature1_min_label1 <= Global_Feature1_max_label2))
                        Global_Feature1_min_label1 = Global_Feature1_max_label2;
                        Global_Feature1_max_label2 = Global_Feature1_min_label1;
                    end
                    if ((Global_Feature1_max_label1 >= Global_Feature1_min_label2) && (Global_Feature1_max_label1 <= Global_Feature1_max_label2))
                        Global_Feature1_max_label1 = Global_Feature1_min_label2;
                        Global_Feature1_min_label2 = Global_Feature1_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature1_min_label1 >= Global_Feature1_min_label2) && (Global_Feature1_max_label2 >= Global_Feature1_max_label1))
                        a = Global_Feature1_min_label1 - Global_Feature1_min_label2;
                        b = Global_Feature1_max_label2 - Global_Feature1_max_label1;
                        if a > b
                            Global_Feature1_max_label2 = Global_Feature1_min_label1;
                        else
                            Global_Feature1_min_label2 = Global_Feature1_max_label1;
                        end
                    end
                    if ((Global_Feature1_min_label2 >= Global_Feature1_min_label1) && (Global_Feature1_max_label1 >= Global_Feature1_max_label2))
                        a = Global_Feature1_min_label2 - Global_Feature1_min_label1;
                        b = Global_Feature1_max_label1 - Global_Feature1_max_label2;
                        if a > b
                            Global_Feature1_max_label1 = Global_Feature1_min_label2;
                        else
                            Global_Feature1_min_label1 = Global_Feature1_max_label2;
                        end
                    end
                end
                flag1 = false;

            elseif contains('Labels 1 and 3', n) && contains('Labels 1 and 3', m) && flag2         % Overlap in Labels 1 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature1_min_label1 >= Global_Feature1_max_label3) || (Global_Feature1_min_label3 >= Global_Feature1_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature1_min_label1 >= Global_Feature1_min_label3) && (Global_Feature1_min_label1 <= Global_Feature1_max_label3))
                        Global_Feature1_min_label1 = Global_Feature1_max_label3;
                        Global_Feature1_max_label3 = Global_Feature1_min_label1;
                    end
                    if ((Global_Feature1_max_label1 >= Global_Feature1_min_label3) && (Global_Feature1_max_label1 <= Global_Feature1_max_label3))
                        Global_Feature1_max_label1 = Global_Feature1_min_label3;
                        Global_Feature1_min_label3 = Global_Feature1_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature1_min_label1 >= Global_Feature1_min_label3) && (Global_Feature1_max_label3 >= Global_Feature1_max_label1))
                        a = Global_Feature1_min_label1 - Global_Feature1_min_label3;
                        b = Global_Feature1_max_label3 - Global_Feature1_max_label1;
                        if a > b
                            Global_Feature1_max_label3 = Global_Feature1_min_label1;
                        else
                            Global_Feature1_min_label3 = Global_Feature1_max_label1;
                        end
                    end
                    if ((Global_Feature1_min_label3 >= Global_Feature1_min_label1) && (Global_Feature1_max_label1 >= Global_Feature1_max_label3))
                        a = Global_Feature1_min_label3 - Global_Feature1_min_label1;
                        b = Global_Feature1_max_label1 - Global_Feature1_max_label3;
                        if a > b
                            Global_Feature1_max_label1 = Global_Feature1_min_label3;
                        else
                            Global_Feature1_min_label1 = Global_Feature1_max_label3;
                        end
                    end
                end
                flag2 = false;

            elseif contains('Labels 2 and 3', n) && contains('Labels 2 and 3', m) && flag3         % Overlap in Labels 2 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature1_min_label3 >= Global_Feature1_max_label2) || (Global_Feature1_min_label2 >= Global_Feature1_max_label3)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature1_min_label3 >= Global_Feature1_min_label2) && (Global_Feature1_min_label3 <= Global_Feature1_max_label2))
                        Global_Feature1_min_label3 = Global_Feature1_max_label2;
                        Global_Feature1_max_label2 = Global_Feature1_min_label3;
                    end
                    if ((Global_Feature1_max_label3 >= Global_Feature1_min_label2) && (Global_Feature1_max_label3 <= Global_Feature1_max_label2))
                        Global_Feature1_max_label3 = Global_Feature1_min_label2;
                        Global_Feature1_min_label2 = Global_Feature1_max_label3;
                    end

                    %Complete overlap
                    if ((Global_Feature1_min_label3 >= Global_Feature1_min_label2) && (Global_Feature1_max_label2 >= Global_Feature1_max_label3))
                        a = Global_Feature1_min_label3 - Global_Feature1_min_label2;
                        b = Global_Feature1_max_label2 - Global_Feature1_max_label3;
                        if a > b
                            Global_Feature1_max_label2 = Global_Feature1_min_label3;
                        else
                            Global_Feature1_min_label2 = Global_Feature1_max_label3;
                        end
                    end
                    if ((Global_Feature1_min_label2 >= Global_Feature1_min_label3) && (Global_Feature1_max_label3 >= Global_Feature1_max_label2))
                        a = Global_Feature1_min_label2 - Global_Feature1_min_label3;
                        b = Global_Feature1_max_label3 - Global_Feature1_max_label2;
                        if a > b
                            Global_Feature1_max_label3 = Global_Feature1_min_label2;
                        else
                            Global_Feature1_min_label3 = Global_Feature1_max_label2;
                        end
                    end
                end  
                flag3 = false;

            else
                disp('Something is Wrong....with Feature1 bound tightening...Rerun the loop to determine bounds for Feature1...')
                P = true;
            end
        end

    end

    % Feature 2
    P = true; %in case there is problem in bound calculation, rerun loop

    while P
        P = false;
        %Check  ranges for feature, for each label
        a = Global_Feature2_max_label1 - Global_Feature2_min_label1;
        b = Global_Feature2_max_label2 - Global_Feature2_min_label2;
        c = Global_Feature2_max_label3 - Global_Feature2_min_label3;
        [d ID] = sort([a b c]);     %to decide which label to deal with first

        %To eliminate the overlap already dealt with
        flag1 = true;
        flag2 = true;
        flag3 = true;

        for i = 1:length(unique(train_label)) 
            n = num2str(ID(i));
            if i < length(unique(train_label)) 
                m = num2str(ID(i+1));
            else
                m = 'and';
            end

            if contains('Labels 1 and 2', n) && contains('Labels 1 and 2', m) && flag1         % Overlap in Labels 1 and 2
                %-------------------------------------------------------------------------

                if ~((Global_Feature2_min_label1 >= Global_Feature2_max_label2) || (Global_Feature2_min_label2 >= Global_Feature2_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature2_min_label1 >= Global_Feature2_min_label2) && (Global_Feature2_min_label1 <= Global_Feature2_max_label2))
                        Global_Feature2_min_label1 = Global_Feature2_max_label2;
                        Global_Feature2_max_label2 = Global_Feature2_min_label1;
                    end
                    if ((Global_Feature2_max_label1 >= Global_Feature2_min_label2) && (Global_Feature2_max_label1 <= Global_Feature2_max_label2))
                        Global_Feature2_max_label1 = Global_Feature2_min_label2;
                        Global_Feature2_min_label2 = Global_Feature2_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature2_min_label1 >= Global_Feature2_min_label2) && (Global_Feature2_max_label2 >= Global_Feature2_max_label1))
                        a = Global_Feature2_min_label1 - Global_Feature2_min_label2;
                        b = Global_Feature2_max_label2 - Global_Feature2_max_label1;
                        if a > b
                            Global_Feature2_max_label2 = Global_Feature2_min_label1;
                        else
                            Global_Feature2_min_label2 = Global_Feature2_max_label1;
                        end
                    end
                    if ((Global_Feature2_min_label2 >= Global_Feature2_min_label1) && (Global_Feature2_max_label1 >= Global_Feature2_max_label2))
                        a = Global_Feature2_min_label2 - Global_Feature2_min_label1;
                        b = Global_Feature2_max_label1 - Global_Feature2_max_label2;
                        if a > b
                            Global_Feature2_max_label1 = Global_Feature2_min_label2;
                        else
                            Global_Feature2_min_label1 = Global_Feature2_max_label2;
                        end
                    end
                end
                flag1 = false;

            elseif contains('Labels 1 and 3', n) && contains('Labels 1 and 3', m) && flag2         % Overlap in Labels 1 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature2_min_label1 >= Global_Feature2_max_label3) || (Global_Feature2_min_label3 >= Global_Feature2_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature2_min_label1 >= Global_Feature2_min_label3) && (Global_Feature2_min_label1 <= Global_Feature2_max_label3))
                        Global_Feature2_min_label1 = Global_Feature2_max_label3;
                        Global_Feature2_max_label3 = Global_Feature2_min_label1;
                    end
                    if ((Global_Feature2_max_label1 >= Global_Feature2_min_label3) && (Global_Feature2_max_label1 <= Global_Feature2_max_label3))
                        Global_Feature2_max_label1 = Global_Feature2_min_label3;
                        Global_Feature2_min_label3 = Global_Feature2_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature2_min_label1 >= Global_Feature2_min_label3) && (Global_Feature2_max_label3 >= Global_Feature2_max_label1))
                        a = Global_Feature2_min_label1 - Global_Feature2_min_label3;
                        b = Global_Feature2_max_label3 - Global_Feature2_max_label1;
                        if a > b
                            Global_Feature2_max_label3 = Global_Feature2_min_label1;
                        else
                            Global_Feature2_min_label3 = Global_Feature2_max_label1;
                        end
                    end
                    if ((Global_Feature2_min_label3 >= Global_Feature2_min_label1) && (Global_Feature2_max_label1 >= Global_Feature2_max_label3))
                        a = Global_Feature2_min_label3 - Global_Feature2_min_label1;
                        b = Global_Feature2_max_label1 - Global_Feature2_max_label3;
                        if a > b
                            Global_Feature2_max_label1 = Global_Feature2_min_label3;
                        else
                            Global_Feature2_min_label1 = Global_Feature2_max_label3;
                        end
                    end
                end
                flag2 = false;

            elseif contains('Labels 2 and 3', n) && contains('Labels 2 and 3', m) && flag3         % Overlap in Labels 2 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature2_min_label3 >= Global_Feature2_max_label2) || (Global_Feature2_min_label2 >= Global_Feature2_max_label3)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature2_min_label3 >= Global_Feature2_min_label2) && (Global_Feature2_min_label3 <= Global_Feature2_max_label2))
                        Global_Feature2_min_label3 = Global_Feature2_max_label2;
                        Global_Feature2_max_label2 = Global_Feature2_min_label3;
                    end
                    if ((Global_Feature2_max_label3 >= Global_Feature2_min_label2) && (Global_Feature2_max_label3 <= Global_Feature2_max_label2))
                        Global_Feature2_max_label3 = Global_Feature2_min_label2;
                        Global_Feature2_min_label2 = Global_Feature2_max_label3;
                    end

                    %Complete overlap
                    if ((Global_Feature2_min_label3 >= Global_Feature2_min_label2) && (Global_Feature2_max_label2 >= Global_Feature2_max_label3))
                        a = Global_Feature2_min_label3 - Global_Feature2_min_label2;
                        b = Global_Feature2_max_label2 - Global_Feature2_max_label3;
                        if a > b
                            Global_Feature2_max_label2 = Global_Feature2_min_label3;
                        else
                            Global_Feature2_min_label2 = Global_Feature2_max_label3;
                        end
                    end
                    if ((Global_Feature2_min_label2 >= Global_Feature2_min_label3) && (Global_Feature2_max_label3 >= Global_Feature2_max_label2))
                        a = Global_Feature2_min_label2 - Global_Feature2_min_label3;
                        b = Global_Feature2_max_label3 - Global_Feature2_max_label2;
                        if a > b
                            Global_Feature2_max_label3 = Global_Feature2_min_label2;
                        else
                            Global_Feature2_min_label3 = Global_Feature2_max_label2;
                        end
                    end
                end  
                flag3 = false;

            else
                disp('Something is Wrong....with Feature2 bound tightening...Rerun the loop to determine bounds for Feature2...')
                P = true;
            end
        end

    end

    % Feature 3
    P = true; %in case there is problem in bound calculation, rerun loop

    while P
        P = false;
        %Check  ranges for feature, for each label
        a = Global_Feature3_max_label1 - Global_Feature3_min_label1;
        b = Global_Feature3_max_label2 - Global_Feature3_min_label2;
        c = Global_Feature3_max_label3 - Global_Feature3_min_label3;
        [d ID] = sort([a b c]);     %to decide which label to deal with first

        %To eliminate the overlap already dealt with
        flag1 = true;
        flag2 = true;
        flag3 = true;

        for i = 1:length(unique(train_label)) 
            n = num2str(ID(i));
            if i < length(unique(train_label)) 
                m = num2str(ID(i+1));
            else
                m = 'and';
            end

            if contains('Labels 1 and 2', n) && contains('Labels 1 and 2', m) && flag1         % Overlap in Labels 1 and 2
                %-------------------------------------------------------------------------

                if ~((Global_Feature3_min_label1 >= Global_Feature3_max_label2) || (Global_Feature3_min_label2 >= Global_Feature3_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature3_min_label1 >= Global_Feature3_min_label2) && (Global_Feature3_min_label1 <= Global_Feature3_max_label2))
                        Global_Feature3_min_label1 = Global_Feature3_max_label2;
                        Global_Feature3_max_label2 = Global_Feature3_min_label1;
                    end
                    if ((Global_Feature3_max_label1 >= Global_Feature3_min_label2) && (Global_Feature3_max_label1 <= Global_Feature3_max_label2))
                        Global_Feature3_max_label1 = Global_Feature3_min_label2;
                        Global_Feature3_min_label2 = Global_Feature3_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature3_min_label1 >= Global_Feature3_min_label2) && (Global_Feature3_max_label2 >= Global_Feature3_max_label1))
                        a = Global_Feature3_min_label1 - Global_Feature3_min_label2;
                        b = Global_Feature3_max_label2 - Global_Feature3_max_label1;
                        if a > b
                            Global_Feature3_max_label2 = Global_Feature3_min_label1;
                        else
                            Global_Feature3_min_label2 = Global_Feature3_max_label1;
                        end
                    end
                    if ((Global_Feature3_min_label2 >= Global_Feature3_min_label1) && (Global_Feature3_max_label1 >= Global_Feature3_max_label2))
                        a = Global_Feature3_min_label2 - Global_Feature3_min_label1;
                        b = Global_Feature3_max_label1 - Global_Feature3_max_label2;
                        if a > b
                            Global_Feature3_max_label1 = Global_Feature3_min_label2;
                        else
                            Global_Feature3_min_label1 = Global_Feature3_max_label2;
                        end
                    end
                end
                flag1 = false;

            elseif contains('Labels 1 and 3', n)  && contains('Labels 1 and 3', m) && flag2         % Overlap in Labels 1 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature3_min_label1 >= Global_Feature3_max_label3) || (Global_Feature3_min_label3 >= Global_Feature3_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature3_min_label1 >= Global_Feature3_min_label3) && (Global_Feature3_min_label1 <= Global_Feature3_max_label3))
                        Global_Feature3_min_label1 = Global_Feature3_max_label3;
                        Global_Feature3_max_label3 = Global_Feature3_min_label1;
                    end
                    if ((Global_Feature3_max_label1 >= Global_Feature3_min_label3) && (Global_Feature3_max_label1 <= Global_Feature3_max_label3))
                        Global_Feature3_max_label1 = Global_Feature3_min_label3;
                        Global_Feature3_min_label3 = Global_Feature3_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature3_min_label1 >= Global_Feature3_min_label3) && (Global_Feature3_max_label3 >= Global_Feature3_max_label1))
                        a = Global_Feature3_min_label1 - Global_Feature3_min_label3;
                        b = Global_Feature3_max_label3 - Global_Feature3_max_label1;
                        if a > b
                            Global_Feature3_max_label3 = Global_Feature3_min_label1;
                        else
                            Global_Feature3_min_label3 = Global_Feature3_max_label1;
                        end
                    end
                    if ((Global_Feature3_min_label3 >= Global_Feature3_min_label1) && (Global_Feature3_max_label1 >= Global_Feature3_max_label3))
                        a = Global_Feature3_min_label3 - Global_Feature3_min_label1;
                        b = Global_Feature3_max_label1 - Global_Feature3_max_label3;
                        if a > b
                            Global_Feature3_max_label1 = Global_Feature3_min_label3;
                        else
                            Global_Feature3_min_label1 = Global_Feature3_max_label3;
                        end
                    end
                end
                flag2 = false;

            elseif contains('Labels 2 and 3', n) && contains('Labels 2 and 3', m) && flag3         % Overlap in Labels 2 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature3_min_label3 >= Global_Feature3_max_label2) || (Global_Feature3_min_label2 >= Global_Feature3_max_label3)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature3_min_label3 >= Global_Feature3_min_label2) && (Global_Feature3_min_label3 <= Global_Feature3_max_label2))
                        Global_Feature3_min_label3 = Global_Feature3_max_label2;
                        Global_Feature3_max_label2 = Global_Feature3_min_label3;
                    end
                    if ((Global_Feature3_max_label3 >= Global_Feature3_min_label2) && (Global_Feature3_max_label3 <= Global_Feature3_max_label2))
                        Global_Feature3_max_label3 = Global_Feature3_min_label2;
                        Global_Feature3_min_label2 = Global_Feature3_max_label3;
                    end

                    %Complete overlap
                    if ((Global_Feature3_min_label3 >= Global_Feature3_min_label2) && (Global_Feature3_max_label2 >= Global_Feature3_max_label3))
                        a = Global_Feature3_min_label3 - Global_Feature3_min_label2;
                        b = Global_Feature3_max_label2 - Global_Feature3_max_label3;
                        if a > b
                            Global_Feature3_max_label2 = Global_Feature3_min_label3;
                        else
                            Global_Feature3_min_label2 = Global_Feature3_max_label3;
                        end
                    end
                    if ((Global_Feature3_min_label2 >= Global_Feature3_min_label3) && (Global_Feature3_max_label3 >= Global_Feature3_max_label2))
                        a = Global_Feature3_min_label2 - Global_Feature3_min_label3;
                        b = Global_Feature3_max_label3 - Global_Feature3_max_label2;
                        if a > b
                            Global_Feature3_max_label3 = Global_Feature3_min_label2;
                        else
                            Global_Feature3_min_label3 = Global_Feature3_max_label2;
                        end
                    end
                end  
                flag3 = false;

            else
                disp('Something is Wrong....with Feature3 bound tightening...Rerun the loop to determine bounds for Feature3...')
                P = true;
            end
        end

    end

    % Feature 4
    P = true; %in case there is problem in bound calculation, rerun loop

    while P
        P = false;
        %Check  ranges for feature, for each label
        a = Global_Feature4_max_label1 - Global_Feature4_min_label1;
        b = Global_Feature4_max_label2 - Global_Feature4_min_label2;
        c = Global_Feature4_max_label3 - Global_Feature4_min_label3;
        [d ID] = sort([a b c]);     %to decide which label to deal with first

        %To eliminate the overlap already dealt with
        flag1 = true;
        flag2 = true;
        flag3 = true;

        for i = 1:length(unique(train_label)) 
            n = num2str(ID(i));

            if contains('Labels 1 and 2', n) && flag1         % Overlap in Labels 1 and 2
                %-------------------------------------------------------------------------

                if ~((Global_Feature4_min_label1 >= Global_Feature4_max_label2) || (Global_Feature4_min_label2 >= Global_Feature4_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature4_min_label1 >= Global_Feature4_min_label2) && (Global_Feature4_min_label1 <= Global_Feature4_max_label2))
                        Global_Feature4_min_label1 = Global_Feature4_max_label2;
                        Global_Feature4_max_label2 = Global_Feature4_min_label1;
                    end
                    if ((Global_Feature4_max_label1 >= Global_Feature4_min_label2) && (Global_Feature4_max_label1 <= Global_Feature4_max_label2))
                        Global_Feature4_max_label1 = Global_Feature4_min_label2;
                        Global_Feature4_min_label2 = Global_Feature4_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature4_min_label1 >= Global_Feature4_min_label2) && (Global_Feature4_max_label2 >= Global_Feature4_max_label1))
                        a = Global_Feature4_min_label1 - Global_Feature4_min_label2;
                        b = Global_Feature4_max_label2 - Global_Feature4_max_label1;
                        if a > b
                            Global_Feature4_max_label2 = Global_Feature4_min_label1;
                        else
                            Global_Feature4_min_label2 = Global_Feature4_max_label1;
                        end
                    end
                    if ((Global_Feature4_min_label2 >= Global_Feature4_min_label1) && (Global_Feature4_max_label1 >= Global_Feature4_max_label2))
                        a = Global_Feature4_min_label2 - Global_Feature4_min_label1;
                        b = Global_Feature4_max_label1 - Global_Feature4_max_label2;
                        if a > b
                            Global_Feature4_max_label1 = Global_Feature4_min_label2;
                        else
                            Global_Feature4_min_label1 = Global_Feature4_max_label2;
                        end
                    end
                end
                flag1 = false;

            elseif contains('Labels 1 and 3', n) && flag2         % Overlap in Labels 1 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature4_min_label1 >= Global_Feature4_max_label3) || (Global_Feature4_min_label3 >= Global_Feature4_max_label1)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature4_min_label1 >= Global_Feature4_min_label3) && (Global_Feature4_min_label1 <= Global_Feature4_max_label3))
                        Global_Feature4_min_label1 = Global_Feature4_max_label3;
                        Global_Feature4_max_label3 = Global_Feature4_min_label1;
                    end
                    if ((Global_Feature4_max_label1 >= Global_Feature4_min_label3) && (Global_Feature4_max_label1 <= Global_Feature4_max_label3))
                        Global_Feature4_max_label1 = Global_Feature4_min_label3;
                        Global_Feature4_min_label3 = Global_Feature4_max_label1;
                    end

                    %Complete overlap
                    if ((Global_Feature4_min_label1 >= Global_Feature4_min_label3) && (Global_Feature4_max_label3 >= Global_Feature4_max_label1))
                        a = Global_Feature4_min_label1 - Global_Feature4_min_label3;
                        b = Global_Feature4_max_label3 - Global_Feature4_max_label1;
                        if a > b
                            Global_Feature4_max_label3 = Global_Feature4_min_label1;
                        else
                            Global_Feature4_min_label3 = Global_Feature4_max_label1;
                        end
                    end
                    if ((Global_Feature4_min_label3 >= Global_Feature4_min_label1) && (Global_Feature4_max_label1 >= Global_Feature4_max_label3))
                        a = Global_Feature4_min_label3 - Global_Feature4_min_label1;
                        b = Global_Feature4_max_label1 - Global_Feature4_max_label3;
                        if a > b
                            Global_Feature4_max_label1 = Global_Feature4_min_label3;
                        else
                            Global_Feature4_min_label1 = Global_Feature4_max_label3;
                        end
                    end
                end
                flag2 = false;

            elseif contains('Labels 2 and 3', n) && flag3         % Overlap in Labels 2 and 3
                %-------------------------------------------------------------------------

                if ~((Global_Feature4_min_label3 >= Global_Feature4_max_label2) || (Global_Feature4_min_label2 >= Global_Feature4_max_label3)) %if there is overlap

                    %Partial Overlap
                    if ((Global_Feature4_min_label3 >= Global_Feature4_min_label2) && (Global_Feature4_min_label3 <= Global_Feature4_max_label2))
                        Global_Feature4_min_label3 = Global_Feature4_max_label2;
                        Global_Feature4_max_label2 = Global_Feature4_min_label3;
                    end
                    if ((Global_Feature4_max_label3 >= Global_Feature4_min_label2) && (Global_Feature4_max_label3 <= Global_Feature4_max_label2))
                        Global_Feature4_max_label3 = Global_Feature4_min_label2;
                        Global_Feature4_min_label2 = Global_Feature4_max_label3;
                    end

                    %Complete overlap
                    if ((Global_Feature4_min_label3 >= Global_Feature4_min_label2) && (Global_Feature4_max_label2 >= Global_Feature4_max_label3))
                        a = Global_Feature4_min_label3 - Global_Feature4_min_label2;
                        b = Global_Feature4_max_label2 - Global_Feature4_max_label3;
                        if a > b
                            Global_Feature4_max_label2 = Global_Feature4_min_label3;
                        else
                            Global_Feature4_min_label2 = Global_Feature4_max_label3;
                        end
                    end
                    if ((Global_Feature4_min_label2 >= Global_Feature4_min_label3) && (Global_Feature4_max_label3 >= Global_Feature4_max_label2))
                        a = Global_Feature4_min_label2 - Global_Feature4_min_label3;
                        b = Global_Feature4_max_label3 - Global_Feature4_max_label2;
                        if a > b
                            Global_Feature4_max_label3 = Global_Feature4_min_label2;
                        else
                            Global_Feature4_min_label3 = Global_Feature4_max_label2;
                        end
                    end
                end  
                flag3 = false;

            else
                disp('Something is Wrong....with Feature4 bound tightening...Rerun the loop to determine bounds for Feature4...')
                P = true;
            end
        end

    end

    %% Check distance from centroid for each Input Feature: using k-means

    for label = 1:length(unique(train_label))
        eval(['[idx Cglobal_label' num2str(label) ' sumd_label' num2str(label) ' Dglobal_label' num2str(label) '] = kmeans(corr_train_data'  num2str(label) '(:,:),1);'])
    end

    for feature = 1:size(train_data,2)
        for label = 1:length(unique(train_label))
            eval(['[idx C sumd_label' num2str(label) ' D' num2str(feature) '_label' num2str(label) '] = kmeans(corr_train_data' num2str(label) '(:,' num2str(feature) '),1);'])
        end
    end

    %% Identify top-k most representative features

    topk = 2; %top-2 features considered
    for label = 1:length(unique(train_label))
        eval(['D_label' num2str(label) ' = [];'])
        for feature = 1:size(train_data,2)
            eval(['D_label' num2str(label) ' = [D_label' num2str(label) ' ; D' num2str(feature) '_label' num2str(label) '];'])
        end
            eval(['[Dsorted_label' num2str(label) ' indexDsorted_label' num2str(label) '] = sort(D_label' num2str(label) ');'])
    end

    % Identify the top-k features and inputs
    for label = 1:length(unique(train_label))

        %top1: features closest to the cluster centroid
        for top = 1:topk
            eval(['top' num2str(top) '_label' num2str(label) ' = 0;'])
            eval(['input_top' num2str(top) '_label' num2str(label) ' = 0;'])
        end

        temp = eval(['find(Dsorted_label' num2str(label) '~=0, 1,''first'')']);

        while (eval(['top1_label' num2str(label) '==0']) || eval(['top2_label' num2str(label) '==0']))
            for feature = 1:size(train_data,2)

                for top = 1:topk
                    if (eval(['indexDsorted_label' num2str(label) '(temp)']) > eval([num2str(feature-1) '*size(corr_train_data' num2str(label) ',1)']) && eval(['indexDsorted_label' num2str(label) '(temp)']) <= eval([num2str(feature) '*size(corr_train_data' num2str(label) ',1)']))

                        if (eval(['top' num2str(top) '_label' num2str(label) '==0']))
                            eval(['top' num2str(top) '_label' num2str(label) '=' num2str(feature) ';'])
                            if (eval(['size(find(abs(D' num2str(feature) '_label' num2str(label) '-Dsorted_label' num2str(label) '(temp))<1e-5),1)==0']))
                                eval(['input_top' num2str(top) '_label' num2str(label) ' = find((D' num2str(feature) '_label' num2str(label) '-Dsorted_label' num2str(label) '(temp)) < 1.02*min(abs(D' num2str(feature) '_label' num2str(label) '-Dsorted_label' num2str(label) '(temp))));'])
                                %if the distances are not less than 1e-5, consider inputs within 2% of the minimial distance
                            else
                                eval(['input_top' num2str(top) '_label' num2str(label) ' = find(abs(D' num2str(feature) '_label' num2str(label) '-Dsorted_label' num2str(label) '(temp))<1e-5);'])
                            end
                            temp = temp + 1;
                        elseif (eval(['top' num2str(top) '_label' num2str(label) '==1']))
                            temp = temp + 1;
                        end
                    end
                end
            end
        end
    end

    %% Identify radius of 25% of top1 and 50% of top2 features

    for label = 1:length(unique(train_label))
        x = 0.25;
        for top = 1:topk
            eval(['Num_inputs_for_radius_top' num2str(top) '_label' num2str(label) ' = ceil(' num2str(x) '*size(corr_train_data' num2str(label) ',1));'])

            for feature = 1:size(train_data,2)
                if (eval(['top' num2str(top) '_label' num2str(label) '==' num2str(feature)]))
                    eval(['[Dsorted_label' num2str(label) ' idx] = sort(D' num2str(feature) '_label' num2str(label) ');'])
                end
            end

            eval(['Radius_top' num2str(top) '_label' num2str(label) ' = abs(corr_train_data' num2str(label) '(idx(1),top' num2str(top) '_label' num2str(label) ') - corr_train_data' num2str(label) '(idx(Num_inputs_for_radius_top' num2str(top) '_label' num2str(label) '),top' num2str(top) '_label' num2str(label) '));'])

             x = x + 0.25;
        end
    end

    %% Bound Tightening for top-k features

    for label = 1:length(unique(train_label))

        %Initialize flags to track bound of which feature have been modified already and preventing feature bounds from changing back to global features
        for feature = 1:size(train_data,2)
            eval(['flag' num2str(feature) ' = true;'])
        end

        for top = 1:topk
            for feature = 1:size(train_data,2)
                if (eval(['top' num2str(top) '_label' num2str(label) '==' num2str(feature)]) && eval(['flag' num2str(feature)]))
                    eval(['Feature' num2str(feature) '_min_label' num2str(label) ' = unique(max(corr_train_data' num2str(label) '(input_top' num2str(top) '_label' num2str(label) ',top' num2str(top) '_label' num2str(label) ')-Radius_top' num2str(top) '_label' num2str(label) ', Global_Feature' num2str(feature) '_min_label' num2str(label) '));'])
                    eval(['Feature' num2str(feature) '_max_label' num2str(label) ' = unique(min(corr_train_data' num2str(label) '(input_top' num2str(top) '_label' num2str(label) ',top' num2str(top) '_label' num2str(label) ')+Radius_top' num2str(top) '_label' num2str(label) ', Global_Feature' num2str(feature) '_max_label' num2str(label) '));'])
                    eval(['flag' num2str(feature) ' = false;'])
                elseif (eval(['top' num2str(top) '_label' num2str(label) '~=' num2str(feature)]) && eval(['flag' num2str(feature)]))
                    eval(['Feature' num2str(feature) '_min_label' num2str(label) ' = Global_Feature' num2str(feature) '_min_label' num2str(label) ';'])
                    eval(['Feature' num2str(feature) '_max_label' num2str(label) ' = Global_Feature' num2str(feature) '_max_label' num2str(label) ';'])
                end
            end
        end

    end

    %% Synthetic Input Generation

    To_add_label1 = round( (mis_label1/total_label1) / min(mis_label1/total_label1, min(mis_label2/total_label2, mis_label3/total_label3)) );
    To_add_label2 = round( (mis_label2/total_label2) / min(mis_label1/total_label1, min(mis_label2/total_label2, mis_label3/total_label3)) );
    To_add_label3 = round( (mis_label3/total_label3) / min(mis_label1/total_label1, min(mis_label2/total_label2, mis_label3/total_label3)) ); 

    % For label 1
    temp = [];
    i = 0;
    while (i~=To_add_label1)
        a = rand*(Feature1_max_label1-Feature1_min_label1)+Feature1_min_label1;
        a_int = floor(a);
        a_mantissa = round(10*(a-a_int))/10;

        b = rand*(Feature2_max_label1-Feature2_min_label1)+Feature2_min_label1;
        b_int = floor(b);
        b_mantissa = round(10*(b-b_int))/10;

        c = rand*(Feature3_max_label1-Feature3_min_label1)+Feature3_min_label1;
        c_int = floor(c);
        c_mantissa = round(10*(c-c_int))/10;

        d = rand*(Feature4_max_label1-Feature4_min_label1)+Feature4_min_label1;
        d_int = floor(d);
        d_mantissa = round(10*(d-d_int))/10;

        temp = [(a_int+a_mantissa) (b_int+b_mantissa) (c_int+c_mantissa) (d_int+d_mantissa)];
        if ((temp(1)-Cglobal_label1(1))^2 +(temp(2)-Cglobal_label1(2))^2 + (temp(3)-Cglobal_label1(3))^2 + (temp(4)-Cglobal_label1(4))^2 <= max(Dglobal_label1) && isempty(intersect(train_data,temp,'rows')))
            corr_train_data1 = [corr_train_data1; temp];
            corr_train_label1 = [corr_train_label1; 'Setosa'];
            i = i + 1;
        end
    end

    % For label 2
    temp = [];
    i = 0;
    while (i~=To_add_label2)
            a = rand*(Feature1_max_label2-Feature1_min_label2)+Feature1_min_label2;
        a_int = floor(a);
        a_mantissa = round(10*(a-a_int))/10;

        b = rand*(Feature2_max_label2-Feature2_min_label2)+Feature2_min_label2;
        b_int = floor(b);
        b_mantissa = round(10*(b-b_int))/10;

        c = rand*(Feature3_max_label2-Feature3_min_label2)+Feature3_min_label2;
        c_int = floor(c);
        c_mantissa = round(10*(c-c_int))/10;

        d = rand*(Feature4_max_label2-Feature4_min_label2)+Feature4_min_label2;
        d_int = floor(d);
        d_mantissa = round(10*(d-d_int))/10;

        temp = [(a_int+a_mantissa) (b_int+b_mantissa) (c_int+c_mantissa) (d_int+d_mantissa)];
        if ((temp(1)-Cglobal_label2(1))^2 +(temp(2)-Cglobal_label2(2))^2 + (temp(3)-Cglobal_label2(3))^2 + (temp(4)-Cglobal_label2(4))^2 <= max(Dglobal_label2) && isempty(intersect(train_data,temp,'rows')))
            corr_train_data2 = [corr_train_data2; temp];
            corr_train_label2 = [corr_train_label2; 'Versicolor'];
            i = i + 1;
        end
    end

    % For label 3
    temp = [];
    i = 0;
    while (i~=To_add_label3)
            a = rand*(Feature1_max_label3-Feature1_min_label3)+Feature1_min_label3;
        a_int = floor(a);
        a_mantissa = round(10*(a-a_int))/10;

        b = rand*(Feature2_max_label3-Feature2_min_label3)+Feature2_min_label3;
        b_int = floor(b);
        b_mantissa = round(10*(b-b_int))/10;

        c = rand*(Feature3_max_label3-Feature3_min_label3)+Feature3_min_label3;
        c_int = floor(c);
        c_mantissa = round(10*(c-c_int))/10;

        d = rand*(Feature4_max_label3-Feature4_min_label3)+Feature4_min_label3;
        d_int = floor(d);
        d_mantissa = round(10*(d-d_int))/10;

        temp = [(a_int+a_mantissa) (b_int+b_mantissa) (c_int+c_mantissa) (d_int+d_mantissa)];
        if ((temp(1)-Cglobal_label3(1))^2 +(temp(2)-Cglobal_label3(2))^2 + (temp(3)-Cglobal_label3(3))^2 + (temp(4)-Cglobal_label3(4))^2 <= max(Dglobal_label3) && isempty(intersect(train_data,temp,'rows')))
            corr_train_data3 = [corr_train_data3; temp];
            corr_train_label3 = [corr_train_label3; 'Virginica'];
            i = i + 1;
        end
    end

    %% Redundancy Minimization: Eliminate 50% of the closest samples

    % Distance from centroid for all point in the augmented dataset
    for label = 1:length(unique(train_label))
        eval(['[idx C sumd D_label' num2str(label) '] = kmeans(corr_train_data' num2str(label) '(:,:),1);'])
        eval(['[Dsorted_label' num2str(label) ' indexDsorted_label' num2str(label) '] = sort(D_label' num2str(label) ');'])
    end

    % Remove half the points from each label that have close resemblance
    for label = 1:length(unique(train_label))
        eval(['clusterIndices_label' num2str(label) ' = kmeans(Dsorted_label' num2str(label) ',round(size(Dsorted_label' num2str(label) ',1)/2));']) %number of clusters = number of inputs to retain
        eval(['toRetain_label' num2str(label) ' = [];'])
        for i = 1:eval(['ceil(size(Dsorted_label' num2str(label) ',1)/2)'])
            eval(['toRetain_label' num2str(label) ' = [toRetain_label' num2str(label) '; round(median(find(clusterIndices_label' num2str(label) '==i,1)))];'])
        end
    end

    corr_train_data_new = [corr_train_data1(toRetain_label1,:); corr_train_data2(toRetain_label2,:); corr_train_data3(toRetain_label3,:)];
    corr_train_label_new = [corr_train_label1(toRetain_label1); corr_train_label2(toRetain_label2); corr_train_label3(toRetain_label3)];

    disp('Size of Diversified daaset: ') 
    disp(size(corr_train_data_new,1))

    %% Dataset Validation

    corr_label1_new = corrcoef(corr_train_data1);
    corr_label2_new = corrcoef(corr_train_data2);
    corr_label3_new = corrcoef(corr_train_data3);

    per_diff_label1 = abs(corr_label1 - corr_label1_new)./abs(corr_label1);
    per_diff_label2 = abs(corr_label2 - corr_label2_new)./abs(corr_label2);
    per_diff_label3 = abs(corr_label3 - corr_label3_new)./abs(corr_label3);
    comp1 = size(corr_train_data1,2)*size(corr_train_data1,2);
    comp2 = size(corr_train_data2,2)*size(corr_train_data2,2);
    comp3 = size(corr_train_data3,2)*size(corr_train_data3,2);

    % If validation is successful --> Generate CSV for new trainind dataset

    threshold = 0.8;
    if sum((per_diff_label1 < threshold),'all')==(comp1) && sum((per_diff_label2 < threshold),'all')==(comp2) && sum((per_diff_label3 < threshold),'all')==(comp3)
        corr_train_data_new_table = array2table(corr_train_data_new);
        corr_train_data_new_table.Properties.VariableNames = {'sepallength', 'sepalwidth', 'petallength', 'petalwidth'};
        corr_train_label_new_table = array2table(corr_train_label_new);
        corr_train_label_new_table.Properties.VariableNames = {'variety'};

        corr_train_new = cat(2,corr_train_data_new_table,corr_train_label_new_table);
        writetable(corr_train_new,'Datasets/iris_train_diversified.csv')
        condition = false;

    else
        disp('Oppsss... New data changes feature correlations significantly...')
        disp('Try running the script again.')
        condition = true;
    end
end
