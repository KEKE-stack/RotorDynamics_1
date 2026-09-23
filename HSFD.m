function c_HSFD = HSFD(velocity_vector)
    %新的阻尼系数拟合表达式是为C=1.662*v^2+26.39*v+494.5(N/(m/s)，F=CV假设阻尼系数和速度有关，是各向同性的
    v_mag = sqrt((velocity_vector(73))^2 + (velocity_vector(75))^2);%横向振动速度
    c_0 = 2500;%初值495.5
    c_isotropic = c_0 + 26.39 * v_mag + 16.62 * (v_mag)^2;%拟合阻尼系数
    c_HSFD = blkdiag(zeros(72,72),C_rolling_bearing(c_isotropic));
end
%Isight 参数计算