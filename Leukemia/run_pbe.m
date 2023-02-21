%% 
% Reading Noisexxx.csv generated during Counterexample analysis

clc
clear all
close all

Noise = readtable('Noise.csv'); %THIS NEEDS TO BE UPDATED
Index_zeros = find(Noise.Var1==0 & Noise.Var2==0 & Noise.Var3==0 & Noise.Var4==0 & Noise.Var5==0);

% Obtain Noise vectors from the table using indexes of vectors
Noise_1 = table2array(Noise(1:Index_zeros(1)-1,1:5));
Noise_2 = table2array(Noise(Index_zeros(1)+1:Index_zeros(2)-1,1:5));
Noise_3 = table2array(Noise(Index_zeros(2)+1:Index_zeros(3)-1,1:5));
Noise_4 = table2array(Noise(Index_zeros(3)+1:Index_zeros(4)-1,1:5));
Noise_5 = table2array(Noise(Index_zeros(4)+1:Index_zeros(5)-1,1:5));
Noise_6 = table2array(Noise(Index_zeros(5)+1:Index_zeros(6)-1,1:5));
Noise_7 = table2array(Noise(Index_zeros(6)+1:Index_zeros(7)-1,1:5));
Noise_8 = table2array(Noise(Index_zeros(7)+1:Index_zeros(8)-1,1:5));
Noise_9 = table2array(Noise(Index_zeros(8)+1:Index_zeros(9)-1,1:5));
Noise_10 = table2array(Noise(Index_zeros(9)+1:Index_zeros(10)-1,1:5));
Noise_11 = table2array(Noise(Index_zeros(10)+1:Index_zeros(11)-1,1:5));
Noise_12 = table2array(Noise(Index_zeros(11)+1:Index_zeros(12)-1,1:5));
Noise_13 = table2array(Noise(Index_zeros(12)+1:Index_zeros(13)-1,1:5));
Noise_14 = table2array(Noise(Index_zeros(13)+1:Index_zeros(14)-1,1:5));
Noise_15 = table2array(Noise(Index_zeros(14)+1:Index_zeros(15)-1,1:5));
Noise_16 = table2array(Noise(Index_zeros(15)+1:Index_zeros(16)-1,1:5));
Noise_17 = table2array(Noise(Index_zeros(16)+1:Index_zeros(17)-1,1:5));
Noise_18 = table2array(Noise(Index_zeros(17)+1:Index_zeros(18)-1,1:5));
Noise_19 = table2array(Noise(Index_zeros(18)+1:Index_zeros(19)-1,1:5));
Noise_20 = table2array(Noise(Index_zeros(19)+1:Index_zeros(20)-1,1:5));
Noise_21 = table2array(Noise(Index_zeros(20)+1:Index_zeros(21)-1,1:5));
Noise_22 = table2array(Noise(Index_zeros(21)+1:Index_zeros(22)-1,1:5));
Noise_23 = table2array(Noise(Index_zeros(22)+1:Index_zeros(23)-1,1:5));
Noise_24 = table2array(Noise(Index_zeros(23)+1:Index_zeros(24)-1,1:5));
Noise_25 = table2array(Noise(Index_zeros(24)+1:Index_zeros(25)-1,1:5));
Noise_26 = table2array(Noise(Index_zeros(25)+1:Index_zeros(26)-1,1:5));
Noise_27 = table2array(Noise(Index_zeros(26)+1:Index_zeros(27)-1,1:5));
Noise_28 = table2array(Noise(Index_zeros(27)+1:Index_zeros(28)-1,1:5));
Noise_29 = table2array(Noise(Index_zeros(28)+1:Index_zeros(29)-1,1:5));
Noise_30 = table2array(Noise(Index_zeros(29)+1:Index_zeros(30)-1,1:5));
Noise_31 = table2array(Noise(Index_zeros(30)+1:Index_zeros(31)-1,1:5));
Noise_32 = table2array(Noise(Index_zeros(31)+1:Index_zeros(32)-1,1:5));
Noise_33 = table2array(Noise(Index_zeros(32)+1:Index_zeros(33)-1,1:5));
Noise_34 = table2array(Noise(Index_zeros(33)+1:Index_zeros(34)-1,1:5));
Noise_35 = table2array(Noise(Index_zeros(34)+1:Index_zeros(35)-1,1:5));
Noise_36 = table2array(Noise(Index_zeros(35)+1:Index_zeros(36)-1,1:5));
Noise_37 = table2array(Noise(Index_zeros(36)+1:Index_zeros(37)-1,1:5));
Noise_38 = table2array(Noise(Index_zeros(37)+1:Index_zeros(38)-1,1:5));
Noise_39 = table2array(Noise(Index_zeros(38)+1:Index_zeros(39)-1,1:5));
Noise_40 = table2array(Noise(Index_zeros(39)+1:size(Noise,1),1:5));

% %% PARAMETERS FOR ORIGINAL MODEL
% 
 temp = csvread('Matlab/Datasets/test_data.csv'); %last col of each row is label
 test_data = temp(:,1:size(temp,2)-1);
 test_label = temp(:,size(temp,2));
 clear temp
% 
mean_train = [
1107.3684210526317 329.2105263157895 3174.4210526315787 667.0 1123.8947368421052 
];
%
std_train = [
573.2985545830206 269.09782587229626 2375.6673702969506 515.8878397073289 1474.9736088535294 
];
w1 = [
1.1440969971075317 -1.161744127308377 -0.17683517931920792 1.6434382473328828 0.6860070480199641 -0.37925911521815636 
-1.1029135167627049 0.682603998189528 -0.7468465890524274 -0.7787343124346763 -1.6419463877758174 0.6086519396026848 
-0.8002170906569461 -2.712857573912103 -0.0752491537495218 -0.8907323077274915 -0.17319607772843476 0.18277803013018457 
1.6436524762173963 0.7761751604257409 -1.8931705491903186 0.24007559980398088 0.7380199116883577 1.1114274363010614 
0.523025277336652 0.39165072086075703 -0.605563382866574 0.8118045552117864 -1.3048792902962814 1.1078247439650226 
-0.5896072314156907 0.7433795103940051 -0.7351127481634493 -0.9536742539867938 -1.244463159792519 0.5900021290884255 
-0.055525521122087564 0.35967256987135005 -0.11937514320068104 -0.05066965363619145 0.6045113560003813 0.2297318719380864 
-0.3203331186041865 0.6943686736245173 0.6982860553499906 1.9878436049155703 -0.7431253015773597 1.3606554534548863 
-0.08384699941026129 -0.9177181361121559 0.12124296295524255 0.5452799341561301 1.943696669417569 0.6708493002864268 
0.6316296021092358 0.2750414463276646 -0.0017132069755276382 -0.8215134538714225 -0.6815983506216237 -1.3290214156717695 
-0.5118074587882157 -0.30350268364312827 -0.15453994710260932 -1.8367960296689168 1.263419898414523 1.3527086903060705 
0.5100007765436113 -0.8172113828061758 -0.7689367918258313 1.474044722063581 1.246328121162752 0.5069728674811547 
0.04263497262320575 0.12999493458723413 -0.6114720940542818 -0.09538850957322619 -0.07348926159913673 -1.0364203770074698 
-1.122760437995141 0.31313346016992394 0.8625724649642824 0.5587280857131658 -0.6123004941059921 -2.0031178999665733 
1.3137084530339462 2.458423342860918 -0.8460781904454692 0.5183508222834393 -0.38530363325240435 0.07863443158483933 
1.7757537734690623 -0.1818823332447335 0.6362960987326007 0.041181217827336754 -0.4875073806972199 -1.2879692057425338 
2.497430768711283 -0.6828327631520279 -0.4230133725607531 1.2744270144804801 0.3594062199488008 0.08573228181374265 
0.08397925851032026 0.9579382771627527 -2.0498732904619272 -0.1975959943614875 -0.012855827689130747 1.3419580714939852 
1.8150000276234795 -1.3241583385208426 -0.3310942649791666 1.8202158285057881 -0.8783082091506875 -0.9391342951898253 
-0.770487210042073 1.2338178060849405 -0.8462209487933039 -0.7755486225191969 -0.12729485492169532 -0.4036550526500662 
];
w2 = [
-1.5446723343347954 -0.11237811016981894 0.2993307865271193 0.19534843905593863 0.39174461198836125 2.0950207985555886 -0.12405777219960518 0.1690371716838549 -0.3426845599818515 -0.736394066338451 2.037191480926995 -0.18772316589490137 0.1882422558844894 0.21763219729713254 -0.49378660726072754 -1.1042098370107432 0.022575601901988276 0.5862601878651912 -2.1273216586101187 0.41812463986831916 
0.9174243658080872 0.749440251722488 -0.25235091919041014 -1.0282349409652063 -0.10407736098712041 0.16011277037899865 -0.6012887594420636 -1.2177288929307937 0.058443959069615865 -0.5284997542130281 -0.7211546265599025 -1.4548913510350991 -0.22358922315018123 0.08526273731924604 0.7184049323458205 1.2567547562946317 1.4962208861751698 -1.244683785065267 1.7468859653780318 -0.05545483859570979 
];
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


%%
%Initializing variables for plotting
In_Corr_1_o1 = [];  %Incorrectly assigned Label 1
In_Corr_1_o2 = [];
In_Corr_1_n = [];
In_Corr_0_o1 = [];  %Incorrectly assigned Label 0
In_Corr_0_o2 = [];
In_Corr_0_n = [];
Corr_1_o1 = [];     %Correctly assigned Label 1
Corr_1_o2 = [];
Corr_1_n = [];
Corr_0_o1 = [];     %Correctly assigned Label 0
Corr_0_o2 = [];
Corr_0_n = [];

%Output without noise
corr_test_data = [];
corr_test_label = [];

Label=[];
Output1=[];
Output2=[];
count = 0; %number of correctly classified inputs
for k=1:size(test_data,1)
        Input=test_data(k,:);
        
        %Normalize
        Input = Input - mean_train;
        Input = Input ./ std_train;

        Input=[1 Input];
       
        n1 = w1*Input';     
        a1=poslin(n1);
         
        n2 = w2*a1;        
        [YY,II] = max(n2);
        Label(k)=II-1;       
        
        if Label(k)==test_label(k)
            count = count + 1;
            Output1 = [Output1 n2(1)];
            Output2 = [Output2 n2(2)];      
            corr_test_data = [corr_test_data ; test_data(k,:)];
            corr_test_label = [corr_test_label ; test_label(k)];
%         else
%             k  %printing index of misclassified input
        end
end

%Add Output1 and Output2 to appropriate variables
for k=1:size(Output1,2)
    if Label(k) == 1
        Corr_1_o1 = [Corr_1_o1; Output1(k)];
        Corr_1_o2 = [Corr_1_o2; Output2(k)];
        Corr_1_n = [Corr_1_n; 0];
    else
        Corr_0_o1 = [Corr_0_o1; Output1(k)];
        Corr_0_o2 = [Corr_0_o2; Output2(k)];
        Corr_0_n = [Corr_0_n; 0];
    end
end

%% COMPILING COUNTEREXAMPLES

for loop = 1:40
   
    Output1 = zeros(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1)); 
    Output2 = zeros(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1));
    Label = zeros(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1));
    
    temp = eval(['Noise_' num2str(loop)]);
    for n=1:size(eval(['Noise_' num2str(loop)]),1)
        for k=1:size(corr_test_data,1) 

            Input=corr_test_data(k,:);    
            test_data_noisy=floor(Input + (temp(n,:)/100).*Input);   %noise added
                       
            %Normalize
            test_data_noisy = test_data_noisy - mean_train;
            test_data_noisy = test_data_noisy ./ std_train;

            %Check noise pattern
            test_data_noisy = [1 test_data_noisy];
            n1 = w1*test_data_noisy'; 
            a1 = poslin(n1);
            n2 = w2*a1;
            [YY,II] = max(n2);
            Output1(n,k)=n2(1);
            Output2(n,k)=n2(2);
            Label(n,k)=II-1;            
        end
    end
    Output1 = Output1';
    Output1 = Output1(:);
    Output2 = Output2';
    Output2 = Output2(:);
    Label = Label';
    Label = Label(:);

    %Add Output1, Output2 to appropriate variables
    for k=1:size(Output1,1)
            if rem(k,count) == 0 
                if Label(k) == corr_test_label(count) %No misclassification
                    if Label(k) == 1
                        Corr_1_o1 = [Corr_1_o1; Output1(k)];
                        Corr_1_o2 = [Corr_1_o2; Output2(k)];
                        Corr_1_n = [Corr_1_n; loop];
                    else
                        Corr_0_o1 = [Corr_0_o1; Output1(k)];
                        Corr_0_o2 = [Corr_0_o2; Output2(k)];
                        Corr_0_n = [Corr_0_n; loop];
                    end
                else %Misclassification
                    if Label(k) == 1
                        In_Corr_1_o1 = [In_Corr_1_o1; Output1(k)];
                        In_Corr_1_o2 = [In_Corr_1_o2; Output2(k)];
                        In_Corr_1_n = [In_Corr_1_n; loop];
                    else
                        In_Corr_0_o1 = [In_Corr_0_o1; Output1(k)];
                        In_Corr_0_o2 = [In_Corr_0_o2; Output2(k)];
                        In_Corr_0_n = [In_Corr_0_n; loop];
                    end
                end
            else
                if Label(k) == corr_test_label(rem(k,count)) %No misclassification
                    if Label(k) == 1
                        Corr_1_o1 = [Corr_1_o1; Output1(k)];
                        Corr_1_o2 = [Corr_1_o2; Output2(k)];
                        Corr_1_n = [Corr_1_n; loop];
                    else
                        Corr_0_o1 = [Corr_0_o1; Output1(k)];
                        Corr_0_o2 = [Corr_0_o2; Output2(k)];
                        Corr_0_n = [Corr_0_n; loop];
                    end
                else %Misclassification
                    if Label(k) == 1
                        In_Corr_1_o1 = [In_Corr_1_o1; Output1(k)];
                        In_Corr_1_o2 = [In_Corr_1_o2; Output2(k)];
                        In_Corr_1_n = [In_Corr_1_n; loop];
                    else
                        In_Corr_0_o1 = [In_Corr_0_o1; Output1(k)];
                        In_Corr_0_o2 = [In_Corr_0_o2; Output2(k)];
                        In_Corr_0_n = [In_Corr_0_n; loop];
                    end
                end          
            end
    end

end

%% CALCULATING PERCENTAGE BIAS ESTIMATE

ratio_1 = size(In_Corr_0_n,1)/size(Corr_1_n,1);
ratio_2 = size(In_Corr_1_n,1)/size(Corr_0_n,1);

pbe = abs(ratio_1 - ratio_2) %only single difference value for binary classifier
