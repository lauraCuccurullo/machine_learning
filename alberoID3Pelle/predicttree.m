function Y = predicttree(tree,X)
	m=size(X,1);
	Y = zeros(m,1);
    for i=1:m
        val=0;
        value = tree(1,1);
		while (value.value)
            a=value.value;
            if (isequal(a,'false'))
                val=1;
                break;
            end
            if (isequal(a,'true'))
                val=2;
                break;
            end
            if (X(i,(str2double(value.value)))>122)
                value= value.right;
            else
                value= value.left;
            end
		end
		Y(i,1) = val;
    end
end