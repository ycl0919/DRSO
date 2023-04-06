% PA Problem
function etrat = myPA(user_profile,alloted_bs,gunt,U,sig2,B,Iq)
    etrat = 0;
    for u = 1:length(U)
         n = alloted_bs(u);
         spunt = sum(user_profile);
         sgunt = sum(gunt);
         tmp = 0;
         for v = 1:length(U)
            nv = alloted_bs(v);
            if nv == n
               tmp = tmp + user_profile(v)*gunt(v,n);
            end
         end
         tmp = tmp - user_profile(u)*gunt(u,n);
         x = user_profile(u)*gunt(u,n)/(sig2 + tmp);
         vun = B*log2(1+x); % Uplink rate from mobile user u to BS n
         tqup = Iq/vun; % Uplink transmission time of request q to BS n
         etrat = etrat + (user_profile(u) * tqup); % Transmitting energy consumption for data offloading from mobile user u to BS n
    end
    end