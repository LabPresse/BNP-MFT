function x = tri_solver(N,d,c,y)
%  Implements the Thomas algorithm to solve for x the tri-diagonal system
%
%  [ d(1)  c(1)                                      ] [ x(1)   ]   [ y(1)   ]
%  [ c(1)  d(2)  c(2)                                ] [ x(2)   ]   [ y(2)   ]
%  [       c(2)  d(3)  c(3)                          ] [        ]   [        ]
%  [             ...   ...   ...                     ] [  ...   ] = [  ...   ]
%  [                   ...   ...     ...             ] [        ]   [        ]
%  [                         c(N-2)  d(N-1)  c(N-1)  ] [ x(N-1) ]   [ y(N-1) ]
%  [                                 c(N-1)  d(N)    ] [ x(N)   ]   [ y(N)   ]
%
%  c, d and y are vectors of length N
%  x is column vector of length N


v     = nan(N,1) ;   
x     = nan(N,1) ;

w     = d(1)     ;
x(1)  = y(1)/w   ;


for n = 2 : N
    v(n-1) =  c(n-1)/w ;
    w      =  d(n) - c(n-1)*v(n-1);
    x(n)   = ( y(n) - c(n-1)*x(n-1) )/w;
end

for n = N-1 : -1 : 1
    x(n) = x(n) - v(n)*x(n+1);
end




end

