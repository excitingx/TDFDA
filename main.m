clc;
clear all;

%load face database
load('orldata.mat');
facedatabase = double(orldata);
nclass = 40;
nsmpaleeachclass = 10;
neachtrain = 5;
neachtest = 5;

height = 112;
width = 92;

for i=1:nclass
    for j = 1:neachtrain
        Xtrain(:,(i-1)*neachtrain+j) = facedatabase(:,(i-1)*(nsmpaleeachclass)+j*2-1);
    end
end

for i=1:nclass
    for j = 1:neachtest
        Xtest(:,(i-1)*neachtest+j) = facedatabase(:,(i-1)*(nsmpaleeachclass)+j*2);
    end
end

for i=1:neachtrain*nclass
    trainSample{i}=reshape(Xtrain(:,i), height, width);
end

for i=1:neachtest*nclass
    testSample{i}=reshape(Xtest(:,i), height, width);
end

[vec, val] = tdfda(trainSample, nclass);

for d=2:2:20

for i=1:neachtrain*nclass
    newTrainSample{i} = trainSample{i}*vec(:,1:d);
    newTestSample{i} = testSample{i}*vec(:,1:d);
    
    newXtrain(i,:) = reshape(newTrainSample{i}, 1, height*d);
    newXtest(i,:) = reshape(newTestSample{i}, 1, height*d);
end

%re_im{d/5} = uint8(newTrainSample{1}*vec(:,1:d)');
tic
classification=classif(newXtrain', newXtest');

suc(d/2) = success(classification, neachtrain, neachtest);

t(d/2)=toc;
clear newTrainSample newTestSample newXtrain newXtest;
end

t
disp('Recognition rate:');
suc


box
axis([2 20 0.65 1.00]);
set(gca,'Xtick',[2:2:20],'ytick',[0.7:0.05:1.00]);
ylabel('识别率');
xlabel('特征数');

hold on;
plot(2:2:20,suc,'-^')

