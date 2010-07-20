function[myfilled,ata,fitvecs,atd,x,ind,fitparams]=gap_fill(vec,mask,n)
%Do linear least-squared fitting of Fourier modes across the
%un-masked part of vec, and use them to fill in masked gaps.
%mask is 0/1 if data masked/unmasked, n is number of modes to use.
%If n between 0 and 1, use that *fraction* of modes available.
%mask and vec should come in as column vectors.

if (0)
    
    if ~exist('n'),
        %n=floor(sum(mask)/2);
        n=round(length(vec)/4);
    end
    if (n<1)
        n=round(n*length(vec));
    end
    maskft=fft(mask);
    vecft=fft(mask.*vec);
    ind=[1:n+1   length(vec)-n+1:length(vec)];

    myfilled=0;
    fitvecs=0;
    x=0;
    ata=maskft(1:2*n+1);
    atd=vecft(ind);
    fitparams=solve_toeplitz(conj(ata),fftshift(atd));

    fullft=0*vec;
    fullft(ind)=ifftshift(fitparams);
    myfilled=(ifft(fullft))*length(fullft);
    imfrac=sum(abs(imag(myfilled)))/sum(abs(real(myfilled)));
    if (imfrac>1e-6)
        warning(['Warning - gap-filled stuff isn''t has appreciable imaginary (' num2str(imfrac) ') part.  Check condition number.']);
    else
        myfilled=real(myfilled);
    end
    
    
    return;
end



if ~exist('n'), 
  n=round(length(vec)/4);
end
if (n<1),
  n=round(n*length(vec));
end
assert(n>0);


if (1)

    x=(1:length(vec))'-1;    
    x=2*pi*x/length(x);
    fitvecs(length(vec),2*n+1)=0;
    fitvecs(:,1)=1;
    ind=[1:n+1   length(vec)-n+1:length(vec)];

    if (1)
        for j=0:n,
            fitvecs(:,j+1)=exp(i*x*j);
            if (j>0),
                fitvecs(:,end-j+1)=exp(-i*j*x);
            end
        end
    else

        for j=1:n,
            fitvecs(:,2*j)=cos(j*x);
            fitvecs(:,2*j+1)=sin(j*x);
        end
    end
    ata=fitvecs(mask,:)'*fitvecs(mask,:);
    atvec=fft(mask');

    %ata=toeplitz(atvec);ata=ata(ind,ind);
    %e=eig(ata);disp([min(e) max(e)])

    atd=fitvecs(mask,:)'*vec(mask);
    %atd=fft(mask.*vec);atd=atd(ind);

    if (1) %set to true for proper, correlated least-squared
        fitparams=inv(ata)*atd;
    else
        for j=1:length(ata),
            ata(j,j)=real(ata(j,j));
        end
        
        disp(ata(1,1))
        mychol=chol(ata);
        
        fitparams=chol_solve(mychol,atd);
    end
    
    myfilled=fitvecs*fitparams;
else
    

    maskft=fft(mask);
    vecft=fft(mask.*vec);
    ind=[1:n   length(vec)-n+2:length(vec)];



    vecft=vecft(ind);
    ata=maskft(ind);
    atainv=conj(ifft(1./fft(ata)));
    myfit=atainv.*vecft;
    myft=zeros(size(vec));
    myft(ind)=myfit;
    myfilled=ifft(myft);


    %ata=toeplitz(maskft(1:n));
    %fit=inv(ata)*vecft;
    %fitft=zeros(size(vec));
    %fitft(1:length(fit),:)=fit;
    %fitft((end-length(fit)+2):end,:)=conj(flipud(fit(2:end,:)));
end




