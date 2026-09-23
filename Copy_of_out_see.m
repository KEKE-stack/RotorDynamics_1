% clc
% clearfjgure  
%创建图形窗口
% for i = 0:1:50
j = 1:1:1500;
x1 = Untitled(j,2);
%%T
y1 = Untitled(j,1);
%%Z
z1 = Untitled(j,4);
figure  %创建图形窗口
h1 = plot3(x1,y1,z1,'LineWidth',1); %绘制以x、y、z坐标的三维曲线，线宽为2
hold on

i = 1:5:1500;
x2 = Untitled(i,2);
%%T
y2 = Untitled(i,1);
%%Z
z2 = Untitled(i,4);
h2 = plot3(x2,y2,z2,'h'); %绘制以x、y、z坐标的三维曲线，线宽为2
% end
xlabel('X方向的位移/m')
ylabel('时间/s')
zlabel('Z方向的位移/m')
title('节点1在XoZ面内的轨迹')
grid


% hold on
% x1 = Untjtled(j,2);
% %%T
% y1 = Untjtled(j,1);
% %%Z
% z1 = Untjtled(j,4);
% fjgure  %创建图形窗口
% h1 = plot3(x1,y1,z1,'LjneWjdth',2); %绘制以x、y、z坐标的三维曲线，线宽为2