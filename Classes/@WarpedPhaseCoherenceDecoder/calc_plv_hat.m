function r=calc_plv_hat(obj, s,alpha,flag1,flag2,flag3)
    n=size(s,2);
    r=eye(n);
    r_hat=eye(n);
    for i=1:n
        a=s(:,i);
        if flag2>0
            a=a./abs(a);
        elseif flag2==0
            a=a/mean(abs(a));
        end        
        for j=1:i-1
            b=s(:,j);
            if flag2>0
                b=b./abs(b);
            elseif flag2==0
                b=b/mean(abs(b));
            end
            if flag1>0
                a2=abs(a).*exp(1i*(angle(a)-1/2*angle(mean(exp(1i*(angle(a)-angle(b)))))));
            else
                a2=a;
            end
            a2=a2+alpha;
            if flag1>0
                b=abs(b).*exp(1i*(angle(b)-1/2*angle(mean(exp(1i*(angle(b)-angle(a)))))));
            end
            b=b+alpha;
            r(i,j)=abs(mean(exp(1i*(angle(a2)-angle(b)))));
            r(j,i)=r(i,j);
            if flag3>0
                for l=1:2
                    [~,u]=sort(rand(size(b)));
                    r_hat(i,j)=r_hat(i,j)+abs(mean(exp(1i*(angle(a2)-angle(b(u))))));
                end
                r_hat(i,j)=r_hat(i,j)/l;
            end
        end
    end
    if flag3>0
        r=(r-r_hat)./(1-r_hat);
        r=tril(r,-1)+tril(r,-1)'+eye(size(r));
    end
