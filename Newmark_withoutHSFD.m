%%初始化，计算并输出初始数据
T = 0;
dt = 0.00001;
%i = 1;
j = 0;

DETA_ro_0 = zeros(78,1);%位移
DETA_ro_1 = zeros(78,1);%速度

F_ro_T = double(subs(F_ro,t,T));%外力项，由绕y轴旋转的惯性力、支撑运动引起的惯性力和重力。R = subs(S, old, new) 利用new的值代替符号表达式中old的值
K_ro_T = double(subs(K_ro,t,T));%初始刚度项
C_ro_T = double(subs(C_ro,t,T));%初始化阻尼，这个阻尼矩阵目前没有包括阻尼器的阻尼
M_ro_T = double(subs(M_ro,t,T));%初始化质量矩阵

DETA_ro_2  = double(M_ro_T^(-1) * (F_ro_T - C_ro_T * DETA_ro_1 - K_ro_T * DETA_ro_0));%加速度
F_be_output = -K_be_all * DETA_ro_0;%力
Output= [T DETA_ro_0(49) DETA_ro_0(51) DETA_ro_0(73) DETA_ro_0(75)];
writematrix(Output,'OutputwithoutHSFD-480.xlsx');%保存初始状态
%%
%%选取参数o、p,计算积分常数
o = 0.6;
%p = 1/6;
p = 0.25*(o+0.5)^2;
A1 = 1/(p*dt^2);
A2 = o/(p*dt);
A3 = 1/(p*dt);
A4 = (1/(2*p))-1;
A5 = 0.5*dt*(o/p-2);
A6 = (o/p)-1;
%%
Output = zeros(500,5);
for T = dt:dt:10
    F_ro_T = double(subs(F_ro,t,T));
    K_ro_T = double(subs(K_ro,t,T));
    C_ro_T = double(subs(C_ro,t,T));
    %C_ro_HSFD = C_ro_T + HSFD(DETA_ro_1);
    M_ro_T = double(subs(M_ro,t,T));
    %%有效刚度矩阵
    K_ = K_ro_T + A1 * M_ro_T + A2 * C_ro_T;
    %下一个时刻的有效载荷向量
    F_dt = F_ro_T + M_ro_T*(A1*DETA_ro_0 + A3*DETA_ro_1 + A4*DETA_ro_2) + C_ro_T*(A2*DETA_ro_0 + A6*DETA_ro_1 + A5*DETA_ro_2);
    %下一个时刻的位移
    DETA_ro_0_dt = double((K_^-1)*F_dt);
    %下一个时刻的加速度和速度
    DETA_ro_2_dt = double((DETA_ro_0_dt-DETA_ro_0)/(p*dt^2)-DETA_ro_1/(p*dt)-(1/(2*p)-1)*DETA_ro_2);
    DETA_ro_1_dt = double(DETA_ro_1+(1-o)*dt*DETA_ro_2+o*dt*DETA_ro_2_dt);
    %输出下一时刻数据
    DETA_ro_0 = DETA_ro_0_dt;
    DETA_ro_1 = DETA_ro_1_dt;
    DETA_ro_2 = DETA_ro_2_dt;
    F_be_output = -K_be_all * DETA_ro_0;
    %设置每200个步数输出一次 
    %if rem(i,200)==0
    j = j+1;
    Output(j,:) = [T DETA_ro_0(49) DETA_ro_0(51) DETA_ro_0(73) DETA_ro_0(75)];
    %设置每5次输出写入excel一次
    if rem(j,500)==0
    writematrix(Output,'OutputwithoutHSFD-480.xlsx','writeMode','append');%将矩阵 M1 写入一个电子表格文件 M.xls。writematrix(M1,'M.xls')。将矩阵 M2 中的数据追加到电子表格文件中现有数据的下方。writematrix(M2,'M.xls','WriteMode','append')
    Output = zeros(500,5);
    j = 0;
    end
    %end
    %i = i+1;
end