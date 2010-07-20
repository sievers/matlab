function[points,dists]=get_spaced_points(n,dim,thresh)

if (thresh<0)
    thresh=thresh*-1;
    rangen=@rand;
else
    rangen=@randn;
end

finished=0;
nsofar=1;
points(1,1:dim)=rangen(1,dim);
keep_vec(1)=true;
iter=0;
maxiter=40;
while (finished==0)
    iter=iter+1;
    if (iter>maxiter)
        nbad=n-nsofar;
        if (nbad==1)
            warning(['unable to converge in ' num2str(maxiter) ' tries.  1 point will be too close.']);
        else
            warning(['unable to converge in ' num2str(maxiter) ' tries.  ' num2str(nbad) ' points will be too close.']);
        end
        return
    end
    points(nsofar+1:n,1:dim)=rangen(n-nsofar,dim);
    keep_vec(nsofar+1:n)=true;
    for j=nsofar+1:n,
        dists=sum( (points(1:j-1,:)-repmat(points(j,:),[j-1 1])).^2,2);
        if (min(dists(keep_vec(1:j-1)))<thresh*thresh)
            keep_vec(j)=false;
        end
    end
    ncut=sum(keep_vec==false);
    if (ncut>1)
        disp(['Throwing away ' num2str(ncut) ' points.']);
    end
    if (ncut==1)
        disp(['Throwing away 1 point.']);
    end
    
    nsofar=sum(keep_vec);
    if (ncut>0)
        points(1:sum(keep_vec),:)=points(keep_vec,:);
        
        keep_vec(1:nsofar)=true;
        keep_vec(nsofar+1:end)=false;
        
    end
    
    
    if (nsofar==n)
        finished=1;
    end
end
