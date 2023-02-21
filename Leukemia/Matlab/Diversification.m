% THIS SCRIPT GENERATES A DIVERSIFIED TRAINING DATASET, USING THE ORIGINAL DATASET

% TRAINING DATASET FOR LEUKEMIA
%   - 38 inputs (27 and 11 for each labels, respectively)
%   - noise tolerance of original network: 11%

%% Run entire file until new dataset is obtained

condition = true;

while condition

    %%
    clc
    clear all
    close all

    %% Load original dataset

    temp = csvread('Datasets/train_data.csv'); %last col of each row is label
    train_data = temp(:,1:size(temp,2)-1);
    train_label = temp(:,size(temp,2));

    clear temp

    %% Number of total and misclassfied inputs from each class --> from counterexample analysis of original network

    mis_label0 = 14013;
    total_label0 = 76803;
    mis_label1 = 44;
    total_label1 = 112253;

    %% Split the inputs according to their labels

    %Initilize
    corr_train_data0 = [];
    corr_train_label0 = [];
    corr_train_data1 = [];
    corr_train_label1 = [];
    totalLabels = 2;
    for i = 1:size(train_data,1)

        if train_label(i)==0
           corr_train_data0 = [corr_train_data0 ; train_data(i,:)];
           corr_train_label0 = [corr_train_label0 ; train_label(i)];
        else
           corr_train_data1 = [corr_train_data1 ; train_data(i,:)];
           corr_train_label1 = [corr_train_label1 ; train_label(i)];
        end

    end

    %% Feature Correlation for each class in training dataset

    corr_coef_label0 = corrcoef(corr_train_data0);
    corr_coef_label1 = corrcoef(corr_train_data1);

    %% Bound Determination: using noise tolerance (x) and feature extremum

    x = 0.11; %tolerance

    % For each Feature of every Label
    for label = 1:size(unique(train_label),1)
        for feature = 1:size(train_data,2)

           a = (1-x)*min(eval(['corr_train_data' num2str(label-1) '(:,' num2str(feature) ')']));
           b = (1+x)*min(eval(['corr_train_data' num2str(label-1) '(:,' num2str(feature) ')']));
           c = (1-x)*max(eval(['corr_train_data' num2str(label-1) '(:,' num2str(feature) ')']));
           d = (1+x)*max(eval(['corr_train_data' num2str(label-1) '(:,' num2str(feature) ')']));
            eval(['Global_Feature' num2str(feature) '_min_label' num2str(label-1) ' = min(min(min(a,b),c),d);'])
            eval(['Global_Feature' num2str(feature) '_max_label' num2str(label-1) ' = max(max(max(a,b),c),d);'])

        end
    end

    %% Bound Tightening: in case of overlaps

    for feature = 1:size(corr_train_data0,2)
        P = true; %in case there is problem in bound calculation, rerun loop

        while P
            P = false;
            % Check  ranges for feature, for each label
            a = eval(['Global_Feature' num2str(feature) '_max_label0 - Global_Feature' num2str(feature) '_min_label0']);
            b = eval(['Global_Feature' num2str(feature) '_max_label1 - Global_Feature' num2str(feature) '_min_label1']);
            [d ID] = sort([a b]);     %to decide which label to deal with first

            % To eliminate the overlap already dealt with
            for i = 1:nchoosek(totalLabels,2)
                eval(['flag' num2str(i) '= true;'])
            end

            for i = 1:totalLabels
                if d(i) ~= 0
                    n = num2str(ID(i)-1);
                    m = 'and';
                    for j = i+1:totalLabels
                        m = num2str(ID(j)-1);

                        combos = nchoosek(1:totalLabels,2); %the different combonations of n labels
                        temp_string = strcat('Labels ', num2str(combos(i,1)),' and ', num2str(combos(i,2)));

                        for k = 1:size(combos,1)
                            if contains(temp_string, n) && contains(temp_string, m) && eval(['flag' num2str(k)])   %check overlap in Labels n and m
                            %-------------------------------------------------------------------------

                                if eval(['~((Global_Feature' num2str(feature) '_min_label' num2str(n) ' >= Global_Feature' num2str(feature) '_max_label' num2str(m) ') || (Global_Feature' num2str(feature) '_min_label' num2str(m) ' >= Global_Feature' num2str(feature) '_max_label' num2str(n) '))']) %if there is overlap

                                %Partial Overlap
                                if eval(['((Global_Feature' num2str(feature) '_min_label' num2str(n) ' >= Global_Feature' num2str(feature) '_min_label' num2str(m) ') && (Global_Feature' num2str(feature) '_min_label' num2str(n) ' <= Global_Feature' num2str(feature) '_max_label' num2str(m) '))'])
                                    eval(['Global_Feature' num2str(feature) '_min_label' num2str(n) ' = Global_Feature' num2str(feature) '_max_label' num2str(m) ';'])
                                    eval(['Global_Feature' num2str(feature) '_max_label' num2str(m) ' = Global_Feature' num2str(feature) '_min_label' num2str(n) ';'])
                                end
                                if eval(['((Global_Feature' num2str(feature) '_max_label' num2str(n) ' >= Global_Feature' num2str(feature) '_min_label' num2str(m) ') && (Global_Feature' num2str(feature) '_max_label' num2str(n) ' <= Global_Feature' num2str(feature) '_max_label' num2str(m) '))'])
                                    eval(['Global_Feature' num2str(feature) '_max_label' num2str(n) ' = Global_Feature' num2str(feature) '_min_label' num2str(m) ';'])
                                    eval(['Global_Feature' num2str(feature) '_min_label' num2str(m) ' = Global_Feature' num2str(feature) '_max_label' num2str(n) ';'])
                                end

                                %Complete overlap
                                if eval(['((Global_Feature' num2str(feature) '_min_label' num2str(n) ' >= Global_Feature' num2str(feature) '_min_label' num2str(m) ') && (Global_Feature' num2str(feature) '_max_label' num2str(m) ' >= Global_Feature' num2str(feature) '_max_label' num2str(n) '))'])
                                    a = eval(['Global_Feature' num2str(feature) '_min_label' num2str(n) ' - Global_Feature' num2str(feature) '_min_label' num2str(m)]);
                                    b = eval(['Global_Feature' num2str(feature) '_max_label' num2str(m) ' - Global_Feature' num2str(feature) '_max_label' num2str(n)]);
                                    if a > b
                                        eval(['Global_Feature' num2str(feature) '_max_label' num2str(m) ' = Global_Feature' num2str(feature) '_min_label' num2str(n) ';'])
                                    else
                                        eval(['Global_Feature' num2str(feature) '_min_label' num2str(m) ' = Global_Feature' num2str(feature) '_max_label' num2str(n) ';'])
                                    end
                                end
                                if eval(['((Global_Feature' num2str(feature) '_min_label' num2str(m) ' >= Global_Feature' num2str(feature) '_min_label' num2str(n) ') && (Global_Feature' num2str(feature) '_max_label' num2str(n) ' >= Global_Feature' num2str(feature) '_max_label' num2str(m) '))'])
                                    a = eval(['Global_Feature' num2str(feature) '_min_label' num2str(m) ' - Global_Feature' num2str(feature) '_min_label' num2str(n)]);
                                    b = eval(['Global_Feature' num2str(feature) '_max_label' num2str(n) ' - Global_Feature' num2str(feature) '_max_label' num2str(m)]);
                                    if a > b
                                        eval(['Global_Feature' num2str(feature) '_max_label' num2str(n) ' = Global_Feature' num2str(feature) '_min_label' num2str(m) ';'])
                                    else
                                        eval(['Global_Feature' num2str(feature) '_min_label' num2str(n) ' = Global_Feature' num2str(feature) '_max_label' num2str(m) ';'])
                                    end
                                end
                            end
                            eval(['flag' num2str(k) ' = false;'])
                            end
                        end
                    end
                end
            end
        end
    end

    %% Check distance from centroid for each Input Feature: using k-means

    for label = 1:length(unique(train_label))
        eval(['[idx Cglobal_label' num2str(label-1) ' sumd_label' num2str(label-1) ' Dglobal_label' num2str(label-1) '] = kmeans(corr_train_data'  num2str(label-1) '(:,:),1);'])
    end

    for feature = 1:size(train_data,2)
        for label = 1:length(unique(train_label))
            eval(['[idx C sumd_label' num2str(label-1) ' D' num2str(feature) '_label' num2str(label-1) '] = kmeans(corr_train_data' num2str(label-1) '(:,' num2str(feature) '),1);'])
        end
    end

    %% Identify top-k most representative features

    topk = 2; %top-2 features considered
    for label = 1:length(unique(train_label))
        eval(['D_label' num2str(label-1) ' = [];'])
        for feature = 1:size(train_data,2)
            eval(['D_label' num2str(label-1) ' = [D_label' num2str(label-1) ' ; D' num2str(feature) '_label' num2str(label-1) '];'])
        end
            eval(['[Dsorted_label' num2str(label-1) ' indexDsorted_label' num2str(label-1) '] = sort(D_label' num2str(label-1) ');'])
    end

    % Identify the top-k features and inputs
    for label = 1:length(unique(train_label))

        %top1: features closest to the cluster centroid
        for top = 1:topk
            eval(['top' num2str(top) '_label' num2str(label-1) ' = 0;'])  
            eval(['input_top' num2str(top) '_label' num2str(label-1) ' = 0;'])
        end

        temp = eval(['find(Dsorted_label' num2str(label-1) '~=0, 1,''first'')']);
        while (eval(['top1_label' num2str(label-1) '==0']) || eval(['top2_label' num2str(label-1) '==0']) )
            for feature = 1:size(train_data,2)

                %Range of this loop is updated as per the number of top-k features used
                for top = 1:topk
                    if (eval(['indexDsorted_label' num2str(label-1) '(temp)']) > eval([num2str(feature-1) '*size(corr_train_data' num2str(label-1) ',1)']) && eval(['indexDsorted_label' num2str(label-1) '(temp)']) <= eval([num2str(feature) '*size(corr_train_data' num2str(label-1) ',1)']))

                        if (eval(['top' num2str(top) '_label' num2str(label-1) '==0']))
                            eval(['top' num2str(top) '_label' num2str(label-1) '=' num2str(feature) ';'])
                            if (eval(['size(find(abs(D' num2str(feature) '_label' num2str(label-1) '-Dsorted_label' num2str(label-1) '(temp))<1e-5),1)==0'])) 
                                eval(['input_top' num2str(top) '_label' num2str(label-1) ' = find((D' num2str(feature) '_label' num2str(label-1) '-Dsorted_label' num2str(label-1) '(temp)) < 1.02*min(abs(D' num2str(feature) '_label' num2str(label-1) '-Dsorted_label' num2str(label-1) '(temp))));'])
                                %if the distances are not less than 1e-5, consider inputs within 2% of the minimial distance
                            else
                                eval(['input_top' num2str(top) '_label' num2str(label-1) ' = find(abs(D' num2str(feature) '_label' num2str(label-1) '-Dsorted_label' num2str(label-1) '(temp))<1e-5);'])
                            end
                            temp = temp + 1;
                        elseif (eval(['top' num2str(top) '_label' num2str(label-1) '==1']))
                            temp = temp + 1;
                        end
                    end
                end
            end
        end
    end

    %% Identify radius of 25% of top1 and 50% of top2 feature

    for label = 1:length(unique(train_label))
        x = 0.25;
        for top = 1:topk
            eval(['Num_inputs_for_radius_top' num2str(top) '_label' num2str(label-1) ' = ceil(' num2str(x) '*size(corr_train_data' num2str(label-1) ',1));'])

            for feature = 1:size(train_data,2)
                if (eval(['top' num2str(top) '_label' num2str(label-1) '==' num2str(feature)]))
                    eval(['[Dsorted_label' num2str(label-1) ' idx] = sort(D' num2str(feature) '_label' num2str(label-1) ');'])
                end
            end

            eval(['Radius_top' num2str(top) '_label' num2str(label-1) ' = abs(corr_train_data' num2str(label-1) '(idx(1),top' num2str(top) '_label' num2str(label-1) ') - corr_train_data' num2str(label-1) '(idx(Num_inputs_for_radius_top' num2str(top) '_label' num2str(label-1) '),top' num2str(top) '_label' num2str(label-1) '));'])
            %Difference in the min and max values of x% topk features from the feature centroid
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
                if (eval(['top' num2str(top) '_label' num2str(label-1) '==' num2str(feature)]) && eval(['flag' num2str(feature)]))
                    eval(['Feature' num2str(feature) '_min_label' num2str(label-1) ' = unique(max(corr_train_data' num2str(label-1) '(input_top' num2str(top) '_label' num2str(label-1) ',top' num2str(top) '_label' num2str(label-1) ')-Radius_top' num2str(top) '_label' num2str(label-1) ', Global_Feature' num2str(feature) '_min_label' num2str(label-1) '));'])
                    eval(['Feature' num2str(feature) '_max_label' num2str(label-1) ' = unique(min(corr_train_data' num2str(label-1) '(input_top' num2str(top) '_label' num2str(label-1) ',top' num2str(top) '_label' num2str(label-1) ')+Radius_top' num2str(top) '_label' num2str(label-1) ', Global_Feature' num2str(feature) '_max_label' num2str(label-1) '));'])
                    eval(['flag' num2str(feature) ' = false;'])
                elseif (eval(['top' num2str(top) '_label' num2str(label-1) '~=' num2str(feature)]) && eval(['flag' num2str(feature)]))
                    eval(['Feature' num2str(feature) '_min_label' num2str(label-1) ' = Global_Feature' num2str(feature) '_min_label' num2str(label-1) ';'])
                    eval(['Feature' num2str(feature) '_max_label' num2str(label-1) ' = Global_Feature' num2str(feature) '_max_label' num2str(label-1) ';'])
                end
            end
        end

    end

    %% Synthetic Input Generation
  
    for label = 1:length(unique(train_label))
    %     eval(['corr_train_data' num2str(label-1) '_new = [];'])
    %     eval(['corr_train_label' num2str(label-1) '_new = [];'])
        eval(['To_add_label' num2str(label-1) ' =  round( (mis_label' num2str(label-1) '/total_label' num2str(label-1) ') / min(mis_label0/total_label0, mis_label1/total_label1) );'])
    end

    for label = 1:length(unique(train_label))

        i = 0;
        while (eval(['i~=To_add_label' num2str(label-1)]))
            temp = [];
            x = 0; %Euclidean distance of the new input "temp"

            for feature = 1:size(train_data,2)
                a = eval(['rand*(Feature' num2str(feature) '_max_label' num2str(label-1) '-Feature' num2str(feature) '_min_label' num2str(label-1) ')+Feature' num2str(feature) '_min_label' num2str(label-1)]);
                a_int = round(a);
                temp = [temp a_int];
                x = x + (a_int-Cglobal_label1(feature))^2;
            end

            eval(['y = max(Dglobal_label' num2str(label-1) ');'])

            if (x <= y && isempty(intersect(train_data,temp,'rows')))
                eval(['corr_train_data' num2str(label-1) ' = [corr_train_data' num2str(label-1) '; temp];'])
                eval(['corr_train_label' num2str(label-1) ' = [corr_train_label' num2str(label-1) '; ' num2str(label-1) '];'])
                i = i + 1;
            end
        end

    end

    %% Redundancy Minimization: Eliminate 50% of the closest samples

    % Distance from centroid for all point in the augmented dataset
    for label = 1:length(unique(train_label))
        eval(['[idx C sumd D_label' num2str(label-1) '] = kmeans(corr_train_data' num2str(label-1) '(:,:),1);'])
        eval(['[Dsorted_label' num2str(label-1) ' indexDsorted_label' num2str(label-1) '] = sort(D_label' num2str(label-1) ');'])
    end

    for label = 1:length(unique(train_label))
        eval(['clusterIndices_label' num2str(label-1) ' = kmeans(Dsorted_label' num2str(label-1) ',round(size(Dsorted_label' num2str(label-1) ',1)/2));'])
        eval(['toRetain_label' num2str(label-1) ' = [];'])
        for i = 1:eval(['ceil(size(Dsorted_label' num2str(label-1) ',1)*(0.5))'])
            eval(['toRetain_label' num2str(label-1) ' = [toRetain_label' num2str(label-1) '; round(median(find(clusterIndices_label' num2str(label-1) '==i,1)))];'])
        end
    end

    corr_train_data_new = [];
    corr_train_label_new = [];
    for label = 1:length(unique(train_label))
        corr_train_data_new = eval(['[corr_train_data_new; corr_train_data' num2str(label-1) '(toRetain_label' num2str(label-1) ',:)]']);
        corr_train_label_new = eval(['[corr_train_label_new; corr_train_label' num2str(label-1) '(toRetain_label' num2str(label-1) ',:)]']);
    end

    disp('Size of Diversified daaset: ') 
    disp(size(corr_train_data_new,1))

    %% Dataset Validation

    for label = 1:length(unique(train_label))
        eval(['corr_coef_label' num2str(label-1) '_new = corrcoef(corr_train_data' num2str(label-1) ');'])
        eval(['per_diff_label' num2str(label-1) ' = abs(abs(corr_coef_label' num2str(label-1) ') - abs(corr_coef_label' num2str(label-1) '_new))./abs(corr_coef_label' num2str(label-1) ');'])
        eval(['comp' num2str(label-1) ' = size(corr_train_data' num2str(label-1) ',2)*size(corr_train_data' num2str(label-1) ',2);'])
    end

    % If validation is successful --> Generate CSV for new trainind dataset
    
    threshold = 0.85;
    condition = true;
    for label = 1:length(unique(train_label))
        condition = eval(['condition && sum((per_diff_label' num2str(label-1) ' < threshold),''all'')==(comp' num2str(label-1) ')']);
    end

    if condition
        csvwrite('Datasets/train_diversified.csv',cat(2,corr_train_data_new,corr_train_label_new))
        condition = false;
    else
        disp('Oppsss... New data changes feature correlations significantly...')
        disp('Try running the script again.')
        condition = true;
    end
end
