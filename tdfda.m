function [vec, val] = tdfda(sample, nClass)

nSample = size(sample, 2);
[height, width] = size(sample{1});
nSamplePerClass = nSample/nClass;

%所有样本均值
meanSample = zeros(height, width);
for i=1:nSample
    meanSample = meanSample + sample{i};
end
meanSample = meanSample/nSample;
%-------------------------------------------
%类内均值
for i=1:nClass
    meanClass{i} = zeros(height, width);
    for j=1:nSamplePerClass
        meanClass{i} = meanClass{i} + sample{(i-1)*nSamplePerClass+j};
    end
    meanClass{i} = meanClass{i}/nSamplePerClass;
end
%--------------------------------------------------

Gb = zeros(width, width);
for i=1:nClass
    Gb = Gb + nSamplePerClass*(meanClass{i}-meanSample)'*(meanClass{i}-meanSample);
end
Gb = Gb/nSample;

Gw = zeros(width, width);
for i=1:nClass
    for j=1:nSamplePerClass
        Gw = Gw + (sample{(i-1)*nSamplePerClass+j}-meanClass{i})'*(sample{(i-1)*nSamplePerClass+j}-meanClass{i});
    end
end
Gw = Gw/nSample;

Gt = zeros(width, width);
for i=1:nSample
    Gt = Gt + (sample{i}-meanSample)'*(sample{i}-meanSample);
end
Gt = Gt/nSample;

[vec, val] = eig(Gb,Gw);
%[vec, val] = eig(inv(Gw)*Gb);%两式作用相同
[vec, val] = sortem(vec, val);

val = diag(val);
for i=1:size(vec,2)
    vec(:,i)=vec(:,i)/norm(vec(:,i));
end
