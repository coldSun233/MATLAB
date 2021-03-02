function upd = calculate_upd(data)
    sz = size(data);
    userNum = sz(1);
    upd = zeros(userNum, 1);
    T = sz(3);
    %num = zeros(6,1);
    if T ~= 1
       prev = double(collapse(tensor(data(:,:,1:(T-1))), 3));
       cur = data(:,:,T);
       for n = 1:userNum
          prev_interact = find(prev(n,:)~=0);
          cur_interact = find(cur(n,:)~=0);
          if isempty(cur_interact) && isempty(prev_interact)
             upd(n) = 0;
             %num(1) = num(1)+1;
          elseif isempty(cur_interact) && ~isempty(prev_interact)
              upd(n) = 1;
              %num(2) = num(2)+1;
          elseif ~isempty(cur_interact) && isempty(prev_interact)
              upd(n) = 0;
              %num(3) = num(3)+1;
          else
             common = numel(intersect(prev_interact, cur_interact));
             upd(n) = 1 - ( common / (numel(prev_interact) + numel(cur_interact) - common) );
             % if upd(n) >=0.75
             %     num(4) = num(4)+1;
             % elseif upd(n) <= 0.5
             %     num(5) = num(5)+1;
             % else
             %     num(6) = num(6)+1;
             % end   
          end
       end
    end
end

