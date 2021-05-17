# Import packages
using Pickle
using JLD2
using HDF5
using FileIO

#change directory, go to our output directory
cd("-")

# Load pickled results
cur_dir = string(@__DIR__)
output_dir = joinpath(cur_dir, "OUTPUT") 






#code test pour comprendre la structure, ca n est pa sle code de evans, reprends plus loin

for H_ind in range(1, stop=2, step=1) 
    for risk_type_ind in range(1, stop=3, step=1) 
        for risk_val_ind in range(1, stop=3, step=1)       
        ut_arr = [risk_val_ind, risk_type_ind, H_ind]
        rbart_an_arr = [risk_val_ind, risk_type_ind, H_ind]
         save("dict$(H_ind)$(risk_type_ind)$(risk_val_ind).jld2", Dict("ut_arr" =>  ut_arr,"rbart_an_arr" => rbart_an_arr))
        end
     end
end

for H_ind in range(1, stop=2, step=1) 
    for risk_type_ind in range(1, stop=3, step=1) 
        for risk_val_ind in range(1, stop=3, step=1)       
            dict = load("dict$(H_ind)$(risk_type_ind)$(risk_val_ind).jld2") 
            #run("ut_arr"$(H_ind)$(risk_type_ind)$(risk_val_ind) = load("dict$(H_ind)$(risk_type_ind)$(risk_val_ind).jld2", "ut_arr"))
        end
     end
end






#ici le code de evans reprends

for H_ind in range(1, stop=2, step=1) #attention, j'ai pris ut_arr pour une variable, c est un array, a recoder
    for risk_type_ind in range(1, stop=3, step=1) #ca c bon
        for risk_val_ind in range(1, stop=3, step=1) #ca c bon      
            #filename = string("dict_endog_$(H_ind)$(risk_type_ind)$(risk_val_ind).jld2") #pas sure que necessaire
            #print("filename= ", filename) #pas sure que necessaire
            global h = H_ind
            global r1  =  risk_type_ind  
            global r2 = risk_val_ind
            filename = load("dict_endog_$h$r1$r2.jld2")
            global ut_arr = load("dict_endog_$h$r1$r2.jld2", "ut_arr") #ca c bon
            #run("ut_arr_$(H_ind)$(risk_type_ind)$(risk_val_ind)" = ut_arr[$(H_ind),$(risk_type_ind),$(risk_val_ind), :, :, :, :]) #ca ne marchera pas, a modifier, notamment le nom de ce que j'appelle
            @eval $(Symbol("ut_arr_$h$r1$r2")) = ut_arr[ :, :, :, :, risk_val_ind, risk_type_ind, H_ind]
            print("ut_arr_$h$r1$r2")
            global rbart_an_arr = load("dict_endog_$h$r1$r2.jld2", "rbart_an_arr") #ca ca devrait aller
            @eval $(Symbol("rbart_an_arr_$h$r1$r2")) = rbart_an_arr[ :, :, :, :, risk_val_ind, risk_type_ind, H_ind] #ca ne marchera pas, a modifier            
        end
     end
end

# Solve for percent difference in average welfare matrices
avg_rtp1_size = 3
avg_rbart_size = 3

for risk_type_ind in range(1, stop=2, step=1)
    for risk_val_ind in range(1, stop=3, step=1)
        # ut_pctdif_1?? = np.zeros((?, ?))
        global r1  =  risk_type_ind  
        global r2 = risk_val_ind
        @eval $(Symbol("ut_pctdif_1$r1$r2") = zeros((avg_rtp1_size, avg_rbart_size))) 
        for avgrtp1_ind in range(1,stop = (avg_rtp1_size), step = 1) 
          for avgrbart_ind in range(1,stop = (avg_rbart_size), step = 1)
            global t = avgrtp1_ind
            global b  =  avgrbart_ind  
              # ut_mat_0?? = ut_arr_0??[?, ?, :, :]
              @eval $(Symbol("ut_mat_0$r1$r2") = ut_arr_0$r1$r2[ :, :, b, t]) #probablement un pb 
              @eval $(Symbol("ut_mat_1$r1$r2") = "ut_arr_1$r1$r2"[ :, :, b, t]) #probablement un pb 
              @eval $(Symbol("avg_ut_0$r1$r2") = mean("ut_mat_0$r1$r2"[.!isnan(ut_mat_0$r1$r2])) #probablement un pb    
              @eval $(Symbol("avg_ut_1$r1$r2") = mean("ut_mat_1$r1$r2"[.!isnan(ut_mat_1$r1$r2])) #probablement un pb 
              @eval $(Symbol("ut_pctdif_1$r1$r2[b, t]") = "avg_ut_1$r1$r2- avg_ut_0$r1$r2/avg_ut_0$r1$r2"))) #probablement un pb 
              print("ut_pctdif_1$r1$r2 for Cobb-Douglas, mu variable") #c bon
              print("ut_pctdif_1$r1$r2") #c bon
          end
        end
     end
end 

