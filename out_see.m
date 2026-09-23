% clc
% clear
out = VideoWriter('vdo_show.avi'); %建议填写完整路径，默认保存在MATLAB工作目录下
out.FrameRate = 100;%帧率
open(out);
L_1 = 0:0.05515/10:0.05515;
L_2 = 0:0.1099/10:0.1099;
i = 1;
%%组装四个单元的位移情况
%%先组装四个单元的x方向的变形情况
x_1 = subs(Form_esh1_u*Untitled(i,2:13).',l,L_1);
x_2 = subs(Form_esh1_u*Untitled(i,8:19).',l,L_1);
x_3 = subs(Form_esh2_u*Untitled(i,14:25).',l,L_2);
x_4 = subs(Form_esh2_u*Untitled(i,20:31).',l,L_2);
x = horzcat(x_1,x_2,x_3,x_4);
%%再组装四个单元的y方向的变形情况
y_0_1 = 0:0.05515/10:0.05515;
y_1 = y_0_1+subs(Form_esh1_v*Untitled(i,2:13).',l,L_1);
y_0_2 = 0.05515:0.05515/10:2*0.05515;
y_2 = y_0_2+subs(Form_esh1_v*Untitled(i,8:19).',l,L_1);
y_0_3 = 2*0.05515:0.1099/10:2*0.05515+0.1099;
y_3 = y_0_3+subs(Form_esh2_v*Untitled(i,14:25).',l,L_2);
y_0_4 = 2*0.05515+0.1099:0.1099/10:2*0.05515+2*0.1099;
y_4 = y_0_4+subs(Form_esh2_v*Untitled(i,20:31).',l,L_2);
y = horzcat(y_1,y_2,y_3,y_4);
%%再组装四个单元的z方向的变形情况
z_1 = subs(Form_esh1_w*Untitled(i,2:13).',l,L_1);
z_2 = subs(Form_esh1_w*Untitled(i,8:19).',l,L_1);
z_3 = subs(Form_esh2_w*Untitled(i,14:25).',l,L_2);
z_4 = subs(Form_esh2_w*Untitled(i,20:31).',l,L_2);
z = horzcat(z_1,z_2,z_3,z_4);
figure  %创建图形窗口
h = plot3(x,y,z,'LineWidth',2); %绘制以x、y、z坐标的三维曲线，线宽为2
hold on
plot3(x(1,22),y(1,22),z(1,22),"r. ",'MarkerSize',20);
hold on
plot3(x(1,44),y(1,44),z(1,44),"r. ",'MarkerSize',20);
hold on
axis([-3e-8,3e-8,0,0.35,-3.7e-5,1e-5]);
for i = 1:1:15000
%%组装四个单元的位移情况
%%先组装四个单元的x方向的变形情况
x_1 = subs(Form_esh1_u*Untitled(i,2:13).',l,L_1);
x_2 = subs(Form_esh1_u*Untitled(i,8:19).',l,L_1);
x_3 = subs(Form_esh2_u*Untitled(i,14:25).',l,L_2);
x_4 = subs(Form_esh2_u*Untitled(i,20:31).',l,L_2);
x = horzcat(x_1,x_2,x_3,x_4);
%%再组装四个单元的y方向的变形情况
y_0_1 = 0:0.05515/10:0.05515;
y_1 = y_0_1+subs(Form_esh1_v*Untitled(i,2:13).',l,L_1);
y_0_2 = 0.05515:0.05515/10:2*0.05515;
y_2 = y_0_2+subs(Form_esh1_v*Untitled(i,8:19).',l,L_1);
y_0_3 = 2*0.05515:0.1099/10:2*0.05515+0.1099;
y_3 = y_0_3+subs(Form_esh2_v*Untitled(i,14:25).',l,L_2);
y_0_4 = 2*0.05515+0.1099:0.1099/10:2*0.05515+2*0.1099;
y_4 = y_0_4+subs(Form_esh2_v*Untitled(i,20:31).',l,L_2);
y = horzcat(y_1,y_2,y_3,y_4);
%%再组装四个单元的z方向的变形情况
z_1 = subs(Form_esh1_w*Untitled(i,2:13).',l,L_1);
z_2 = subs(Form_esh1_w*Untitled(i,8:19).',l,L_1);
z_3 = subs(Form_esh2_w*Untitled(i,14:25).',l,L_2);
z_4 = subs(Form_esh2_w*Untitled(i,20:31).',l,L_2);
z = horzcat(z_1,z_2,z_3,z_4);
%%绘图
set(h, 'XData', x, 'YData', y,'ZData', z); 
% drawnow;
% hold on
% hold off
F=getframe(gcf);%捕获帧
writeVideo(out,F);
% clf;%清空图窗内所有东西
% imwrite(F.cdata,['E:\大学以来\学习\毕业设计--姚本春老师\Finite_element_modeling\计算结果\',num2str(i),'.jpg']);
end