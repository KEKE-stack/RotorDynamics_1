function y = K_rolling_bearing_node_13(k_be)
%rolling_bearing  
%1 
%此函数返回轴承节点的刚度矩阵
y = [k_be 0 0 0 0 0;
     0 0*k_be 0 0 0 0;
     0 0 k_be 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0;
     0 0 0 0 0 0];%已写完
end