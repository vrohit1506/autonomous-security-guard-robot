function [m_database V_PCA V_Fisher ProjectedImages_Fisher] = FisherfaceCore(T)

Class_number = ( size(T,2) ); % Number of classes (or persons)
Class_population = 1; % Number of images in each class
P = Class_population * Class_number; % Total number of training images

%%%%%%%%%%%%%%%%%%%%%%%% calculating the mean image 
m_database = mean(T,2); 

%%%%%%%%%%%%%%%%%%%%%%%% Calculating the deviation of each image from mean image
A = T - repmat(m_database,1,P);

%%%%%%%%%%%%%%%%%%%%%%%% Snapshot method of Eigenface algorithm
L = A'*A; % L is the surrogate of covariance matrix C=A*A'.
[V D] = eig(L); % Diagonal elements of D are the eigenvalues for both L=A'*A and C=A*A'.

%%%%%%%%%%%%%%%%%%%%%%%% Sorting and eliminating small eigenvalues
L_eig_vec = [];
for i = 1 : P%-Class_number 
    L_eig_vec = [L_eig_vec V(:,i)];
end

%%%%%%%%%%%%%%%%%%%%%%%% Calculating the eigenvectors of covariance matrix 'C'
V_PCA = A * L_eig_vec; % A: centered image vectors

%%%%%%%%%%%%%%%%%%%%%%%% Projecting centered image vectors onto eigenspace
% Zi = V_PCA' * (Ti-m_database)
ProjectedImages_PCA = [];
for i = 1 : P
    temp = V_PCA'*A(:,i);
    ProjectedImages_PCA = [ProjectedImages_PCA temp]; 
end

%%%%%%%%%%%%%%%%%%%%%%%% Calculating the mean of each class in eigenspace
m_PCA = mean(ProjectedImages_PCA,2); % Total mean in eigenspace
m = zeros(P,Class_number); 
Sw = zeros(P,P); % Initialization os Within Scatter Matrix
Sb = zeros(P,P); % Initialization of Between Scatter Matrix

for i = 1 : Class_number
    m(:,i) = mean( ( ProjectedImages_PCA(:,i) ), 2 )';    
    
    S  = zeros(P,P); 
   % for j = i : i
        S = S + (ProjectedImages_PCA(:,i)-m(:,i))*(ProjectedImages_PCA(:,i)-m(:,i))';
    %end
    
    Sw = Sw + S; % Within Scatter Matrix
    Sb = Sb + (m(:,i)-m_PCA) * (m(:,i)-m_PCA)'; % Between Scatter Matrix
end

%%%%%%%%%%%%%%%%%%%%%%%% Calculating Fisher discriminant basis's
% We want to maximise the Between Scatter Matrix, while minimising the
% Within Scatter Matrix. Thus, a cost function J is defined, so that this condition is satisfied.
[J_eig_vec, J_eig_val] = eig(Sb,Sw); % Cost function J = inv(Sw) * Sb
J_eig_vec = fliplr(J_eig_vec);

%%%%%%%%%%%%%%%%%%%%%%%% Eliminating zero eigens and sorting in descend order
for i = 1 : Class_number-1 
    V_Fisher(:,i) = J_eig_vec(:,i); % Largest (C-1) eigen vectors of matrix J
end

%%%%%%%%%%%%%%%%%%%%%%%% Projecting images onto Fisher linear space
% Yi = V_Fisher' * V_PCA' * (Ti - m_database) 
for i = 1 : Class_number*Class_population
    ProjectedImages_Fisher(:,i) = V_Fisher' * ProjectedImages_PCA(:,i);
end