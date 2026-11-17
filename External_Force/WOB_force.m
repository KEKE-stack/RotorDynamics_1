function [F_wob, s] = WOB_force(T, WOB, t_ramp, bit_node, support_node)
%WOB_force  钻压的等效节点力，直接作用在钻头节点的轴向自由度
% 输入：T            当前时刻 (s)
%       WOB          钻压大小 (N)，取正数
%       t_ramp       加载时间 (s)，平滑从0加到WOB；0 表示阶跃加载
%       bit_node     钻头所在节点 (1 或 13)
%       support_node 轴向支撑所在节点（模型里轴向刚度在哪个节点就填哪个）
% 输出：F_wob 78x1 力向量；s 加载系数(0~1)，几何刚度要乘同一个 s
% 方向：地层对钻头的反力指向钻柱内部（由钻头指向支撑端），使钻柱受压。
%       y轴由节点1指向节点13，钻头在节点1时力为 +y，钻头在节点13时力为 -y。
if t_ramp > 0
    r = min(T/t_ramp, 1);
    s = r^2*(3 - 2*r);
else
    s = 1;
end
dir = sign(support_node - bit_node);
F_wob = zeros(78,1);
F_wob(6*(bit_node-1) + 2) = dir*WOB*s;   % 每个节点6个自由度，第2个是轴向 v
end
