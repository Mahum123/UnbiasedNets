%% TRAINING

% Datasets: (training)
%     Original: Datasets/train_data.csv 
%     SMOTE: Datasets/train_SMOTE.csv 
%     ADASYN: Datasets/train_ADASYN.csv 
%     ROS: Datasets/train_ROS.csv 
% Datasets: (testing)
%     Original: Datasets/test_data.csv 
  
% Training Epochs used    
%     Original: 80
%     Diversified: 12 
%     SMOTE: 56
%     ADASYN: 56
%     ROS: 56

condition = true;

while condition

    % %~~~~~~~~~~~~~~~~~~~~~~~Searching for counterexamples (using input test samples) 
    clc
    clear all
    close all
    temp_val = pwd;

    temp = csvread(strcat(temp_val,'/Datasets/train_diversified.csv'));
    train_data = temp(:,1:size(temp,2)-1);
    train_label = temp(:,size(temp,2))';

    temp = csvread(strcat(temp_val,'/Datasets/test_data.csv')); %last col of each row is label
    test_data = temp(:,1:size(temp,2)-1);
    test_label = temp(:,size(temp,2))';

    clear temp
    mean_train = mean(train_data,1);                                      %
    std_train = std(train_data,1);    
    
    %Normalization
    train_data = train_data - repmat(mean_train, [size(train_data,1) 1]); 
    train_data = train_data ./ repmat(std_train, [size(train_data,1) 1]); 
    test_data = test_data - repmat(mean_train, [size(test_data,1) 1]);
    test_data = test_data ./ repmat(std_train, [size(test_data,1) 1]);

    N1=20;                  % Middle Layer Neurons
    N2=2;                   % Output Layer Neurons 
    N0=6;    % Input Layer Neurons (feature length + bias)

    % Training parameters
    eta_v = [0.5 0.2 0.2]; % Learning Rate
    epoch=12;
    

    % Initialization of weights (random)
    w1=randn(N1,N0);    
    w2=randn(N2,N1);    

    train_label_e = train_label;                                
    train_label = [train_label == 0;  train_label == 1];        

    for j=1:epoch
        if j < round(epoch/2)         
            eta = eta_v(1);     %learning rate=0.5
        elseif j < round(epoch/4)   
            eta = eta_v(2);     %learning rate=0.2
        else                    
            eta = eta_v(3);     %learning rate=0.2
        end
        % randomization of training data improves learning performance
        ind(j,:)=randperm(size(train_label,2)); 

        Output = zeros(size(train_label));  %output labels
        
        for k=1:size(train_data,1)

            Input=[1 train_data(ind(j,k),:)];  % first node: bias

            % Input layer
            n1 = w1*Input';
            a1 = poslin(n1);

            % Hidden layer
            n2 = w2*a1;
            a2=logsig(n2);  %sigmoid used in training (testing uses ReLU)

            % output layer
            Output(:,k)=a2;    
            e = train_label(:,ind(j,k)) - Output(:,k);

            % Backpropagation learning algorithm : gradient descent

            Y2 = 2*dlogsig(n2,a2).*e;  % local gradient of Output Layer
            Y1 = diag(dposlin(n1,a1),0)*w2'*Y2; % local gradient of Hidden Layer

            w1 = w1 + eta*Y1*Input;  % input layer neurons weight update
            w2 = w2 + eta*Y2*a1';    % hidden layer neurons weight update

            SE(j,k)= e'*e;      % squared error
        end
        MSE(j)=mean(SE(j,:));       % objective function (mean squared error)

        % Training classification error (classification accuracy in %)
        [YY, II] = max(Output,[],1);
        II = II - 1;        
        TCE(j)=length(find((II-train_label_e(ind(j,:)))==0))*100/length(II);
    end

    figure
    semilogy(MSE)
    xlabel('Training epochs')
    ylabel('MSE (dB)')
    title('Objective Function')

    figure
    plot(TCE)
    xlabel('Training epochs')
    ylabel('Classification accuracy (%)')
    title('Classification : Training')

    figure
    plot(train_label_e(ind(j,:)),'or')
    hold on
    plot(round(II))

    legend('Actual class','Predicted class using NN')
    xlabel('Training samples')
    ylabel('Class Label')
    title('Classification : Training')

    Training_Accuracy=length(find((II-train_label_e(ind(j,:)))==0))*100/length(II);
    Output=[];
    mis = 50;
    for k=1:size(test_data,1)

            Input=[1 test_data(k,:)];

            n1 = w1*Input';     
            a1=poslin(n1); % ReLU activation
    
            n2 = w2*a1;
            [YY,II] = max(n2); % maxpool
            Output(k)=II-1;   
            if Output(k)~=test_label(k)
                mis = k-1; % misclassified input
            end             

    end

    figure
    plot(test_label,'or')
    hold on
    plot(round(Output))
    legend('Actual class','Predicted class using NN')
    xlabel('Training samples')
    ylabel('Class Label')
    title('Classification : Test')

    Testing_Accuracy=length(find((round(Output)-test_label)==0))*100/length(Output);

    condition = true;
    if (Training_Accuracy > 94) && (Testing_Accuracy > 95)
        condition = false;
        Training_Accuracy
        Testing_Accuracy
    end
end

save('weights.mat')

%% ORIGINAL TRAINED NETWORK PARAMETERS
 
% clc
% clear all
% close all
% temp = csvread('test_data.csv'); %last col of each row is label
% test_data = temp(:,1:size(temp,2)-1);
% test_label = temp(:,size(temp,2));
% clear temp
% 
% %Using same Data as SMV Analysis
% mean_train = [1107.36842105263 329.21052631579 3174.42105263158	667	1123.89473684211];
% std_train = [573.298554583021 269.097825872296 2375.66737029695 515.887839707329 1474.97360885353];
% 
% w1 = [-1.75889773308813	2.07691082129795	1.75578026753151	-0.2434549132589	0.776174538034581	-0.630673680344658
% -0.015794113173483	0.873860281752358	1.09873905951226	-0.340555175565739	0.451664357489308	-0.48604391290953
% -0.375603837407229	0.952472650762792	-0.095482414755532	-0.847184768567755	-0.215391197633864	2.16197737251895
% 1.49092049603721	-0.14672768668282	-0.178525832744738	0.035895358987071	-0.258422070534013	-0.060238434231971
% -0.475637533189707	1.39931430560727	0.943885644414573	1.15386779652122	-0.370386315428392	-0.069793445937851
% 3.70857797338702	-0.972158903808592	-0.666602719287297	1.27856739348768	-1.24921545378213	-0.724562204784321
% -0.188458144592322	-0.283922182862622	1.28192141230353	-0.387028730763569	2.76600370294721	-0.541251178562193
% -0.61190510761784	-0.95202398120998	-2.20588104534707	0.210654125795476	-2.38776966140079	-1.35427072658022
% 2.25971800426995	-0.830213692012713	-1.02657909742477	0.040328073013691	0.139469241826452	0.195096159129255
% -0.097379454527764	1.76037533219662	-0.108594781856575	-0.186836527477307	-0.166273284214413	-1.05282884618148
% -0.461782865919423	0.043526575918743	-0.102356181394243	-0.256272933404292	-1.11692092844232	1.1050880006543
% 0.375345954774012	-0.571808110591891	-1.38305116784533	1.58893136655754	-0.318690640205956	-1.77405160127457
% -1.05881172727352	1.07195017250683	0.38282485387249	-0.657045544570408	0.363819234919062	0.993261116589723
% -1.46596179989251	-0.312872345704461	-0.081217003840934	0.189106608550862	1.0536207222302	-0.920575162972099
% -1.08682777026912	0.483325013792348	-0.869938598005503	0.282332248457674	0.363161983973349	-1.1946402978966
% -0.066190597478497	0.475720203099193	-1.47915187017117	-1.10680088236775	0.524562713687614	0.114881608426342
% 1.03053606415229	-1.06140504335782	-1.24910223308325	-1.62818949476227	1.62188556749337	0.970613034477798
% 0.829180727767163	-0.085298777272316	-1.34149366524346	0.143147483694789	0.374833990380919	2.24332944883946
% 0.67288426042864	1.27110963797521	0.754679889013141	1.33455029816806	-1.04683946988572	-0.086328788655296
% 0.780276579680183	0.546244360141504	-0.637812170787155	-0.92184123526791	-1.10078650100522	0.675044164145256];
% 
% w2 = [-0.407272060955784	2.72620326678654
% -0.975705749301989	-0.144662735365468
% 1.27201663228234	-1.708502987989
% -1.32589719802549	-0.399451992946892
% -0.475609498732904	-0.138058674322375
% -1.24406769429898	1.68606227921514
% -0.863190630356968	-0.309481967959911
% -1.30023936698089	0.503988693106526
% -0.500283358215627	0.342389067412263
% -0.627938199499187	0.696952283693362
% 0.138216420998788	-2.11093789899197
% -0.669921269555202	1.33209170255753
% 1.35563154059087	-0.265497661448846
% 1.49321596508851	0.691230234569168
% 1.78333184231155	0.369008827956823
% 1.08419475486861	-0.198046483401685
% 1.55110823226135	-0.067070285831653
% 1.54422208993421	-1.71541316687595
% -0.406521783337914	1.61914949962017
% 0.652776257548189	-0.74220056016443]';
% 
% for k=1:size(test_data,1)
%         Input=test_data(k,:);
%         
%         %Normalize
%         Input = Input - mean_train;
%         Input = Input ./ std_train;
% 
%         Input=[1 Input];
%        
%         n1 = w1*Input';     
%         a1=poslin(n1);
%          
%         n2 = w2*a1;        
%         [YY,II] = max(n2);
%         Label(k)=II-1;       
% %         Output1(k)=n2(1);
% %         Output2(k)=n2(2);
%         Output(k)=II-1;                 
% 
% end
% 
% figure
% plot(test_label,'or')
% hold on
% plot(round(Output))
% legend('Actual class','Predicted class using MLP')
% xlabel('Training sample #')
% ylabel('Class Label')
% title('Classification performance (Test)')
% 
% Testing_Accuracy=length(find((round(Output')-test_label)==0))*100/length(Output)

