function OutputName = Recognition(TestImage, m_database, V_PCA, V_Fisher, ProjectedImages_Fisher)

Train_Number = size(ProjectedImages_Fisher,2);
%%%%%%%%%%%%%%%%%%%%%%%% Extracting the FLD features from test image
InputImage = TestImage;
    InputImage(:,:,1)=histeq(InputImage(:,:,1));
    InputImage(:,:,2)=histeq(InputImage(:,:,2));
    InputImage(:,:,3)=histeq(InputImage(:,:,3));
temp = InputImage(:,:,1);

[irow icol] = size(temp);
InImage = reshape(temp',irow*icol,1);
Difference = double(InImage)-m_database; % Centered test image
ProjectedTestImage = V_Fisher' * V_PCA' * Difference; % Test image feature vector

%%%%%%%%%%%%%%%%%%%%%%%% Calculating Euclidean distances 
% Euclidean distances between the projected test image and the projection
% of all centered training images are calculated. Test image is
% supposed to have minimum distance with its corresponding image in the
% training database.

Euc_dist = [];
for i = 1 : Train_Number
    q = ProjectedImages_Fisher(:,i);
    temp = ( norm( ProjectedTestImage - q ) )^2;
    Euc_dist = [Euc_dist temp];
end
display(Euc_dist);

[Euc_dist_min , Recognized_index] = min(Euc_dist);
display(Euc_dist_min);
if Euc_dist_min>(0.65)*1.0e+016
    display('No match found')
else
    display('Match found');
end    
OutputName = strcat(int2str(Recognized_index),'.jpg');
