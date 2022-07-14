clc;
clear;
close all;
LoadAv =  [normrnd(14,1,1,1500) ; normrnd(14,1,1,1500); normrnd(15,1,1,1500) ; normrnd(19,1,1,1500); normrnd(23,1,1,1500)];
UnloadAv = [normrnd(9,1,1,1500) ; normrnd(9,1,1,1500); normrnd(11,1,1,1500) ; normrnd(15,1,1,1500); normrnd(19,1,1,1500)];
ST = [normrnd(1,0.25,1,1500) ; normrnd(1,0.25,1,1500); normrnd(4,0.5,1,1500) ; normrnd(4,0.5,1,1500); normrnd(4,0.5,1,1500)];
HeightAvC = [1.49, 1.64, 1.9, 2, 2];
LengthAvC = [1.69, 2.4735, 4.5086, 5.52, 7.01];
WidthAvC = [1.39, 1.63, 2, 2.23, 2.4533];
VolAvC = HeightAvC .* LengthAvC .* WidthAvC;
WeightAvP = 2.567049;
HeightAvP = 0.153521;
LengthAvP = 0.334231;
WidthAvP = 0.245838;
VolAvPS = HeightAvP * LengthAvP * WidthAvP;
VolAvPNS = (1.75)^3 * VolAvPS;
Nparcels = (VolAvC)./(0.7*VolAvPS+0.3*VolAvPNS);
Maxit = size(LoadAv,2);
TLoad = [];
TUnload = [];
it = [];

for j = 1:Maxit
    for k = 1:5
    TLoad(k,j) = (LoadAv(k,j) * Nparcels(1,k)+ST(k,j))/(3600);
    TUnload(k,j) = (UnloadAv(k,j) * Nparcels(1,k)+ST(k,j))/(3600);
    end
end

 it = linspace(1,Maxit,Maxit);
% figure();
% subplot(3,2,1);
% hold on;
% 
% for i = 1:5
%     plot(it,TLoad(i,:));
% end
% xlabel('Simulation Iteration');
% ylabel('Total Loading Time(Hour)');
% legend('Vanet Sabok','Vanet Sangin','6 Ton','8 Ton','Tak');
% hold on;

%  subplot(3,2,2);
%  hold on;
%  xlabel('Simulation Iteration');
%  ylabel('Total Unloading Time(Hour)');
 S = {'k-','b-','g-','c','r-'};
% 
% figure(2);
%  
%  for i = 1:5
%     plot(it,TLoad(i,:),S{i});
%     hold on;
%  end
% 
% xlabel('Simulation Iteration');
% ylabel('Total Loading Time(Hour)');
% legend('Vanet Sabok','Vanet Sangin','6 Ton','8 Ton','Tak');

 
% subplot(3,2,3);
% hold on;
 
% 
% % plot(it,TUnload(5,:),'Color',[0.9,0.3,0.1]);
% % hold on;
% % plot(it,2*TUnload(3,:),'Color',[0,0.8,0.5]);
% % xlabel('Simulation Iteration');
% % ylabel('Total Unloading Time(Hour)');
% % legend('Tak','6 Ton + 6 Ton')
%   
% hold off;
 %%legend('Tak','6 Ton + 6 Ton');
%  
% 
%  
%  subplot(3,2,4);
%  hold on;
%  xlabel('Simulation Iteration');
%  ylabel('Total Unloading Time(Hour)');
% 
% 
% plot(it,3*TUnload(3,:),'b-.');
% 
% plot(it,TUnload(5,:),'r-.');
%   
% hold off;
% legend('6 Ton + 6 Ton + 6 Ton','Tak');
% 
% 
% subplot(3,2,5);
%  hold on;
%  xlabel('Simulation Iteration');
%  ylabel('Total Loading Time(Hour)');
% 
% plot(it,2*TLoad(4,:),'b');
% plot(it,TLoad(5,:),'r');
%   
% hold off;
% legend('8 Ton + 8 Ton','Tak');
% 
% 
% subplot(3,2,6);
% hold on;
% xlabel('Simulation Iteration');
% ylabel('Total Unloading Time(Hour)');
% 
% plot(it,2*TUnload(4,:),'b-.');
% plot(it,TUnload(5,:),'r-.');
%   
% hold off;
% legend('8 Ton + 8 Ton','Tak');
% 
% 
% 
% figure();
% hold on;
plot(it,3*TLoad(4,:),'Color', [0.0010 0.7450 0.9330]);
hold on;
plot(it,2*TLoad(5,:),'Color', [0.9 0.3 0.1]);
xlabel('Simulation Iteration');
ylabel('Total Loading Time(Hour)');
legend('8 Ton + 8 Ton + 8 Ton','Tak + Tak');
% 
% 
% 
% 
% figure();
% hold on;
% plot(it,4*TUnload(3,:),'Color', [0 0.3 0.9]);
% plot(it,2*TUnload(4,:),'Color', [0 0.8450 0.3330]);
% hold off;
% legend('6 Ton + 6 Ton + 6 Ton','8 Ton + 8 Ton');
