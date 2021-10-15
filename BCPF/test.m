n = (0:9);
sn = clc([n;n]);
sn
function  s = clc(x)
    size_x = size(x);
    y = reshape(x, 1, []);
    a = 0;
    s = [];
    for i = y
      if i > 5
          a = 1;
      end
      s = [s, a];
    end
    s = reshape(s, size_x);
end