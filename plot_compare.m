%% plot_compare.m  无钻压(Newmark_withHSFD) 与 有钻压(Newmark_withHSFD_WOB) 结果对照
% 用法：直接运行即可（不依赖 Rotor_Assembly，不会改动工作区里的符号变量）
% 若无钻压结果是用 Newmark_withHSFD_WOB 且 use_WOB=false 跑的（8列），把 f0 改成对应文件名即可。

%% ======== 参数 ========
f0 = 'OutputwithHSFD-1585.2.xlsx';   % 无钻压（Newmark_withHSFD 输出，7列）
f1 = 'OutputwithHSFD_WOB.xlsx';      % 有钻压（Newmark_withHSFD_WOB 输出，8列）
WOB    = 100;          % 钻压 (N)，与计算时一致
Nspeed = 1585.2;       % 转速 (rad/s)
kax    = 5*2.0713e6;   % 节点13轴向弹簧刚度，按 K_rolling_bearing_node_13 修改
E = 210e9;  S1 = 314.16e-6;  S2 = 72.38e-6;  L1 = 4*0.027575;  L2 = 8*0.027475;
Tw_wave = 0.02;        % 稳态波形/轨迹窗口 (s)
Tw_spec = 0.5;         % 频谱窗口上限 (s)
Tw_ss   = 0.1;         % 稳态统计窗口上限 (s)
%% =====================

D0 = readmatrix(f0);  D0 = D0(isfinite(D0(:,1)),:);
D1 = readmatrix(f1);  D1 = D1(isfinite(D1(:,1)),:);
T0 = D0(:,1);  T1 = D1(:,1);
has_ax0 = size(D0,2) >= 8;       % 无钻压文件是否含轴向位移列

c0 = [0 0.447 0.741];            % 无钻压：蓝
c1 = [0.850 0.325 0.098];        % 有钻压：红
nm0 = '无钻压';
nm1 = sprintf('钻压 %g N', WOB);

% 列：1 T, 2 节点9 x, 3 节点9 z, 4 节点13 x, 5 节点13 z, 6 轴承力x, 7 轴承力z, 8 钻头轴向位移
r13_0 = hypot(D0(:,4), D0(:,5));  r13_1 = hypot(D1(:,4), D1(:,5));
r9_0  = hypot(D0(:,2), D0(:,3));  r9_1  = hypot(D1(:,2), D1(:,3));
Fb0   = hypot(D0(:,6), D0(:,7));  Fb1   = hypot(D1(:,6), D1(:,7));

dur0 = T0(end) - T0(1);  dur1 = T1(end) - T1(1);
if abs(dur0 - dur1) > 0.05*max(dur0, dur1)
    warning('两组数据时长不同（%.3g s vs %.3g s），稳态对比时请留意瞬态影响。', dur0, dur1);
end

%% 图1：钻头轴向位移
u_static = WOB*(L1/(E*S1) + L2/(E*S2) + 1/kax);
figure(1); clf; hold on; grid on
plot(T1, D1(:,8)*1e6, 'Color', c1, 'LineWidth', 1.2, 'DisplayName', nm1);
if has_ax0
    plot(T0, D0(:,8)*1e6, 'Color', c0, 'LineWidth', 1.2, 'DisplayName', nm0);
else
    disp('无钻压文件没有轴向位移列，图1只画有钻压曲线。');
end
yline(u_static*1e6, '--k', 'DisplayName', '理论静态值(有钻压)');
xlabel('t / s'); ylabel('钻头节点轴向位移 / \mum'); title('图1 钻头轴向位移');
legend('Location', 'best');

%% 图2：横向振幅与轴承力
figure(2); clf
Q0 = {r13_0*1e9, r9_0*1e9, Fb0*1e3};
Q1 = {r13_1*1e9, r9_1*1e9, Fb1*1e3};
yl = {'节点13 振幅 / nm', '节点9 振幅 / nm', '轴承力幅值 / mN'};
for k = 1:3
    subplot(3,1,k); hold on; grid on
    plot(T0, Q0{k}, 'Color', c0, 'LineWidth', 1);
    plot(T1, Q1{k}, 'Color', c1, 'LineWidth', 1);
    ylabel(yl{k});
    if k == 1, title('图2 振幅与轴承力'); legend(nm0, nm1, 'Location', 'best'); end
end
xlabel('t / s');

%% 图3：稳态波形与轨迹（各自最后 Tw_wave，时间轴取相对时间便于叠加）
w0 = T0 > T0(end) - Tw_wave;   w1 = T1 > T1(end) - Tw_wave;
s0 = (T0(w0) - T0(find(w0,1)))*1e3;   s1 = (T1(w1) - T1(find(w1,1)))*1e3;   % ms
figure(3); clf
subplot(2,2,1); hold on; grid on
plot(s0, D0(w0,4)*1e9, 'Color', c0, 'LineWidth', 1);
plot(s1, D1(w1,4)*1e9, 'Color', c1, 'LineWidth', 1);
xlabel('相对时间 / ms'); ylabel('x / nm'); title('图3a 节点13 x向波形'); legend(nm0, nm1, 'Location', 'best');
subplot(2,2,2); hold on; grid on
plot(D0(w0,4)*1e9, D0(w0,5)*1e9, 'Color', c0, 'LineWidth', 1);
plot(D1(w1,4)*1e9, D1(w1,5)*1e9, 'Color', c1, 'LineWidth', 1);
axis equal; xlabel('x / nm'); ylabel('z / nm'); title('图3b 节点13 轨迹');
subplot(2,2,3); hold on; grid on
plot(s0, D0(w0,2)*1e9, 'Color', c0, 'LineWidth', 1);
plot(s1, D1(w1,2)*1e9, 'Color', c1, 'LineWidth', 1);
xlabel('相对时间 / ms'); ylabel('x / nm'); title('图3c 节点9 x向波形');
subplot(2,2,4); hold on; grid on
plot(D0(w0,2)*1e9, D0(w0,3)*1e9, 'Color', c0, 'LineWidth', 1);
plot(D1(w1,2)*1e9, D1(w1,3)*1e9, 'Color', c1, 'LineWidth', 1);
axis equal; xlabel('x / nm'); ylabel('z / nm'); title('图3d 节点9 轨迹');

%% 图4：频谱（两组使用相同的窗口长度，保证频率分辨率一致）
Tw = min([Tw_spec, dur0, dur1]);
figure(4); clf
nodes = {4, '节点13 x向'; 2, '节点9 x向'};
for k = 1:2
    [fa, Xa] = amp_spec(T0, D0(:,nodes{k,1}), Tw);
    [fb, Xb] = amp_spec(T1, D1(:,nodes{k,1}), Tw);
    subplot(2,1,k); hold on; grid on
    semilogy(fa, Xa, 'Color', c0, 'LineWidth', 1);
    semilogy(fb, Xb, 'Color', c1, 'LineWidth', 1);
    set(gca, 'YScale', 'log');
    xline(Nspeed/2/pi, '--k', '转速频率');
    xlim([0 1500]);
    ylabel('幅值 / m'); title(sprintf('图4%c %s 频谱（窗口 %.3g s）', 'a'+k-1, nodes{k,2}, Tw));
    if k == 1, legend(nm0, nm1, 'Location', 'northeast'); end
end
xlabel('频率 / Hz');

%% 数值汇总（各自最后 min(Tw_ss, 一半时长)）
wss0 = min(Tw_ss, 0.5*dur0);  wss1 = min(Tw_ss, 0.5*dur1);
sm = @(T, x, Tw) mean(x(T > T(end) - Tw));
rd = @(T, r, Tw) 100*(max(r(T > T(end)-Tw)) - min(r(T > T(end)-Tw)))/mean(r(T > T(end)-Tw));
a13 = [sm(T0,r13_0,wss0), sm(T1,r13_1,wss1)];
a9  = [sm(T0,r9_0, wss0), sm(T1,r9_1, wss1)];
fb  = [sm(T0,Fb0,  wss0), sm(T1,Fb1,  wss1)];
fprintf('\n%-18s %14s %14s %10s\n', '', nm0, nm1, '有/无');
fprintf('%-18s %14.4e %14.4e %10.3f\n', '节点13 振幅 (m)', a13(1), a13(2), a13(2)/a13(1));
fprintf('%-18s %14.4e %14.4e %10.3f\n', '节点9  振幅 (m)', a9(1),  a9(2),  a9(2)/a9(1));
fprintf('%-18s %14.4e %14.4e %10.3f\n', '轴承力幅值 (N)',   fb(1),  fb(2),  fb(2)/fb(1));
fprintf('%-18s %14.2f %14.2f\n', '节点13 圆度偏差(%)', rd(T0,r13_0,wss0), rd(T1,r13_1,wss1));
fprintf('统计窗口：无钻压 %.3g s，有钻压 %.3g s\n', wss0, wss1);
fprintf('是否有 NaN/Inf：无钻压 %d，有钻压 %d\n', any(~isfinite(D0(:))), any(~isfinite(D1(:))));
if has_ax0
    fprintf('钻头轴向位移末值：无钻压 %.3e m，有钻压 %.3e m，理论静态值 %.3e m\n', D0(end,8), D1(end,8), u_static);
else
    fprintf('钻头轴向位移末值：有钻压 %.3e m，理论静态值 %.3e m\n', D1(end,8), u_static);
end

%% 局部函数（脚本末尾）
function [f, X] = amp_spec(T, x, Tw)
    w = T > T(end) - Tw;
    x = x(w);  x = x(:) - mean(x);  m = numel(x);
    fs  = 1/mean(diff(T));
    win = 0.5 - 0.5*cos(2*pi*(0:m-1)'/(m-1));
    X = abs(fft(x.*win))*2/sum(win);      % 按窗函数相干增益归一化，峰值即真实幅值
    f = (0:m-1)'*fs/m;
    h = floor(m/2);
    f = f(1:h);  X = X(1:h);
end
