clc;
clear;
close all;
C = [];
n = input('Please Enter Your Preferred Number Of Clusters: ');
for i = 1:n
    Clusters{i}=[];
end
p = menu('Please Opt For A Distance Type', 'Manhattan', 'Euclidean', 'Binahayat');
Color = hsv(n);
MaxIt = 100;
X = [];
D = [];
M = [];
Z = [];
It = [];
%% Generating Initial Data
for i = 1:200
   X(i,1) = 200 * rand() - 100;
   X(i,2) = 300 * rand() - 200;
end
%% Specifying Initial Centres
R = randperm(200,n);
for i = 1:n
    C(i,:) = X(R(i),:);
end
it = 1;
%% Repeating Steps
while  it <= MaxIt
    It = [It,it];
%% Alloting Members To Clusters, Changing Centres And Clusters 
for i = 1: 200
    for j = 1:n
        D(i,j) = ClusterDistance(X(i,:),C(j,:),p);
    end
    [~ , I] = min(D(i,:));
    M(i) = I;  
end
Z = [Z, ClusterCost(D,M)];
if it >= 2
   if abs(Z(it) - Z(it - 1)) < 10
      break;
   end
end
C = zeros(n,2);
for j = 1:n
    c = 0;
    Clusters{j}=[];
       for i = 1:200
           if M(1,i) == j
               c = c + 1;
               Clusters{j} = [Clusters{j},i];
               C(j,1) = C(j,1) + X(i,1);
               C(j,2) = C(j,2) + X(i,2);
           end 
       end
           C(j,1) = C(j,1)/c;
           C(j,2) = C(j,2)/c;
end 
it = it + 1;
end
[zmin, ~] = min(Z);
for i = 1:n
hold on;
    scatter(C(i,1),C(i,2),'MarkerEdgeColor',Color(i,:),'Marker','x','LineWidth',1);
    scatter(C(i,1),C(i,2),'MarkerEdgeColor',Color(i,:),'Marker','s','LineWidth',1);
    scatter(X(Clusters{i},1),X(Clusters{i},2),'MarkerFaceColor',Color(i,:));
end
figure;
plot(It,Z,'x--b')
disp(['The least cost is equal to: '  num2str(zmin)]);