function [recall, precision] = get_recall(estimat, real, topK)
    sz = size(real);
    userNum = sz(1);
    itemNum = sz(2);
    hitNum = 0;
    allNum = 0;
    count = 0;
    for n = 1:userNum
        if any(real(n,:))
            [a, index1] = sort(estimat(n,:));
            % [b, index2] = sort(real(n,:));
            estimat_topK = index1((itemNum - topK):itemNum);
            current_useritem = find(real(n,:)~=0);
            if(~isempty(current_useritem))
                count = count +1;
            end
            hitNum = hitNum + numel(intersect(estimat_topK, current_useritem));
            allNum = allNum + numel(current_useritem);
        end
    end
    recall = hitNum / allNum;
    precision = hitNum / (count*(topK+1));
end

