clear;
clc;
g = 1:130;
R = 5;
G = cell(3, 1);
G{1} = cell(3, 1);
G{2} = cell(2, 1);
G{3} = cell(3, 1);
G{1}{1} = reshape(g(1:15), 3, 5);
G{1}{2} = reshape(g(16:35), 4, 5);
G{1}{3} = reshape(g(36:60), 5, 5);
G{2}{1} = reshape(g(61:75), 3, 5);
G{2}{2} = reshape(g(76:90), 3, 5);
G{3}{1} = reshape(g(91:105), 3, 5);
G{3}{2} = reshape(g(106:120), 3, 5);
G{3}{3} = reshape(g(121:130), 2, 5);

x = cmtfac_fac_to_vec(G);

Z.size = [3, 4, 5, 3, 3, 2];
Z.modes = {[1, 2, 3], [1, 4], [1, 5, 6]};
Y = cmtfac_vec_to_fac(x, Z);