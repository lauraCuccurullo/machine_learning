function H = entropy(length, values)

    %considero i miei due tipi di output
    out1 = 0;   
    
    %inizializzo due contatori, uno per ogni input
    count1 = 0;
    count2 = 0;
    
    for i=1 : length
        if(values(i) == out1)
            count1 = count1 + 1;
        else
            count2 = count2 + 1;
        end
    end

    p0 = count1/length;
    p1 = count2/length;
    H = - p0 * log2(p0) - p1 * log2(p1);
    
end  