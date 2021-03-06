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
            if (X(i,(str2double(value.value)))>191)
                value= value.right;
            elseif (X(i,(str2double(value.value)))>128)
                value= value.leftcenter;
            elseif (X(i,(str2double(value.value)))>65)
                value= value.rightcenter;
            else
                value= value.left;
            end
		end
		Y(i,1) = val;
    end
end