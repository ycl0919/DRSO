function grad = SubGrad(user_profile,u,alloted_bs,gunt,U,sig2,B,Iq)
    n = alloted_bs(u);
    tmp = 0;
    for v = 1:length(U)
        nv = alloted_bs(v);
        if nv == n
            tmp = tmp + user_profile(v)*gunt(v,n);
        end
    end
    tmp = tmp - user_profile(u)*gunt(u,n);
    gamma = gunt(u,n)/(sig2 + tmp);
    h_pun = log2(1 + gamma*user_profile(u));
    g_pun = log(2 * (1 + gamma*user_profile(u)));
    grad = Iq*(h_pun*g_pun - gamma*user_profile(u)) / (B*g_pun*h_pun^2);
end