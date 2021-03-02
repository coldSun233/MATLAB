function allgenres = get_allgenres(data)
    allgenres = string([]);
    len1 = length(data);
    for n = 1:len1
        s = data(n);
        classes = strsplit(s,'|');
        len2 = length(classes);
        for m = 1:len2
            if isempty(find(allgenres == classes(m), 1))
               allgenres = [allgenres; classes(m)];
            end
        end
    end
    allgenres = sort(allgenres);
end

