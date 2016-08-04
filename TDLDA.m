load('cell_attFace_label.mat');
[ train_data,train_label,test_data,test_label] =k_fold(cell_attFace,label);
cell_trainingSet = train_data;
cell_testingSet = test_data;
num_Class = 40;
no_dims = 2;
%function [train_projection, test_projection] = TDLDA(cell_trainingSet, cell_testingSet, no_dims, num_Class)
% cell_dataSet 待降维的数据集，cell类型
% no_dims      降维后特征的个数
% num_Class    训练数据的类别数
% Output:

num_trainingSet = size(cell_trainingSet, 2);
[height, width] = size(cell_trainingSet{1});
nSamplePerClass = num_trainingSet/num_Class;

%所有样本均值
meanSample = zeros(height, width);
for i=1:num_trainingSet
    meanSample = meanSample + cell_trainingSet{i};
end
meanSample = meanSample/num_trainingSet;
%-------------------------------------------
%类内均值
meanClass = cell(1,num_Class);
for i=1:num_Class
    meanClass{i} = zeros(height, width);
    for j=1:nSamplePerClass
        meanClass{i} = meanClass{i} + cell_trainingSet{(i-1)*nSamplePerClass+j};
    end
    meanClass{i} = meanClass{i}/nSamplePerClass;
end
%--------------------------------------------------

Gb = zeros(width, width);
for i=1:num_Class
    Gb = Gb + nSamplePerClass*(meanClass{i}-meanSample)'*(meanClass{i}-meanSample);
end
Gb = Gb/num_trainingSet;

Gw = zeros(width, width);
for i=1:num_Class
    for j=1:nSamplePerClass
        Gw = Gw + (cell_trainingSet{(i-1)*nSamplePerClass+j}-meanClass{i})'*(cell_trainingSet{(i-1)*nSamplePerClass+j}-meanClass{i});
    end
end
Gw = Gw/num_trainingSet;

Gt = zeros(width, width);
for i=1:num_trainingSet
    Gt = Gt + (cell_trainingSet{i}-meanSample)'*(cell_trainingSet{i}-meanSample);
end
Gt = Gt/num_trainingSet;

[eigVector, eigValue] = eig(Gb,Gw);
%[vec, val] = eig(inv(Gw)*Gb);%两式作用相同
[eigVector, eigValue] = sortem(eigVector, eigValue);

% eigValue = diag(eigValue);
for i=1:size(eigVector,2)
    eigVector(:,i)=eigVector(:,i)/norm(eigVector(:,i));
end
projection = eigVector(:,1:no_dims);

train_projection = cell(1,num_trainingSet);
num_testingSet = size(cell_testingSet,2);
test_projection = cell(1,num_testingSet);
for i=1:neachtrain*nclass
    train_projection{i} = cell_trainingSet{i}*projection;
    test_projection{i} = cell_testingSet{i}*projection;
end
