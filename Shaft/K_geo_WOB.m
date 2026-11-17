function Kg = K_geo_WOB(Form1_u, Form1_w, L1, Form2_u, Form2_w, L2, l, bit_node, support_node)
%K_geo_WOB  单位轴向拉力下的几何刚度矩阵（78x78 数值矩阵）
% 轴向力 N（拉为正）使横向刚度改变：K_total = K + N*Kg；钻压为压力，N = -WOB。
% 受轴向力的单元：钻头节点与轴向支撑节点之间的所有单元，其余单元轴向力为0。
% 输入：Form1_*、L1  粗轴段(单元1~4)的形状函数和单元长度 (Form_esh1_u, Form_esh1_w, Lesh1)
%       Form2_*、L2  细轴段(单元5~12)的形状函数和单元长度 (Form_esh2_u, Form_esh2_w, Lesh2)
%       l            符号变量
% 积分式：Kg_e = ∫( u'^T u' + w'^T w' ) dy
ke1 = double(int(diff(Form1_u,l).'*diff(Form1_u,l) + diff(Form1_w,l).'*diff(Form1_w,l), l, 0, L1));
ke2 = double(int(diff(Form2_u,l).'*diff(Form2_u,l) + diff(Form2_w,l).'*diff(Form2_w,l), l, 0, L2));
kk = {ke1,ke1,ke1,ke1,ke2,ke2,ke2,ke2,ke2,ke2,ke2,ke2};
lo = min(bit_node, support_node);
hi = max(bit_node, support_node);
for e = 1:12
    if e < lo || e >= hi        % 单元e连接节点e和e+1
        kk{e} = zeros(12,12);
    end
end
Kg = Matrix_Assembly_1(kk{:});
end
