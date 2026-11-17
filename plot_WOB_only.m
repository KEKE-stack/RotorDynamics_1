%% plot_WOB_only.m  只看有钻压这一次的结果（不需要无钻压数据）
f1     = 'OutputwithHSFD_WOB.xlsx';
WOB    = 100;         % 与计算时一致 (N)
Nspeed = 1585.2;      % 转速 (rad/s)
kax    = 5*2.0713e6;  % 节点13轴向弹簧刚度，按你改过的 K_rolling_bearing_node_13 修改

d = readmatrix(f1);
t = d(:,1);
% 列：1 T, 2 节点9 x, 3 节点9 z, 4 节点13 x, 5 节点13 z, 6 轴承力x, 7 轴承力z, 8 钻头轴向位移
r13 = hypot(d(:,4), d(:,5));    % 圆形涡动时半径=振幅
r9  = hypot(d(:,2), d(:,3));
Fb  = hypot(d(:,6), d(:,7));

%% 图1：钻压加载过程（钻头轴向位移）
E = 210e9;  S1 = 314.16e-6;  S2 = 72.38e-6;  L1 = 4*0.027575;  L2 = 8*0.027475;
u_static = WOB*(L1/(E*S1) + L2/(E*S2) + 1/kax);
figure(1); plot(t, d(:,8)*1e6); grid on; hold on
yline(u_static*1e6, '--r', '理论静态值');
xlabel('t / s'); ylabel('钻头节点轴向位移 / \mum'); title('图1 钻压加载过程')

%% 图2：横向振幅和轴承力随时间变化
figure(2)
subplot(3,1,1); plot(t, r13*1e9); grid on; ylabel('节点13 振幅 / nm'); title('图2 振幅与轴承力')
subplot(3,1,2); plot(t, r9*1e9);  grid on; ylabel('节点9 振幅 / nm')
subplot(3,1,3); plot(t, Fb*1e3);  grid on; ylabel('轴承力幅值 / mN'); xlabel('t / s')

%% 图3：稳态波形和轨迹（最后 20 ms）
w = t > t(end) - 0.02;
figure(3)
subplot(1,2,1); plot(t(w), d(w,4), '-o', t(w), d(w,5), '-s'); grid on
xlabel('t / s'); ylabel('位移 / m'); legend('x','z'); title('图3a 节点13 波形')
subplot(1,2,2); plot(d(w,4), d(w,5)); axis equal; grid on
xlabel('x / m'); ylabel('z / m'); title('图3b 节点13 轨迹')

%% 图4：频谱（最后 0.5 s，节点13 x 向）
fs = 1/(t(2)-t(1));
w5 = t > t(end) - 0.5;
x = d(w5,4) - mean(d(w5,4));  m = numel(x);
win = 0.5 - 0.5*cos(2*pi*(0:m-1)'/(m-1));
X = abs(fft(x.*win))*2/m;  f = (0:m-1)*fs/m;
figure(4); semilogy(f(1:floor(m/2)), X(1:floor(m/2))); hold on
xline(Nspeed/2/pi, '--r', '转速频率'); grid on; xlim([0 1500])
xlabel('频率 / Hz'); ylabel('幅值 / m'); title('图4 频谱')

%% 数值汇总
ws = t > t(end) - 0.1;
fprintf('节点13 稳态振幅 %.4e m，节点9 稳态振幅 %.4e m，轴承力幅值 %.4e N\n', mean(r13(ws)), mean(r9(ws)), mean(Fb(ws)));
fprintf('轨迹圆度偏差 %.2f %%\n', 100*(max(r13(ws)) - min(r13(ws)))/mean(r13(ws)));
fprintf('钻头轴向位移：末值 %.3e m，理论静态值 %.3e m\n', d(end,8), u_static);
fprintf('是否有 NaN/Inf：%d\n', any(~isfinite(d(:))));
