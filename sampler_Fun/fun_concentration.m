function[concentration]=fun_concentration(...
    ...
 xx   , AAA                , Trace_size   , concen_radious , ...
 b    , len_concen_radius  , Num_part     , gg_r           )

for nn=1:Num_part
%     Constant(nn,:) = gg( xx(AAA(1,nn),:)' , xx(AAA(3,nn),:)' , xx(AAA(2,nn),:)')';
    cons(nn,:)     = gg_r(xx(AAA(1,nn),:)' , xx(AAA(3,nn),:)' , xx(AAA(2,nn),:)')';
end

for l=1:len_concen_radius
    concentration(1,1:Trace_size,l) = b*(sqrt( cons )<=concen_radious(l));
end

end