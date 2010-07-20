function Obl=obliquity(JulianDay,Type);
%---------------------------------------------------------
% obliquity function        calculating obliquity of
%                         ecliptic (with respect to the
%                         mean equator od date)
%                         for a given julian day.
% Input  : - vector of Julian Days.
%          - Caqlculation type:
%            'L' - IAU 1976, good from 1000-3000 AD,
%                  default.
%            'H' - Laskar expression, more accurate.
% Output : - obliquity of ecliptic of date in radians.
% Tested : Matlab 5.3
%     By : Eran O. Ofek         August 1999
%                  Last Update: October 2001
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
%---------------------------------------------------------
RADIAN = 180./pi;

if (nargin==1),
   Type = 'L';
elseif (nargin==2),
   % do nothing
else
   error('Illigal number of input arguments');
end

switch Type
 case 'L'
    T   = (JulianDay - 2451545.0)./36525.0;
    Obl = 23.439291 - 0.0130042.*T - 0.00000016.*T.*T + 0.000000504.*T.*T.*T;
    Obl = Obl./RADIAN;
 case 'H'
    T   = (JulianDay - 2451545.0)./36525.0;
    U   = T./100;
    Obl = 23.44484666666667 ...
       -   (4680.93.*U ...
          - 1.55.*U.^2 ...
          + 1999.25.*U.^3 ...
            - 51.38.*U.^4 ...
           - 249.67.*U.^5 ...
            - 39.05.*U.^6 ...
             + 7.12.*U.^7 ...
            + 27.87.*U.^8 ...
             + 5.79.*U.^9 ...
             + 2.45.*U.^10)./3600;
    Obl = Obl./RADIAN;
 otherwise
    error('Unknown calculation type in obliquity.m');  
end
  
