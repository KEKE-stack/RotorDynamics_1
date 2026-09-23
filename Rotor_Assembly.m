%%轴启动器
clear all
clc
syms l t %l表征特定位置，t表征特定时间
%%
%%输入质量不平衡基本参数,转轴转速和参考系R的运动
%质量不平衡用集中质量Mmu来模拟，单位kg，距离轴形心距离Rmu，与Oz轴初始相位角为epsilon_mu，距离左端坐标原点距离Ymu
Mmu = 0.00001;
Ymu = 0.2202;
epsilon_mu = pi/4;
Rmu = 4.4*10^(-4);
%%
%%输入轴的基本参数，以m为单位
ROUeshi = 7.85*10^3;
Lesh1 = 0.027575;Lesh2 = 0.027475;
Eeshi = 210*10^9;
I1 = 7.85398*10^(-9);I2 = 4.1692*10^(-10);
k = 0.9;
Geshi = 80.15267*10^9;%泊松比为0.31
Sesh1 = 314.16*10^(-6);
%r1 = 0.01;
Sesh2 = 72.38*10^(-6);
%r2 = 4.8e-3;
%m总=0.3969
%%
%%输入轴承的刚度矩阵
k_be1 = 9*10^(7);%原轴承1刚度9E7
%k_be2 = 2.29*10^(7);%HSFD的刚度为2.277E6，原轴承2刚度2.29E7
k_be2 = 2.0713*10^(6);%HSFD与轴承2并联
K_be1 = K_rolling_bearing_node_5(k_be1);
K_be2 = K_rolling_bearing_node_13(k_be2);
K_be_all = blkdiag(zeros(24,24),K_be1,zeros(42,42),K_be2);%组装成分块对角矩阵
%%
%%输入转速和参考系R的运动
%%每次此单元的参数都要对O_F
%FAI = 1000*t + 100*t^2; %转轴转速(临界转速)
FAI = 1585.2*t; %转轴转速(临界转速)
%afa = pi*180^(-1)*sin(20*pi*t);%绕Z轴摆动，振幅1°，频率10HZ
afa = 0*t;%不摆动
beta = 0*t;%不摆动
%beta = pi*180^(-1)*sin(20*pi*t);%绕x轴摆动
gama = 0*t;%绕Y轴
Xog = 0*t;
Yog = 0*t;
Zog = 0*t;
%%
Wx = -diff(afa)*cos(beta)*sin(gama)+diff(beta)*cos(gama);%[beta,0]是为了防止缩维
Wy = diff(afa)*sin(beta)+diff(gama);
Wz = diff(afa)*cos(beta)*cos(gama)+diff(beta)*sin(gama);
%%
Xl_mu = Rmu*sin(epsilon_mu);
Zl_mu = Rmu*cos(epsilon_mu);%质量不平衡位置坐标
x_ = Xl_mu*cos(FAI)+Zl_mu*sin(FAI);
z_ = -Xl_mu*sin(FAI)+Zl_mu*cos(FAI);%质量不平衡有限元素向量
Xo = (Xog*cos(afa)+Yog*sin(afa))*cos(gama)-((Xog*sin(afa)-Yog*cos(afa))*sin(beta)+Zog*cos(beta))*sin(gama);
d_Xo = diff(Xo);d_Xo_2 = diff(Xo,2); 
Yo = -(Xog*sin(afa)-Yog*cos(afa))*cos(beta)+Zog*sin(beta);
d_Yo = diff(Yo);d_Yo_2 = diff(Yo,2);
Zo = ((Xog*sin(afa)-Yog*cos(afa))*sin(beta)+Zog*cos(beta))*cos(gama)+(Xog*cos(afa)+Yog*sin(afa))*sin(gama);
d_Zo = diff(Zo);d_Zo_2 = diff(Zo,2);
%%
%%由于求导会导致缩维，所以提前预置求导的值
d_FAI = diff(FAI);
d_FAI_2 = diff(FAI,2);
d_Wx = diff(Wx);
d_Wy = diff(Wy);
d_Wz = diff(Wz);
%%
%%返回轴单元的形状函数矩阵
[Form_esh1_u,Form_esh1_v,Form_esh1_w,Form_esh1_xita,Form_esh1_lamuda,Form_esh1_posai] = xingzhuang(l,Lesh1,Eeshi,I1,k,Geshi,Sesh1);%1、2
[Form_esh2_u,Form_esh2_v,Form_esh2_w,Form_esh2_xita,Form_esh2_lamuda,Form_esh2_posai] = xingzhuang(l,Lesh2,Eeshi,I2,k,Geshi,Sesh2);%3、4
%%
%%返回质量不平衡单元刚度阵系数
[Kuu,Kuv,Kuw,Kuxita,Kulamuda,Kuposai,Kvu,Kvv,Kvw,Kvlamuda,Kwu,Kwv,Kww,Kwxita,Kwlamuda,Kwposai,Kxitaxita,Kxitalamuda,Klamudaxita,Klamudalamuda,Klamudaposai,Kposailamuda,Kposaiposai] = gangduxishu(d_FAI,d_Xo,d_Yo,d_Zo,d_Wx,d_Wy,d_Wz,d_Xo_2,d_Yo_2,d_Zo_2,Wx,Wy,Wz,Rmu,x_,z_,Zo,Xo,Yo,Ymu);
%%
%%返轴单元的质量矩阵
Mesh1 = ShaftElementMass(0,Lesh1,Form_esh1_u,Form_esh1_v,Form_esh1_w,Form_esh1_xita,Form_esh1_lamuda,Form_esh1_posai,ROUeshi,Sesh1,I1);
Mesh2 = Mesh1;
Mesh3 = Mesh1;
Mesh4 = Mesh1;
Mesh5 = ShaftElementMass(0,Lesh2,Form_esh2_u,Form_esh2_v,Form_esh2_w,Form_esh2_xita,Form_esh2_lamuda,Form_esh2_posai,ROUeshi,Sesh2,I2);
% writematrix(double(subs(Mesh5,t,0)),'Mesh3.xls');
Mesh6 = Mesh5;
Mesh7 = Mesh5;
Mesh8 = Mesh5;
Mesh9 = Mesh5;
Mesh10 = Mesh5;
Mesh11 = Mesh5;
Mesh12 = Mesh5;
Mesh_all = Matrix_Assembly_1(Mesh1,Mesh2,Mesh3,Mesh4,Mesh5,Mesh6,Mesh7,Mesh8,Mesh9,Mesh10,Mesh11,Mesh12);
% writematrix(double(subs(Mesh_all,t,0)),'Mesh_all.xls');
%%
%%返回轴单元1、2、3和4的阻尼矩阵
Cesh1 = ShaftElementDamping(0,Lesh1,FAI,Wx,Wy,Wz,Form_esh1_u,Form_esh1_v,Form_esh1_w,Form_esh1_xita,Form_esh1_lamuda,Form_esh1_posai,ROUeshi,Sesh1,I1);
% % writematrix(double(subs(Cesh1,t,0)),'Cesh1.xls');
Cesh2 = Cesh1;
Cesh3 = Cesh1;
Cesh4 = Cesh1;
Cesh5 = ShaftElementDamping(0,Lesh2,FAI,Wx,Wy,Wz,Form_esh2_u,Form_esh2_v,Form_esh2_w,Form_esh2_xita,Form_esh2_lamuda,Form_esh2_posai,ROUeshi,Sesh2,I2);
% writematrix(double(subs(Cesh5,t,0)),'Cesh3.xls');
Cesh6 = Cesh5;
Cesh7 = Cesh5;
Cesh8 = Cesh5;
Cesh9 = Cesh5;
Cesh10 = Cesh5;
Cesh11 = Cesh5;
Cesh12 = Cesh5;
Cesh_all = Matrix_Assembly_1(Cesh1,Cesh2,Cesh3,Cesh4,Cesh5,Cesh6,Cesh7,Cesh8,Cesh9,Cesh10,Cesh11,Cesh12);
% Cesh_all = zeros(30,30);
% writematrix(double(subs(Cesh_all,t,0)),'Cesh_all.xls');
%%
%%返回轴单元1、2、3和4的刚度矩阵
Kesh1 = ShaftElementStiffness(0,Lesh1,l,d_FAI,d_FAI_2,Wx,d_Wx,Wy,d_Wy,Wz,d_Wz,Form_esh1_u,Form_esh1_v,Form_esh1_w,Form_esh1_xita,Form_esh1_lamuda,Form_esh1_posai,ROUeshi,Sesh1,I1,Eeshi,Geshi,k);
% writematrix(double(subs(Kesh1,t,0)),'Kesh1.xls');
Kesh2 = Kesh1;
Kesh3 = Kesh1;
Kesh4 = Kesh1;
Kesh5 = ShaftElementStiffness(0,Lesh2,l,d_FAI,d_FAI_2,Wx,d_Wx,Wy,d_Wy,Wz,d_Wz,Form_esh2_u,Form_esh2_v,Form_esh2_w,Form_esh2_xita,Form_esh2_lamuda,Form_esh2_posai,ROUeshi,Sesh2,I2,Eeshi,Geshi,k);
% writematrix(double(subs(Kesh5,t,0)),'Kesh3.xls');
Kesh6 = Kesh5;
Kesh7 = Kesh5;
Kesh8 = Kesh5;
Kesh9 = Kesh5;
Kesh10 = Kesh5;
Kesh11 = Kesh5;
Kesh12 = Kesh5;
Kesh_all = Matrix_Assembly_1(Kesh1,Kesh2,Kesh3,Kesh4,Kesh5,Kesh6,Kesh7,Kesh8,Kesh9,Kesh10,Kesh11,Kesh12);
% writematrix(double(subs(Kesh_all,t,0)),'Kesh_all.xls');
%%
%%返回轴单元1、2、3和4的惯性力
Fesh1_lamuda = ShaftElementForces_of_RotaryInertia(0,Lesh1,d_FAI_2,Form_esh1_lamuda,ROUeshi,I1);
Fesh2_lamuda = Fesh1_lamuda;
Fesh3_lamuda = Fesh1_lamuda;
Fesh4_lamuda = Fesh1_lamuda;
Fesh5_lamuda = ShaftElementForces_of_RotaryInertia(0,Lesh2,d_FAI_2,Form_esh2_lamuda,ROUeshi,I2);
Fesh6_lamuda = Fesh5_lamuda;
Fesh7_lamuda = Fesh5_lamuda;
Fesh8_lamuda = Fesh5_lamuda;
Fesh9_lamuda = Fesh5_lamuda;
Fesh10_lamuda = Fesh5_lamuda;
Fesh11_lamuda = Fesh5_lamuda;
Fesh12_lamuda = Fesh5_lamuda;
Fesh_lamuda_all = Matrix_Assembly_2(Fesh1_lamuda,Fesh2_lamuda,Fesh3_lamuda,Fesh4_lamuda,Fesh5_lamuda,Fesh6_lamuda,Fesh7_lamuda,Fesh8_lamuda,Fesh9_lamuda,Fesh10_lamuda,Fesh11_lamuda,Fesh12_lamuda);
% writematrix(double(subs(Fesh_lamuda_all,t,0)),'Fesh_lamuda_all.xls');
%%
%%返回轴单元1、2、3和4的由支撑运动产生的力
Fesh1_su = ShaftElementForces_of_support(0,Lesh1,Lesh1,d_FAI,l,Wx,d_Wx,Wy,d_Wy,Wz,d_Wz,Form_esh1_u,Form_esh1_v,Form_esh1_w,Form_esh1_xita,Form_esh1_lamuda,Form_esh1_posai,ROUeshi,Sesh1,I1,Xo,d_Xo,d_Xo_2,Yo,d_Yo,d_Yo_2,Zo,d_Zo,d_Zo_2);
Fesh2_su = Fesh1_su;
Fesh3_su = Fesh1_su;
Fesh4_su = Fesh1_su;
Fesh5_su = ShaftElementForces_of_support(0,Lesh2,Lesh2,d_FAI,l,Wx,d_Wx,Wy,d_Wy,Wz,d_Wz,Form_esh2_u,Form_esh2_v,Form_esh2_w,Form_esh2_xita,Form_esh2_lamuda,Form_esh2_posai,ROUeshi,Sesh2,I2,Xo,d_Xo,d_Xo_2,Yo,d_Yo,d_Yo_2,Zo,d_Zo,d_Zo_2);
Fesh6_su = Fesh5_su;
Fesh7_su = Fesh5_su;
Fesh8_su = Fesh5_su;
Fesh9_su = Fesh5_su;
Fesh10_su = Fesh5_su;
Fesh11_su = Fesh5_su;
Fesh12_su = Fesh5_su;
Fesh_su_all = Matrix_Assembly_2(Fesh1_su,Fesh2_su,Fesh3_su,Fesh4_su,Fesh5_su,Fesh6_su,Fesh7_su,Fesh8_su,Fesh9_su,Fesh10_su,Fesh11_su,Fesh12_su);
%%
%%返回轴单元1、2、3和4的重力
Weight_esh1 = ShaftElementForces_of_Weight(0,Lesh1,beta,gama,Form_esh1_u,Form_esh1_v,Form_esh1_w,ROUeshi,Sesh1);
% writematrix(double(subs(Wegit_esh1,t,0)),'Wegit_esh1.xls');
Weight_esh2 = Weight_esh1;
Weight_esh3 = Weight_esh1;
Weight_esh4 = Weight_esh1;
Weight_esh5 = ShaftElementForces_of_Weight(0,Lesh2,beta,gama,Form_esh2_u,Form_esh2_v,Form_esh2_w,ROUeshi,Sesh2);
% writematrix(double(subs(Wegit_esh5,t,0)),'Wegit_esh5.xls');
Weight_esh6 = Weight_esh5;
Weight_esh7 = Weight_esh5;
Weight_esh8 = Weight_esh5;
Weight_esh9 = Weight_esh5;
Weight_esh10 = Weight_esh5;
Weight_esh11 = Weight_esh5;
Weight_esh12 = Weight_esh5;
% Weight_esh1 = [0;0.736071731703000;0;0;0;0;0;0.736071731703000;0;0;0;0];
% Weight_esh2 = Weight_esh1;
% Weight_esh3 = [0;0.183937882590000;0;0;0;0;0;0.183937882590000;0;0;0;0];
% Weight_esh4 = Weight_esh3;
Weight_all = Matrix_Assembly_2(Weight_esh1,Weight_esh2,Weight_esh3,Weight_esh4,Weight_esh5,Weight_esh6,Weight_esh7,Weight_esh8,Weight_esh9,Weight_esh10,Weight_esh11,Weight_esh12);
% writematrix(double(subs(Wegit_all,t,0)),'Wegit_all.xls');
%%改变转子放置状态，从水平钻进变成垂直钻进
% Weight_esh1 = [0;0.669843420592500;0;0;0;0;0;0.669843420592500;0;0;0;0];
% Weight_esh2 = Weight_esh1;
% Weight_esh3 = [0;0.306284443888500;0;0;0;0;0;0.3062844438885000;0;0;0;0];
% Weight_esh4 = Weight_esh3;
% Weight_all = Matrix_Assembly_2(Weight_esh1,Weight_esh2,Weight_esh3,Weight_esh4);
%%
%%求解轴承1和2的轴承反力矩阵、轴承的初始位置矩阵
% [F_be,DETA_be] = Force_rolling_bearing(double(subs(Weight_all,t,0)),Lesh1,Lesh2,k_be1,k_be2);
%%
%%返回质量不平衡矩阵
A = zeros(6,6);
B = zeros(6,1);
Memu = blkdiag(A,A,A,A,A,A,A,A,MassUnbalanceElementMass(Mmu,Rmu,x_,z_),A,A,A,A);%返回质量不平衡单元质量矩阵
Cemu = blkdiag(A,A,A,A,A,A,A,A,MassUnbalanceElementDamping(d_FAI,Mmu,x_,z_,Wx,Wy,Wz),A,A,A,A);%返回质量不平衡单元阻尼矩阵
Kemu = blkdiag(A,A,A,A,A,A,A,A,MassUnbalanceElementStiffness(d_FAI,d_FAI_2,Rmu,Mmu,x_,z_,Kuu,Kuv,Kuw,Kuxita,Kulamuda,Kuposai,Kvu,Kvv,Kvw,Kvlamuda,Kwu,Kwv,Kww,Kwxita,Kwlamuda,Kwposai,Kxitaxita,Kxitalamuda,Klamudaxita,Klamudalamuda,Kposailamuda,Kposaiposai,Klamudaposai),A,A,A,A);%返回质量不平衡单元刚度矩阵
Femu = vertcat(B,B,B,B,B,B,B,B,MassUnbalanceElementForces_of_RotaryInertia(d_FAI,d_FAI_2,Mmu,Rmu,x_,z_),B,B,B,B);%返回质量不平衡单元惯性力矩阵
Femu_su = vertcat(B,B,B,B,B,B,B,B,MassUnbalanceElementForces_of_support(d_FAI,d_Xo,d_Yo,d_Zo,d_Xo_2,d_Yo_2,d_Zo_2,d_Wx,d_Wy,d_Wz,Mmu,Ymu,Xo,Yo,Zo,Wx,Wy,Wz,x_,z_),B,B,B,B);
%%
M_ro = Mesh_all+Memu;
K_ro = Kesh_all+K_be_all+Kemu;
C_ro = Cesh_all+Cemu;
F_ro = Fesh_lamuda_all+Fesh_su_all+Weight_all+Femu+Femu_su;%组合质量不平衡矩阵至总矩阵