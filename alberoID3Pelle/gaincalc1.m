function [gains, tf] = gaincalc1(Xtr, Ytr, c, n_true, n_false, value)

        p1 = n_true / c;
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*p1*log2(p1);
        end
        p0 = (c - n_false) / c;
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*p0*log2(p0);
        end
        currentEntropy = p1_eq + p0_eq;

        s0 = 0; s0_and_true = 0;
        s1 = 0; s1_and_true = 0;
        
        for j=1:c
            if (Xtr(j,str2double(value))>=122)
                s1 = s1 + 1;
                if (Ytr(j)==1)
                    s1_and_true = s1_and_true + 1;
                end
            else
                s0 = s0 + 1; 
                if (Ytr(j)==1)
                    s0_and_true = s0_and_true + 1;
                end
            end
        end

        % Ricalcolo l'entropia per S(v<=0)
        if (~s1)
            p1 = 0;
        else
            p1 = (s1_and_true / s1); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (~s1)
            p0 = 0;
        else
            p0 = ((s1 - s1_and_true) / s1);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s1 = p1_eq + p0_eq;
        
        if (~s0)
            p1 = 0;
        else
            p1 = (s0_and_true / s0); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (~s0)
            p0 = 0;
        else
            p0 = ((s0 - s0_and_true) / s0);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s0 = p1_eq + p0_eq;
        
        gains = currentEntropy - ((s1/c)*entropy_s1) - ((s0/c)*entropy_s0);
        if ((s1/c)*entropy_s1) > ((s0/c)*entropy_s0)
            tf= 'true';
        else 
            tf= 'false';
        end
end