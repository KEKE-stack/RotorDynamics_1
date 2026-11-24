%% Newmark_withHSFD_WOB.m  带HSFD阻尼器 + 可选钻压(WOB)
% 使用方法：先运行 Rotor_Assembly（不要clear），再运行本脚本。
% use_WOB = false 时，结果与 Newmark_withHSFD 完全一致。

%% ======== 开关与参数 ========
use_WOB  = true;     % 总开关：是否施加钻压
use_Kgeo = true;     % 是否计入轴向压力对横向刚度的削弱（几何刚度）
WOB      = 100;      % 钻压 (N)，取正数
bit_node     = 1;    % 钻头所在节点（1 或 13，需要你确认）
support_node = 13;    % 轴向支撑所在节点（目前模型的轴向刚度在节点5的轴承上）
t_ramp   = 0.05;     % 钻压从0加到WOB的时间 (s)
dt       = 0.0001;   % 时间步长
T_end    = 1;        % 计算总时长 (s)
out_file = 'OutputwithHSFD_WOB.xlsx';
%% ============================

WOB_use = WOB*use_WOB;
bit_dof = 6*(bit_node-1) + 2;   % 钻头节点的轴向自由度
N = round(T_end/dt);

% 几何刚度（单位拉力），只算一次
if use_WOB && use_Kgeo
    Kg_unit = K_geo_WOB(Form_esh1_u, Form_esh1_w, Lesh1, Form_esh2_u, Form_esh2_w, Lesh2, l, bit_node, support_node);
else
    Kg_unit = zeros(78,78);
end

% 取矩阵：如果工作区有 matlabFunction 生成的 M_fun 等就用它（快），否则用 subs（慢）
if exist('M_fun','var') && exist('K_fun','var') && exist('C_fun','var') && exist('F_fun','var')
    getF = @(T) F_fun(T);  getK = @(T) K_fun(T);
    getC = @(T) C_fun(T);  getM = @(T) M_fun(T);
else
    getF = @(T) double(subs(F_ro,t,T));  getK = @(T) double(subs(K_ro,t,T));
    getC = @(T) double(subs(C_ro,t,T));  getM = @(T) double(subs(M_ro,t,T));
end

%% 初始化
T = 0;
DETA_ro_0 = zeros(78,1);   % 位移
DETA_ro_1 = zeros(78,1);   % 速度

[F_wob, s] = WOB_force(T, WOB_use, t_ramp, bit_node, support_node);
F_ro_T = getF(T) + F_wob;
K_ro_T = getK(T) - WOB_use*s*Kg_unit;
C_ro_HSFD = getC(T) + HSFD(DETA_ro_1);
M_ro_T = getM(T);

DETA_ro_2 = M_ro_T \ (F_ro_T - C_ro_HSFD*DETA_ro_1 - K_ro_T*DETA_ro_0);   % 加速度
F_be_output = -K_be_all*DETA_ro_0 - HSFD(DETA_ro_1)*DETA_ro_1;
% 列：T, 节点9 x, 节点9 z, 节点13 x, 节点13 z, 轴承力x, 轴承力z, 钻头节点轴向位移
Output = zeros(N+1,8);
Output(1,:) = [T DETA_ro_0(49) DETA_ro_0(51) DETA_ro_0(73) DETA_ro_0(75) F_be_output(73) F_be_output(75) DETA_ro_0(bit_dof)];

%% Newmark 积分常数
o = 0.6;
p = 0.25*(o+0.5)^2;
A1 = 1/(p*dt^2);
A2 = o/(p*dt);
A3 = 1/(p*dt);
A4 = (1/(2*p)) - 1;
A5 = 0.5*dt*(o/p - 2);
A6 = (o/p) - 1;

%% 时间积分
% Time-based checkpoints use wall-clock seconds.
checkpoint_interval = 10 * 60;
checkpoint_file = [out_file(1:end-5) '.checkpoint.mat'];
checkpoint_settings = [dt N o p use_WOB use_Kgeo WOB bit_node support_node t_ramp];
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
    T = step*dt;
    [F_wob, s] = WOB_force(T, WOB_use, t_ramp, bit_node, support_node);
    F_ro_T = getF(T) + F_wob;                    % 外力 + 钻压
    K_ro_T = getK(T) - WOB_use*s*Kg_unit;        % 刚度 + 几何刚度（压力时 N=-WOB）
    C_ro_HSFD = getC(T) + HSFD(DETA_ro_1);
    M_ro_T = getM(T);
    % 有效刚度矩阵与有效载荷
    K_ = K_ro_T + A1*M_ro_T + A2*C_ro_HSFD;
    F_dt = F_ro_T + M_ro_T*(A1*DETA_ro_0 + A3*DETA_ro_1 + A4*DETA_ro_2) ...
                  + C_ro_HSFD*(A2*DETA_ro_0 + A6*DETA_ro_1 + A5*DETA_ro_2);
    % 下一时刻位移、加速度、速度
    DETA_ro_0_dt = K_ \ F_dt;
    DETA_ro_2_dt = (DETA_ro_0_dt - DETA_ro_0)/(p*dt^2) - DETA_ro_1/(p*dt) - (1/(2*p) - 1)*DETA_ro_2;
    DETA_ro_1_dt = DETA_ro_1 + (1-o)*dt*DETA_ro_2 + o*dt*DETA_ro_2_dt;
    DETA_ro_0 = DETA_ro_0_dt;
    DETA_ro_1 = DETA_ro_1_dt;
    DETA_ro_2 = DETA_ro_2_dt;
    F_be_output = -K_be_all*DETA_ro_0 - HSFD(DETA_ro_1)*DETA_ro_1;
    % 记录并分批写入
    Output(step+1,:) = [T DETA_ro_0(49) DETA_ro_0(51) DETA_ro_0(73) DETA_ro_0(75) F_be_output(73) F_be_output(75) DETA_ro_0(bit_dof)];
    if step == N || toc(checkpoint_timer) >= checkpoint_interval
        Newmark_save_checkpoint(checkpoint_file, checkpoint_settings, step, ...
            Output(1:step+1,:), [DETA_ro_0 DETA_ro_1 DETA_ro_2]);
        checkpoint_timer = tic;
    end
end
writematrix(Output, out_file, 'WriteMode', 'overwritesheet');
disp(['计算完成，结果保存在 ' out_file]);
