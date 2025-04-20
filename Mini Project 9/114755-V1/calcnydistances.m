

%calcbostondistances.m

load ../data/working/sb_ny_loc.txt
sbloc=sb_ny_loc;
% num starbucks
Nsb=length(sbloc);
sbid=sbloc(:,1);
sblat=sbloc(:,2);
sblon=sbloc(:,3);

load ../data/working/dd_ny_loc.txt
ddloc=dd_ny_loc;
%latitude longitude name address city state

% num dunkin donuts
Ndd=length(ddloc);
ddid=ddloc(:,1);
ddlat=ddloc(:,2);
ddlon=ddloc(:,3);

% location for each obs.
dist=zeros(Nsb,Ndd);

% Calculate distances to all
for i=1:Nsb
    for j=1:Ndd
        latrad1 = sblat(i)*pi/180;
        lonrad1 = sblon(i)*pi/180;

        latrad2 = ddlat(j)*pi/180;
        lonrad2 = ddlon(j)*pi/180;

        londif = abs(lonrad2-lonrad1);

        raddis = acos(sin(latrad2)*sin(latrad1)+ cos(latrad2)*cos(latrad1)*cos(londif));
        % nautdis = raddis * 3437.74677
        % statdis = nautdis * 1.1507794
        dist(i,j) = raddis * 3437.74677 * 1.852;       
        end
end

maxdist=max(max(dist));

[closest,closestindex]=min(dist,[],2);

% numbers of firms with radii increasing by .25 km
% number of radii to calculate number of DDs
R=12;
numdd=zeros(Nsb,R);
for r=1:R
    numdd(:,r)=sum(real(dist<r/4),2);
end

distvars=[sbid, ddid(closestindex), closest, numdd];

save ../data/working/ny_distvars.raw distvars -ASCII

