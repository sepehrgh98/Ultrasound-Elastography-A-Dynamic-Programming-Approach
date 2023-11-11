clc
clear all;


%%%%%%%%%%%% Parameters for 1D Delta
%Please specify the margins of displacement
d_max=1;
d_min=0;

%Please put a proper displacement here(D is a vector of all displacemets)
D=ones(2,1);

if any(D<d_min) || any(D>d_max)
error('There is a number in the displacemnt vector that is not the allowed displacement! check your displacement vector or change d_min and d_max values.');
end
%%%%%%%%%%%% End of Parameters 1D

%%%%%%%%%%%% Parameters for 2D Delta
%Please specify the margins of displacement
da_max=1;
da_min=0;

dl_max=1;
dl_min=0;

%Please put a proper displacement here(D is a matrix of all displacemets)
D=ones(2);

for i=1:size(D,1)
    if any(D(:,i)<da_min) || any(D(:,i)>da_max)
        error('There is a number in the displacemnt vector that is not the allowed displacement! check your displacement vector or change da_min and da_max values.');
    end
end

for i=1:size(D,2)
    if any(D(i,:)<dl_min) || any(D(i,:)>dl_max)
        error('There is a number in the displacemnt vector that is not the allowed displacement! check your displacement vector or change dl_min and dl_max values.');
    end
end
%%%%%%%%%%%% End of Parameters 2D

%Example of Calculating Delta for 1D
%%%%%%%%%%%%%%%%
g=[1;2;3;4;5;6;7;8;9;10];
g_prime=[0;2;3;4;6;7;8;9;10;11;12];
D=[1;1;1;1;1;1;1;1;1];
delta_g=zeros(d_max-d_min+1,length(g));

for i=1:d_max-d_min+1
    for j=1:length(g)
        delta_g(j,i)=Delta_1_D(j, D(i), g, g_prime);
    end
end
delta_g
%%%%%%%%%%%%%%%% End of Example 1D


%Example of Calculating Delta for 2D
%%%%%%%%%%%%%%%%
g=[1,2,3;4,5,6;7,8,9];
g_prime=[0,2,3, 4;4,6,7, 8; 8,9,10, 11; 8,9,10, 11];
D=[1,1,1;1,1,1;1,1,1];
delta_g=zeros(size(g,1)*(da_max-da_min+1),size(g,2)*(dl_max-dl_min+1));

for i=1:size(g,2)
for j=1:dl_max-dl_min+1
    for l=1:da_max-da_min+1
        for k=1:size(g,1)
            delta_g(size(g,1)*(l-1)+k,(i-1)*(size(g,2))+j)=Delta_2_D(i,j, D(j,l), g, g_prime);
        end
    end
end
end
delta_g
%%%%%%%%%%%%%%%% End of Example 2D



% Functions
%%%%%%%%%%%%%%%%%%%%%%
%Delta function for 1D
function Delta_1D = Delta_1_D(j, d, g, g_prime)
Delta_1D = abs(g(j)-g_prime(j+d));
end

%Delta function for 2D
function Delta_2D = Delta_2_D(i, j, d, g, g_prime)
Delta_2D = abs(g(i,j)-g_prime(i,j+d));
end