function[Data] = Partial_data(Data , minn , maxx)

if  Data.Model_type==2
    if  numel(fieldnames(Data))==21 
        Data.k=1;
        Data.Trace_partial{Data.k} = Data.Trace(:,minn:maxx);
        Data.X_partial{Data.k}     = Data.X(:,minn:maxx);
        Data.Y_partial{Data.k}     = Data.Y(:,minn:maxx);
        Data.Z_partial{Data.k}     = Data.Z(:,minn:maxx);
        Data.minn{Data.k}          = minn;
        Data.maxx{Data.k}          = maxx;
    else
        if  Data.minn{Data.k} ~= minn
            if  Data.maxx{Data.k} ~= maxx
                Data.k=Data.k+1;
                Data.Trace_partial{Data.k} = Data.Trace(:,minn:maxx);
                Data.X_partial{Data.k}     = Data.X(:,minn:maxx);
                Data.Y_partial{Data.k}     = Data.Y(:,minn:maxx);
                Data.Z_partial{Data.k}     = Data.Z(:,minn:maxx);
                Data.minn{Data.k}          = minn;
                Data.maxx{Data.k}          = maxx;
            end
        end
    end
else
    if  numel(fieldnames(Data))==20 
        Data.k=1;
        Data.Trace_partial{Data.k} = Data.Trace(:,minn:maxx);
        Data.X_partial{Data.k}     = Data.X(:,minn:maxx);
        Data.Y_partial{Data.k}     = Data.Y(:,minn:maxx);
        Data.Z_partial{Data.k}     = Data.Z(:,minn:maxx);
        Data.minn{Data.k}          = minn;
        Data.maxx{Data.k}          = maxx;
    else
        if  Data.minn{Data.k} ~= minn
            if  Data.maxx{Data.k} ~= maxx
                Data.k=Data.k+1;
                Data.Trace_partial{Data.k} = Data.Trace(:,minn:maxx);
                Data.X_partial{Data.k}     = Data.X(:,minn:maxx);
                Data.Y_partial{Data.k}     = Data.Y(:,minn:maxx);
                Data.Z_partial{Data.k}     = Data.Z(:,minn:maxx);
                Data.minn{Data.k}          = minn;
                Data.maxx{Data.k}          = maxx;
            end
        end
    end
end
