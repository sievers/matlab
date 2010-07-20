function[data_filt,sigmat,filtmat]=get_wiener_filtered_data(base,specfile,ext)
if (nargin<3)
    ext='';
end

[data,u,v,z]=read_split_data([base '_SVEC']);
[spec,errs,ell,bands,which_pols,otherps,corrs,big_curve]=read_newdat(specfile);
sigmat=0;
projfac=100;

%spec=-1*abs(spec);
%spec(2,2)=100;

for j=1:bands(2),
    if (spec(j,2)>0)
        fname=[base ext '.pol_EE_' num2str(j-1)];
        fid=fopen(fname,'r');
        if (fid==-1)
            fid=fopen([fname '.gz']);
            if (fid==-1)
                error(['unable to open file ' fname ' for reading, and .gz not there']);
            else
                fclose(fid);
            end
            fwee=(['gunzip -c  ' fname '.gz > ' fname]);
            system(fwee);
        else
            fclose(fid);
        end
        sigmat=sigmat+read_single_mat(fname,2)*spec(j,2);
    end
end

for j=1:bands(3),
    if (spec(j,3)>0)
        fname=[base ext '.pol_BB_' num2str(j-1)];
        fid=fopen(fname,'r');
        if (fid==-1)
            fid=fopen([fname '.gz']);
            if (fid==-1)
                error(['unable to open file ' fname ' for reading, and .gz not there']);
            else
                fclose(fid);
            end
            fwee=(['gunzip -c  ' fname '.gz > ' fname]);
            system(fwee);
        else
            fclose(fid);
        end
        sigmat=sigmat+read_single_mat(fname,2)*spec(j,2);
    end
end
sigmat=sigmat/(2.725e6^2);
whos



fname=[base '.noise'];
fid=fopen(fname,'r');
if (fid==-1)
    fid=fopen([fname '.gz'],'r');
    if (fid==-1)
        error(['unable to open noise file ' fname ' for reading, and .gz not there']);
    else
        fclose(fid);
    end
    disp('gunzipping noise file');
    system(['gunzip  -c ' fname '.gz > ' fname]);
else
    fclose(fid);
end
filtmat=read_single_mat(fname,2);



fname=[base '.proj_0'];
fid=fopen(fname,'r');
if (fid==-1)
    fid=fopen([fname '.gz'],'r');
    if (fid==-1)
        error(['unable to open scan projection file ' fname ' for reading, and .gz not there']);
    else
        fclose(fid);
    end

    disp('gunzipping noise file');
    system(['gunzip  -c ' fname '.gz > ' fname]);
else
    fclose(fid);
end
filtmat=filtmat+projfac*read_single_mat(fname,2);

filtmat=filtmat+sigmat;

filtmat=inv(filtmat);
data_filt=data;
n=length(data)/3;
whos
data_filt(n+1:3*n)=sigmat*(filtmat*data(n+1:3*n));


data_filt=data;

