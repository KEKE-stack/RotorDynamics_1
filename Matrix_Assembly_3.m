function Matrix_all = Matrix_Assembly_3(Matrix_1,Matrix_2)
A = zeros(6,1);
Matrix_1 = vertcat(Matrix_1,A);
Matrix_2 = vertcat(A,Matrix_2);
Matrix_all = Matrix_1+Matrix_2;
end