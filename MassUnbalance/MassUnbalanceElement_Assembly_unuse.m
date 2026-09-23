%%质量不平衡启动器，还未输入具体变量，全部变量用符号变量表示
clear all
clc
syms t %t表征特定时间
%%
%%输入质量不平衡基本参数,转轴转速和参考系R的运动
%质量不平衡用集中质量Mmu来模拟，单位kg，距离轴形心距离Rmu，与Oz轴初始相位角为epsilon_mu，绝对位置涉及坐标Ymu
Mmu = 0.001;
Ymu = 0;
epsilon_mu = pi/6;
Rmu = 4.4*10^(-3);
Xl_mu = Rmu*sin(epsilon_mu);
Zl_mu = Rmu*cos(epsilon_mu);%质量不平衡位置坐标
%%
%%输入转速和参考系R的运动
%%每次此单元的参数都要对O_F
FAI = 996.5*t; %转轴转速(临界转速)
afa =pi*9^(-1)*sin(200*pi*t);%绕Z轴摆动
beta = 0*t;%绕X轴
gama = 0*t;%绕Y轴
Xog = 0*t;
Yog = 0*t;
Zog = 0*t;
%%
Wx = -diff(afa)*cos(beta)*sin(gama)+diff(beta)*cos(gama);%[beta,0]是为了防止缩维
Wy = diff(afa)*sin(beta)+diff(gama);
Wz = diff(afa)*cos(beta)*cos(gama)+diff(beta)*sin(gama);
%%
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
%%返回质量不平衡单元刚度阵系数
[Kuu,Kuv,Kuw,Kuxita,Kulamuda,Kuposai,Kvu,Kvv,Kvw,Kvlamuda,Kwu,Kwv,Kww,Kwxita,Kwlamuda,Kwposai,Kxitaxita,Kxitalamuda,Klamudaxita,Klamudalamuda,Klamudaposai,Kposailamuda,Kposaiposai] = gangduxishu(d_FAI,d_Xo,d_Yo,d_Zo,d_Wx,d_Wy,d_Wz,d_Xo_2,d_Yo_2,d_Zo_2,Wx,Wy,Wz,Rmu,x_,z_,Zo,Xo,Yo,Ymu);
%%
A = zeros(6,6);
B = zeros(6,1);
Memu = blkdiag(A,A,A,MassUnbalanceElementMass(Mmu,Rmu,x_,z_),A);%返回质量不平衡单元质量矩阵
Cemu = blkdiag(A,A,A,MassUnbalanceElementDamping(d_FAI,Mmu,x_,z_,Wx,Wy,Wz),A);%返回质量不平衡单元阻尼矩阵
Kemu = blkdiag(A,A,A,MassUnbalanceElementStiffness(d_FAI,d_FAI_2,Rmu,Mmu,x_,z_,Kuu,Kuv,Kuw,Kuxita,Kulamuda,Kuposai,Kvu,Kvv,Kvw,Kvlamuda,Kwu,Kwv,Kww,Kwxita,Kwlamuda,Kwposai,Kxitaxita,Kxitalamuda,Klamudaxita,Klamudalamuda,Kposailamuda,Kposaiposai,Klamudaposai),A);%返回质量不平衡单元刚度矩阵
Femu = vertcat(B,B,B,MassUnbalanceElementForces_of_RotaryInertia(d_FAI,d_FAI_2,Mmu,Rmu,x_,z_),B);%返回质量不平衡单元惯性力矩阵
Femu_su = vertcat(B,B,B,MassUnbalanceElementForces_of_support(d_FAI,d_Xo,d_Yo,d_Zo,d_Xo_2,d_Yo_2,d_Zo_2,d_Wx,d_Wy,d_Wz,Mmu,Ymu,Xo,Yo,Zo,Wx,Wy,Wz,x_,z_),B);