function [train_set,test_set] = generate_trainAndTest(data, time_period, T)
% class(train_set) = double class(test_set) = double
    % generate trainset and testset
    sz = size(data);
    data = tensor(data);
    if time_period*T > sz(3)
        error('time_period*T is too large');
    end
    train_set = zeros([sz(1:2), T]);
    for n = 1:T
       idx1 = time_period*(n-1) + 1;
       idx2 = time_period*n;
       if n == T
           train_set(:,:,n) = collapse(data(:,:,idx1:(idx2-1)), 3);
       else
           train_set(:,:,n) = collapse(data(:,:,idx1:idx2), 3);
       end
    end
    test_set = double(data(:,:,time_period*T));
end

