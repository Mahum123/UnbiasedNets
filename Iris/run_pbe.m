%% 
% Reading Noisexxx.csv generated during Counterexample analysis

clc
clear all
close all

Noise = readtable('Noise.csv'); %THIS NEEDS TO BE UPDATED
Index_zeros = find(Noise.Var1==0 & Noise.Var2==0 & Noise.Var3==0 & Noise.Var4==0);

% Obtain Noise vectors from the table using indexes of vectors
Noise_1 = table2array(Noise(1:Index_zeros(1)-1,1:4));
Noise_2 = table2array(Noise(Index_zeros(1)+1:Index_zeros(2)-1,1:4));
Noise_3 = table2array(Noise(Index_zeros(2)+1:Index_zeros(3)-1,1:4));
Noise_4 = table2array(Noise(Index_zeros(3)+1:Index_zeros(4)-1,1:4));
Noise_5 = table2array(Noise(Index_zeros(4)+1:Index_zeros(5)-1,1:4));
Noise_6 = table2array(Noise(Index_zeros(5)+1:Index_zeros(6)-1,1:4));
Noise_7 = table2array(Noise(Index_zeros(6)+1:Index_zeros(7)-1,1:4));
Noise_8 = table2array(Noise(Index_zeros(7)+1:Index_zeros(8)-1,1:4));
Noise_9 = table2array(Noise(Index_zeros(8)+1:Index_zeros(9)-1,1:4));
Noise_10 = table2array(Noise(Index_zeros(9)+1:Index_zeros(10)-1,1:4));
Noise_11 = table2array(Noise(Index_zeros(10)+1:Index_zeros(11)-1,1:4));
Noise_12 = table2array(Noise(Index_zeros(11)+1:Index_zeros(12)-1,1:4));
Noise_13 = table2array(Noise(Index_zeros(12)+1:Index_zeros(13)-1,1:4));
Noise_14 = table2array(Noise(Index_zeros(13)+1:Index_zeros(14)-1,1:4));
Noise_15 = table2array(Noise(Index_zeros(14)+1:Index_zeros(15)-1,1:4));
Noise_16 = table2array(Noise(Index_zeros(15)+1:Index_zeros(16)-1,1:4));
Noise_17 = table2array(Noise(Index_zeros(16)+1:Index_zeros(17)-1,1:4));
Noise_18 = table2array(Noise(Index_zeros(17)+1:Index_zeros(18)-1,1:4));
Noise_19 = table2array(Noise(Index_zeros(18)+1:Index_zeros(19)-1,1:4));
Noise_20 = table2array(Noise(Index_zeros(19)+1:Index_zeros(20)-1,1:4));
Noise_21 = table2array(Noise(Index_zeros(20)+1:Index_zeros(21)-1,1:4));
Noise_22 = table2array(Noise(Index_zeros(21)+1:Index_zeros(22)-1,1:4));
Noise_23 = table2array(Noise(Index_zeros(22)+1:Index_zeros(23)-1,1:4));
Noise_24 = table2array(Noise(Index_zeros(23)+1:Index_zeros(24)-1,1:4));
Noise_25 = table2array(Noise(Index_zeros(24)+1:Index_zeros(25)-1,1:4));
Noise_26 = table2array(Noise(Index_zeros(25)+1:Index_zeros(26)-1,1:4));
Noise_27 = table2array(Noise(Index_zeros(26)+1:Index_zeros(27)-1,1:4));
Noise_28 = table2array(Noise(Index_zeros(27)+1:Index_zeros(28)-1,1:4));
Noise_29 = table2array(Noise(Index_zeros(28)+1:Index_zeros(29)-1,1:4));
Noise_30 = table2array(Noise(Index_zeros(29)+1:Index_zeros(30)-1,1:4));
Noise_31 = table2array(Noise(Index_zeros(30)+1:Index_zeros(31)-1,1:4));
Noise_32 = table2array(Noise(Index_zeros(31)+1:Index_zeros(32)-1,1:4));
Noise_33 = table2array(Noise(Index_zeros(32)+1:Index_zeros(33)-1,1:4));
Noise_34 = table2array(Noise(Index_zeros(33)+1:Index_zeros(34)-1,1:4));
Noise_35 = table2array(Noise(Index_zeros(34)+1:Index_zeros(35)-1,1:4));
Noise_36 = table2array(Noise(Index_zeros(35)+1:Index_zeros(36)-1,1:4));
Noise_37 = table2array(Noise(Index_zeros(36)+1:Index_zeros(37)-1,1:4));
Noise_38 = table2array(Noise(Index_zeros(37)+1:Index_zeros(38)-1,1:4));
Noise_39 = table2array(Noise(Index_zeros(38)+1:Index_zeros(39)-1,1:4));
Noise_40 = table2array(Noise(Index_zeros(39)+1:size(Noise,1),1:4));

temp = readtable('Datasets/iris_test.csv'); %last col of each row is label
test_data = table2array(temp(:,2:size(temp,2)-1));
test_label = table2array(temp(:,size(temp,2)));
clear temp

%%
% =================================================================================================================================================
% Network Model
% =================================================================================================================================================

%------------------------------------------------------------------------------------------------------------------

%% % PARAMETERS FROM ORIGINAL MODEL
w1 = [
0.3764859 -0.1325347 0.2249888 0.3221219 0.14895463 0.36896753 0.5747366 0.021657495 -0.4451902 0.61343306 0.29700768 0.24104421 0.513501 0.54153186 0.38240823 
-0.2203477 0.61799735 -0.1286511 0.00077234773 0.25060537 -0.11714319 0.019777233 -0.06974457 0.1276257 -0.36513656 -0.422896 0.6690306 0.2763327 0.43235993 -0.080358826 
0.062827736 0.5272662 0.2241191 0.64816815 -0.24686286 -0.39893666 -0.52499056 0.2565899 -0.004698813 -0.40362072 0.29605848 -0.5692841 0.47151053 0.029342921 0.43953487 
-0.039330557 0.018949652 -0.35599485 -0.0034969116 0.39914748 -0.2578463 -0.46473843 -0.60664093 0.28516793 -0.3062588 0.7854988 -0.3263 -0.3443082 -0.37962893 0.35183913 
];
w2 = [
-0.026094368 -0.12892394 0.29388314 -0.42716655 0.21166514 -0.33843756 -0.20175079 0.016049594 -0.41597232 0.2671011 0.23858573 -0.10132686 0.20297843 0.20321758 -0.42734814 
0.2656622 0.08875868 0.46382833 -0.20361443 0.19768529 -0.19010916 0.2635491 0.19412184 0.11116034 0.38089493 0.08765316 -0.3548023 0.2655465 -0.17047957 -0.024947137 
-0.305319 0.25849208 0.09524679 -0.26639548 0.24591711 -0.33892995 0.30161643 -0.23508157 -0.14330974 -0.052801028 -0.2005488 -0.05810602 -0.2226524 -0.33603176 0.41284215 
-0.49964884 -0.3569734 0.32591772 -0.29367444 0.3498825 0.02448675 -0.03917536 -0.111276895 0.08051318 0.10082692 0.2767029 0.0043053376 0.042984635 -0.09374198 -0.15656352 
0.44836244 -0.08202626 -0.17520188 0.01729251 -0.01787557 0.044504017 -0.3641134 -0.40129232 -0.03217283 -0.36663082 0.24394463 0.21015516 -0.22721784 0.12727576 0.33281446 
0.36196467 -0.22423229 -0.02573078 -0.025106385 -0.113489546 0.16966367 0.32929528 -0.23794666 0.027396947 -0.3515117 -0.006482209 0.34595722 0.41437256 0.46597457 0.11660093 
-0.016599437 0.9264729 -0.46552595 0.10321748 0.52318096 -0.059840918 -0.1731829 -0.3462253 -0.33955744 0.3437347 -0.08627892 0.04097716 -0.2491633 0.7267384 0.12385428 
-0.20009959 0.6796393 -0.5407975 -0.4204661 -0.33349726 0.3334583 0.22393924 -0.15773627 -0.4147309 0.44108707 -0.40260205 0.03524405 -0.14901006 -0.10187352 0.20999444 
0.25545102 -0.20886101 0.15278786 0.21626937 0.38752055 -0.17163205 0.33368373 -0.3750447 0.13550115 0.381432 -0.12209773 -0.34656423 0.1585949 -0.1988326 0.27754587 
0.46502936 0.17157044 -0.2161556 -0.22948603 0.19833177 0.2971635 -0.09625965 0.054413557 -0.38616282 0.6578636 -0.3291765 -0.010469049 -0.36650473 0.4989407 -0.23128767 
-0.526442 -0.4074731 0.27384686 0.292163 0.081206135 0.2544365 0.3829568 -0.21921997 0.30961967 -0.035971995 0.4794103 0.22029418 -0.41548964 -0.28938222 -0.039384246 
0.47032705 0.25872755 -0.50818115 0.2896798 0.11437284 -0.2607305 0.048493356 -0.093277484 -0.34393862 -0.14547585 -0.59846103 -0.34732425 -0.34245208 0.7098701 -0.33354127 
0.09421179 0.3124022 0.18635552 0.25452438 -0.011458552 0.26964366 -0.2775694 -0.23086458 -0.13985926 0.20729944 0.46112 0.10077705 -0.07546219 -0.15681376 0.09452134 
0.22125793 0.33431816 -0.13078329 -0.11270412 -0.39882198 0.032132745 -0.21515204 0.16915911 -0.3445643 0.079308756 0.13623086 -0.3400557 0.16764164 0.37813085 -0.24474299 
0.1746935 0.09895861 -0.06921297 0.04159264 0.35264593 -0.4445658 -0.21929076 -0.15025726 -0.19156605 0.060858507 0.042285558 0.24803142 -0.15630636 0.28223792 -0.09803045 
];
w3 = [
0.74477655 -0.6832768 -0.49778998 
-0.028010046 0.0727768 -0.6777954 
-0.6622517 -0.3358443 0.5235531 
-0.5269226 0.24041322 -0.31612933 
0.051967 -0.31563115 -0.23218824 
-0.05187887 0.50944865 -0.093194276 
-0.21952972 0.49058235 0.5561745 
-0.3947464 0.41443145 0.13464296 
0.0721122 0.47810423 -0.18349776 
-0.08093473 0.73762023 -0.47487274 
-0.5541387 -0.267078 0.14062038 
0.43451443 0.18895973 -0.064893186 
-0.48375374 0.2148431 -0.46814317 
0.402055 -0.15471731 -0.6136407 
0.09112376 0.48531508 0.053613007 
];
b1 = [
-0.025810776 0.11433357 -0.070216864 -0.08978301 -0.060588658 0.04488777 0.26432648 0.15850249 0.0 0.19838212 -0.1137368 0.16263214 0.07552653 0.17551929 -0.006774384 
];
b2 = [
0.021250006 0.13340525 -0.054083116 -0.021707255 -0.058217596 0.0 0.0 0.0 0.0 0.12604639 -0.044313747 -0.07975216 0.0 0.015884817 0.0 
];
b3 = [
-0.051083297 0.096848644 -0.088411085 
];
%  -0.00074267 -0.28435257 -0.3466924   0.23294169  0.26372987  0.12318117  -0.35622153  0.06692101 -0.09171601  0.36517584  0.5946085  -0.13333783  -0.086919    0.43393052 -0.56168365
%  -0.51723063 -0.00117873 -0.29194304  0.5621549  -0.13072571  0.67008275   0.44276422  0.5990127   0.6034695  -0.3275186  -0.10042303  0.05999519   0.05717402  0.38696167 -0.11797419 
% ];
% w2 = [-0.230934    0.4141642  -0.1171121   0.03954855  0.4249317  -0.24438792   0.3666814  -0.19974498  0.28995615  0.41739744 -0.20077476 -0.16331452   0.14734471 -0.02334598  0.05498868
%  -0.26177624 -0.17058304  0.06657597 -0.10344279 -0.3323326  -0.09232095  -0.26729035  0.31137353  0.09932136  0.43851012  0.2890656   0.12344369  -0.31019732  0.05188898 -0.12181257
%  -0.21429506 -0.49672374 -0.06021174  0.12024152 -0.11185214  0.29554552   0.15709355  0.0705585  -0.54775083  0.18416847  0.3867027   0.7452628  -0.3897728   0.031409   -0.612096  
%   0.14428751 -0.16765217 -0.1618165   0.09895033  0.15875787 -0.24243991   0.29177925  0.14715096 -0.0730961   0.1958387  -0.19719927  0.10016242   0.04265894  0.4234543   0.48799774
%  -0.03427505  0.3410589  -0.08853984 -0.26769155  0.2885921  -0.16641867   0.25791353  0.31200933 -0.3862661  -0.38749102 -0.04075992 -0.10896358   0.16210294 -0.3168463  -0.3079915 
%   0.5451724   0.04896928  0.09314166  0.02435675  0.0046922   0.07320249  -0.05451599  0.3225675   0.30208552 -0.53273624  0.23990357 -0.24027066  -0.5310238   0.3662379   0.05870539
%  -0.39768577  0.40222424  0.02843791 -0.3753973  -0.36868522  0.35082257   0.1014601   0.02156332 -0.3367145   0.17963141  0.33313388 -0.21434501  -0.33711767  0.14584714  0.05251521
%   0.22546962  0.39397115  0.43350542  0.25170106  0.39574295 -0.0208469  -0.32523265  0.17972755 -0.06173986 -0.03973323  0.12860562 -0.0232441   0.28586066  0.28245488  0.2263838 
%   0.5382824   0.1486094   0.4417568   0.06973958  0.09159547  0.09647864  -0.39455438  0.43229398 -0.20423542 -0.18530197  0.41004944  0.17942585   0.22971846 -0.31524473  0.56780654
%  -0.2488983   0.42484248  0.06402427 -0.28825924  0.41413307 -0.32460225   0.20098244 -0.09097059  0.34850428 -0.26692235 -0.14610137  0.40017217   0.10181437  0.08441842 -0.2917918 
%  -0.24746622 -0.23176372  0.48070243 -0.07728738 -0.1724197  -0.36324996  -0.18557061  0.19849597  0.241305   -0.06574174  0.42023766 -0.15556024   0.15719388 -0.08099709  0.4504911 
%   0.07290151 -0.00741978 -0.3732289  -0.21761005 -0.3646773   0.09357697   0.41699192 -0.11151569 -0.42484927 -0.0226065   0.21426192 -0.12257087   0.05919089 -0.29821774 -0.09398171
%   0.24999616  0.25503522 -0.00555932  0.06338662 -0.07361472 -0.37131327   0.04006971  0.24346031  0.06487724  0.3820844   0.04013803  0.32739884  -0.23463967 -0.41745487 -0.3882546 
%   0.11122973  0.31212774 -0.0955101  -0.14622387 -0.33073664 -0.02128717   0.29685807 -0.33771977  0.26186106 -0.18685806 -0.19356588  0.28745815   0.4197831  -0.13470936 -0.0057203 
%  -0.43282256 -0.08666998  0.11305845 -0.16881675 -0.25192612  0.13813567  -0.17609128 -0.3951251   0.02051222 -0.25892526 -0.35357392 -0.13540569  -0.12576336 -0.33263242  0.02357009 
% ];
% w3 = [-0.6643443  -0.6107625   0.13565685
%   0.4464065  -0.37515324  0.48987383
%  -0.02557958 -0.05481448  0.27455133
%   0.07414639  0.5674218   0.3707314 
%  -0.22431296 -0.11173394  0.56732583
%   0.5234108  -0.5320515  -0.01278955
%   0.5169105   0.16310437  0.31331268
%  -0.45880756 -0.15539978  0.3386989 
%   0.34032908 -0.653337    0.04315819
%   0.56856495  0.33967832  0.21723424
%  -0.19733118 -0.5093369  -0.17606637
%   0.14232752  0.4398694  -0.5611222 
%  -0.64964986  0.3555037  -0.04522593
%   0.45914948  0.2574904   0.1687944 
%  -0.41434148 -0.05407368  0.00741005 
% ];
% b1 = [ 0.         -0.04996496  0.23056872  0.09865556  0.         -0.10310893  0.         -0.04056672 -0.00365821 -0.0116847  -0.03054407  0.04980932 -0.05206638  0.02571295  0.         
% ];
% b2 = [-0.06206896 -0.09690731 -0.13989763  0.          0.          0. -0.03610943 -0.03048392 -0.06135276  0.00581455 -0.11152076  0.06766032  0.05398684 -0.01411004  0.03137972 
% ];
% b3 = [-0.00363622  0.10271578 -0.05154651];

%%
%Initializing variables for plotting
In_Corr_1from2_o1 = [];  %Incorrectly assigned Label 1; True label 2
In_Corr_1from2_o2 = [];
In_Corr_1from2_o3 = [];
In_Corr_1from2_n = [];
In_Corr_1from3_o1 = [];  %Incorrectly assigned Label 1; True label 3
In_Corr_1from3_o2 = [];
In_Corr_1from3_o3 = [];
In_Corr_1from3_n = [];

In_Corr_2from1_o1 = [];  %Incorrectly assigned Label 2; True label 1
In_Corr_2from1_o2 = [];
In_Corr_2from1_o3 = [];
In_Corr_2from1_n = [];
In_Corr_2from3_o1 = [];  %Incorrectly assigned Label 2; True label 3
In_Corr_2from3_o2 = [];
In_Corr_2from3_o3 = [];
In_Corr_2from3_n = [];

In_Corr_3from1_o1 = [];  %Incorrectly assigned Label 3; True label 1
In_Corr_3from1_o2 = [];
In_Corr_3from1_o3 = [];
In_Corr_3from1_n = [];
In_Corr_3from2_o1 = [];  %Incorrectly assigned Label 3; True label 2
In_Corr_3from2_o2 = [];
In_Corr_3from2_o3 = [];
In_Corr_3from2_n = [];

Corr_1_o1 = [];     %Correctly assigned Label 1
Corr_1_o2 = [];
Corr_1_o3 = [];
Corr_1_n = [];
Corr_2_o1 = [];     %Correctly assigned Label 2
Corr_2_o2 = [];
Corr_2_o3 = [];
Corr_2_n = [];
Corr_3_o1 = [];     %Correctly assigned Label 3
Corr_3_o2 = [];
Corr_3_o3 = [];
Corr_3_n = [];
%_n: noise level at which the output values _o1/_o2/_o3 were recorded

%Output without noise
corr_test_data = [];
corr_test_label = [];

count = 0; %number of correctly classified inputs
for i = 1 : size(test_data,1)
   input =  test_data(i,:); 
   l1 = poslin((input * w1) + b1);
   l2 = poslin((l1 * w2) + b2);
   l3 = (l2 * w3) + b3;
   [out_max ind] = max(l3);
   
%    Label(i) = ind-1;

      if (ind - 1)==0
       if strcmp(test_label(i),'Setosa')
           count = count + 1;
           corr_test_data = [corr_test_data ; input];
           corr_test_label = [corr_test_label ; test_label(i)];
           Corr_1_o1 = [Corr_1_o1; l3(1)];
           Corr_1_o2 = [Corr_1_o2; l3(2)];
           Corr_1_o3 = [Corr_1_o3; l3(3)];
           Corr_1_n = [Corr_1_n; 0];
%            Output1(i) = l3(1);
       end
      elseif (ind - 1)==1
       if strcmp(test_label(i),'Versicolor')
           count = count + 1;
           corr_test_data = [corr_test_data ; input];
           corr_test_label = [corr_test_label ; test_label(i)];
           Corr_2_o1 = [Corr_2_o1; l3(1)];
           Corr_2_o2 = [Corr_2_o2; l3(2)];
           Corr_2_o3 = [Corr_2_o3; l3(3)];
           Corr_2_n = [Corr_2_n; 0];
%            Output2(i) = l3(2);
       end
      else
       if strcmp(test_label(i),'Virginica')
           count = count + 1;
           corr_test_data = [corr_test_data ; input];
           corr_test_label = [corr_test_label ; test_label(i)];
           Corr_3_o1 = [Corr_3_o1; l3(1)];
           Corr_3_o2 = [Corr_3_o2; l3(2)];
           Corr_3_o3 = [Corr_3_o3; l3(3)];
           Corr_3_n = [Corr_3_n; 0];           
%            Output3(i) = l3(3);
       end
      end     
   
end


%% Compiling Counterexamples

for loop = 1:40
    Output1 = zeros(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1)); 
    Output2 = zeros(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1));
    Output3 = zeros(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1));
    Label = cell(size(eval(['Noise_' num2str(loop)]),1),size(corr_test_data,1));
    
    for n=1:size(eval(['Noise_' num2str(loop)]),1)
        for k=1:size(corr_test_data,1) 
            Input=corr_test_data(k,:);
            temp = eval(['Noise_' num2str(loop)]);
            test_data_noisy=floor(Input + (temp(n,:)/100).*Input);   %noise added
                       
            %Check noise pattern
            l1 = poslin((test_data_noisy * w1) + b1);
            l2 = poslin((l1 * w2) + b2);
            l3 = (l2 * w3) + b3; 
            Output1(n,k) = l3(1);
            Output2(n,k) = l3(2);
            Output3(n,k) = l3(3);
            [out_max ind] = max(l3);
           
            if (ind - 1)==0
                Label{n,k} = 'Setosa';
            elseif (ind - 1)==1
                Label{n,k} = 'Versicolor';
            else
                Label{n,k} = 'Virginica';
            end              
        end
    end
    Output1 = Output1';
    Output1 = Output1(:);
    Output2 = Output2';
    Output2 = Output2(:);
    Output3 = Output2';
    Output3 = Output2(:);
    Label = Label';
    Label = Label(:);

    %Add Output1, Output2, Output3 to appropriate variables
    for k=1:size(Output1,1)
        if rem(k,count) == 0 
            if strcmp(Label{k}, corr_test_label{count}) %last input in test_data
                if strcmp(Label{k},'Setosa')
                    Corr_1_o1 = [Corr_1_o1; Output1(k)];
                    Corr_1_o2 = [Corr_1_o2; Output2(k)];
                    Corr_1_o3 = [Corr_1_o3; Output3(k)];
                    Corr_1_n = [Corr_1_n; loop];
                elseif strcmp(Label{k},'Versicolor')
                    Corr_2_o1 = [Corr_2_o1; Output1(k)];
                    Corr_2_o2 = [Corr_2_o2; Output2(k)];
                    Corr_2_o3 = [Corr_2_o3; Output3(k)];
                    Corr_2_n = [Corr_2_n; loop];
                else
                    Corr_3_o1 = [Corr_3_o1; Output1(k)];
                    Corr_3_o2 = [Corr_3_o2; Output2(k)];
                    Corr_3_o3 = [Corr_3_o3; Output3(k)];
                    Corr_3_n = [Corr_3_n; loop];
                end
            else %Misclassification
                if strcmp(Label{k},'Setosa')
                    if strcmp(corr_test_label{count},'Versicolor')
                        In_Corr_1from2_o1 = [In_Corr_1from2_o1; Output1(k)];
                        In_Corr_1from2_o2 = [In_Corr_1from2_o2; Output2(k)];
                        In_Corr_1from2_o3 = [In_Corr_1from2_o3; Output3(k)];
                        In_Corr_1from2_n = [In_Corr_1from2_n; loop];
                    else
                        In_Corr_1from3_o1 = [In_Corr_1from3_o1; Output1(k)];
                        In_Corr_1from3_o2 = [In_Corr_1from3_o2; Output2(k)];
                        In_Corr_1from3_o3 = [In_Corr_1from3_o3; Output3(k)];
                        In_Corr_1from3_n = [In_Corr_1from3_n; loop];
                    end
                elseif strcmp(Label{k},'Versicolor')
                    if strcmp(corr_test_label{count},'Setosa')
                        In_Corr_2from1_o1 = [In_Corr_2from1_o1; Output1(k)];
                        In_Corr_2from1_o2 = [In_Corr_2from1_o2; Output2(k)];
                        In_Corr_2from1_o3 = [In_Corr_2from1_o3; Output3(k)];
                        In_Corr_2from1_n = [In_Corr_2from1_n; loop];
                    else
                        In_Corr_2from3_o1 = [In_Corr_2from3_o1; Output1(k)];
                        In_Corr_2from3_o2 = [In_Corr_2from3_o2; Output2(k)];
                        In_Corr_2from3_o3 = [In_Corr_2from3_o3; Output3(k)];
                        In_Corr_2from3_n = [In_Corr_2from3_n; loop];
                    end
                else
                    if strcmp(corr_test_label{count},'Setosa')
                        In_Corr_3from1_o1 = [In_Corr_3from1_o1; Output1(k)];
                        In_Corr_3from1_o2 = [In_Corr_3from1_o2; Output2(k)];
                        In_Corr_3from1_o3 = [In_Corr_3from1_o3; Output3(k)];
                        In_Corr_3from1_n = [In_Corr_3from1_n; loop];
                    else
                        In_Corr_3from2_o1 = [In_Corr_3from2_o1; Output1(k)];
                        In_Corr_3from2_o2 = [In_Corr_3from2_o2; Output2(k)];
                        In_Corr_3from2_o3 = [In_Corr_3from2_o3; Output3(k)];
                        In_Corr_3from2_n = [In_Corr_3from2_n; loop];
                    end
                end
            end
        else
            if strcmp(Label{k}, corr_test_label{rem(k,count)})
                if strcmp(Label{k},'Setosa')
                    Corr_1_o1 = [Corr_1_o1; Output1(k)];
                    Corr_1_o2 = [Corr_1_o2; Output2(k)];
                    Corr_1_o3 = [Corr_1_o3; Output3(k)];
                    Corr_1_n = [Corr_1_n; loop];
                elseif strcmp(Label{k},'Versicolor')
                    Corr_2_o1 = [Corr_2_o1; Output1(k)];
                    Corr_2_o2 = [Corr_2_o2; Output2(k)];
                    Corr_2_o3 = [Corr_2_o3; Output3(k)];
                    Corr_2_n = [Corr_2_n; loop];
                else
                    Corr_3_o1 = [Corr_3_o1; Output1(k)];
                    Corr_3_o2 = [Corr_3_o2; Output2(k)];
                    Corr_3_o3 = [Corr_3_o3; Output3(k)];
                    Corr_3_n = [Corr_3_n; loop];
                end
            else %Misclassification
                if strcmp(Label{k},'Setosa')
                    if strcmp(corr_test_label{rem(k,count)},'Versicolor')
                        In_Corr_1from2_o1 = [In_Corr_1from2_o1; Output1(k)];
                        In_Corr_1from2_o2 = [In_Corr_1from2_o2; Output2(k)];
                        In_Corr_1from2_o3 = [In_Corr_1from2_o3; Output3(k)];
                        In_Corr_1from2_n = [In_Corr_1from2_n; loop];
                    else
                        In_Corr_1from3_o1 = [In_Corr_1from3_o1; Output1(k)];
                        In_Corr_1from3_o2 = [In_Corr_1from3_o2; Output2(k)];
                        In_Corr_1from3_o3 = [In_Corr_1from3_o3; Output3(k)];
                        In_Corr_1from3_n = [In_Corr_1from3_n; loop];
                    end
                elseif strcmp(Label{k},'Versicolor')
                    if strcmp(corr_test_label{rem(k,count)},'Setosa')
                        In_Corr_2from1_o1 = [In_Corr_2from1_o1; Output1(k)];
                        In_Corr_2from1_o2 = [In_Corr_2from1_o2; Output2(k)];
                        In_Corr_2from1_o3 = [In_Corr_2from1_o3; Output3(k)];
                        In_Corr_2from1_n = [In_Corr_2from1_n; loop];
                    else
                        In_Corr_2from3_o1 = [In_Corr_2from3_o1; Output1(k)];
                        In_Corr_2from3_o2 = [In_Corr_2from3_o2; Output2(k)];
                        In_Corr_2from3_o3 = [In_Corr_2from3_o3; Output3(k)];
                        In_Corr_2from3_n = [In_Corr_2from3_n; loop];
                    end
                else
                    if strcmp(corr_test_label{rem(k,count)},'Setosa')
                        In_Corr_3from1_o1 = [In_Corr_3from1_o1; Output1(k)];
                        In_Corr_3from1_o2 = [In_Corr_3from1_o2; Output2(k)];
                        In_Corr_3from1_o3 = [In_Corr_3from1_o3; Output3(k)];
                        In_Corr_3from1_n = [In_Corr_3from1_n; loop];
                    else
                        In_Corr_3from2_o1 = [In_Corr_3from2_o1; Output1(k)];
                        In_Corr_3from2_o2 = [In_Corr_3from2_o2; Output2(k)];
                        In_Corr_3from2_o3 = [In_Corr_3from2_o3; Output3(k)];
                        In_Corr_3from2_n = [In_Corr_3from2_n; loop];
                    end
                end
            end
        end
    end

end

%% For number of inputs to add to each class: Run only with original Network

%disp('FOR DIVERSIFICATION, COPY THESE VARIABLES TO .m FILE:')
%disp('mis_label1 = '); disp(size(In_Corr_2from1_n,1) + size(In_Corr_3from1_n,1))
%disp('total_label1 = '); disp(size(Corr_1_n,1) + size(In_Corr_2from1_n,1) + size(In_Corr_3from1_n,1))
%disp('mis_label2 = '); disp(size(In_Corr_1from2_n,1) + size(In_Corr_3from2_n,1))
%disp('total_label2 = '); disp(size(Corr_2_n,1) + size(In_Corr_1from2_n,1) + size(In_Corr_3from2_n,1))
%disp('mis_label3 = '); disp(size(In_Corr_1from3_n,1) + size(In_Corr_2from3_n,1))
%disp('total_label3 = '); disp(size(Corr_3_n,1) + size(In_Corr_1from3_n,1) + size(In_Corr_2from3_n,1))

%% Calculate Percentage Bias Estimate

ratio_1 = (size(In_Corr_2from1_n,1) + size(In_Corr_3from1_n,1))/size(Corr_1_n,1);
ratio_2 = (size(In_Corr_1from2_n,1) + size(In_Corr_3from2_n,1))/size(Corr_2_n,1);
ratio_3 = (size(In_Corr_1from3_n,1) + size(In_Corr_2from3_n,1))/size(Corr_3_n,1);

diff = [abs(ratio_1 - ((ratio_2 + ratio_3)/2));
        abs(ratio_2 - ((ratio_1 + ratio_3)/2));
        abs(ratio_3 - ((ratio_1 + ratio_2)/2))];
pbe = max(diff)
