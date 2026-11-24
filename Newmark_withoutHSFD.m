%%初始化，计算并输出初始数据
T = 0;
dt = 0.00001;
%i = 1;
out_file = 'OutputwithoutHSFD-480.xlsx';
time_steps = dt:dt:0.1;
N = numel(time_steps);

DETA_ro_0 = zeros(78,1);%位移
DETA_ro_1 = zeros(78,1);%速度

F_ro_T = F_fun(T);%外力项，由绕y轴旋转的惯性力、支撑运动引起的惯性力和重力。R = subs(S, old, new) 利用new的值代替符号表达式中old的值
K_ro_T = K_fun(T);%初始刚度项
C_ro_T = C_fun(T);%初始化阻尼，这个阻尼矩阵目前没有包括阻尼器的阻尼
M_ro_T = M_fun(T);%初始化质量矩阵

DETA_ro_2  = double(M_ro_T^(-1) * (F_ro_T - C_ro_T * DETA_ro_1 - K_ro_T * DETA_ro_0));%加速度
F_be_output = -K_be_all * DETA_ro_0;%力
Output = zeros(N+1,5);
Output(1,:) = [T DETA_ro_0(49) DETA_ro_0(51) DETA_ro_0(73) DETA_ro_0(75)];
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
% Time-based checkpoints use wall-clock seconds.
checkpoint_interval = 10 * 60;
checkpoint_file = [out_file(1:end-5) '.checkpoint.mat'];
checkpoint_settings = [dt N o p];
start_step = 1;
if exist('resume_newmark','var') && isequal(resume_newmark,true)
    [saved_step, saved_output, saved_state] = Newmark_load_checkpoint( ...
        checkpoint_file, checkpoint_settings, size(Output), numel(DETA_ro_0));
    Output(1:saved_step+1,:) = saved_output;
    T = saved_output(end,1);
    DETA_ro_0 = saved_state(:,1);
    DETA_ro_1 = saved_state(:,2);
    DETA_ro_2 = saved_state(:,3);
    start_step = saved_step + 1;
elseif isfile(checkpoint_file)
    % Replace an older run's checkpoint before starting a fresh run.
    Newmark_save_checkpoint(checkpoint_file, checkpoint_settings, 0, Output(1,:), ...
        [DETA_ro_0 DETA_ro_1 DETA_ro_2]);
end
checkpoint_timer = tic;
for step = start_step:N
    T = time_steps(step);
    F_ro_T = F_fun(T);
    K_ro_T = K_fun(T);
    C_ro_T = C_fun(T);
    %C_ro_HSFD = C_ro_T + HSFD(DETA_ro_1);
    M_ro_T = M_fun(T);
    %%有效刚度矩阵
    K_ = K_ro_T + A1 * M_ro_T + A2 * C_ro_T;
    %下一个时刻的有效载荷向量
    F_dt = F_ro_T + M_ro_T*(A1*DETA_ro_0 + A3*DETA_ro_1 + A4*DETA_ro_2) + C_ro_T*(A2*DETA_ro_0 + A6*DETA_ro_1 + A5*DETA_ro_2);
    %下一个时刻的位移
    DETA_ro_0_dt = K_ \ F_dt;
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
    Output(step+1,:) = [T DETA_ro_0(49) DETA_ro_0(51) DETA_ro_0(73) DETA_ro_0(75)];
    if step == N || toc(checkpoint_timer) >= checkpoint_interval
        Newmark_save_checkpoint(checkpoint_file, checkpoint_settings, step, ...
            Output(1:step+1,:), [DETA_ro_0 DETA_ro_1 DETA_ro_2]);
        checkpoint_timer = tic;
    end
end
writematrix(Output, out_file, 'WriteMode', 'overwritesheet');
