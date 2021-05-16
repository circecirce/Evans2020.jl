using Pickle
using JLD

#change directory, go to our output directory
cd("C:\\Users\\circe\\NumericalMethods\\117321-V1\\code\\e1_mucnst\\OUTPUT")

# Load pickled results
cur_dir = string(@__DIR__)
output_dir = joinpath(cur_dir, "OUTPUT") 

for H_ind in range(0, stop=1, step=1) #attention, peut-être qu'il faudra changer le range pour qu'il commence par 1 --> à voir par la suite
    for risk_type_ind in range(0, stop=1, step=1) #idem
        for risk_val_ind in range(0, stop=2, step=1) #idem      
            filename = string("dict_endog_$(H_ind)$(risk_type_ind)$(risk_val_ind).pkl") #string("dict_endog_$(H_ind)$(risk_type_ind)$(risk_val_ind).jld")
            print("filename= ", filename)
            #filename = load(filename) #devrait etre ca avec jld
            filename = Pickle.load(open(filename)) #du coup pas sur de moi de ouf
            run("ut_arr_$(H_ind)$(risk_type_ind)$(risk_val_ind)" = load("filename","ut_arr_$(H_ind)$(risk_type_ind)$(risk_val_ind)")) #ya moy qu'il faille unquote filename
            print("ut_arr_$(H_ind)$(risk_type_ind)$(risk_val_ind)")
            run("rbart_an_arr_$(H_ind)$(risk_type_ind)$(risk_val_ind)" = load("filename","rbart_an_arr_$(H_ind)$(risk_type_ind)$(risk_val_ind)"))
        end
     end
end


# Solve for percent difference in average welfare matrices
avg_rtp1_size = 3
avg_rbart_size = 3

for risk_type_ind in range(0, stop=1, step=1)
    for risk_val_ind in range(0, stop=2, step=1)
        # ut_pctdif_1?? = np.zeros((?, ?))
        run("ut_pctdif_1$(risk_type_ind)$(risk_val_ind)" = zeros((avg_rtp1_size, avg_rbart_size)))
        for avgrtp1_ind in range(0,stop = (avg_rtp1_size-1), step = 1) 
          for avgrbart_ind in range(0,stop = (avg_rbart_size-1), step = 1)
              # ut_mat_0?? = ut_arr_0??[?, ?, :, :]
              run("ut_mat_0$(risk_type_ind)$(risk_val_ind)" = "ut_arr_0$(risk_type_ind)$(risk_val_ind)"[avgrtp1_ind, avgrbart_ind, :, :]) #peut etre il faut mettre le " apres ]
              run("ut_mat_1$(risk_type_ind)$(risk_val_ind)" = "ut_arr_1$(risk_type_ind)$(risk_val_ind)[avgrtp1_ind, avgrbart_ind, :, :]") #la je le mets apres, j aime la diversite
              run("avg_ut_0$(risk_type_ind)$(risk_val_ind)" = mean("ut_mat_0$(risk_type_ind)$(risk_val_ind)"[.!isnan(ut_mat_0$(risk_type_ind)$(risk_val_ind)])) #pas sure de moi du tout   
              run("avg_ut_1$(risk_type_ind)$(risk_val_ind)" = mean("ut_mat_1$(risk_type_ind)$(risk_val_ind)"[.!isnan(ut_mat_1$(risk_type_ind)$(risk_val_ind)]))
              run("ut_pctdif_1$(risk_type_ind)$(risk_val_ind)[avgrtp1_ind, avgrbart_ind]" = "avg_ut_1$(risk_type_ind)$(risk_val_ind)- avg_ut_0$(risk_type_ind)$(risk_val_ind)/avg_ut_0$(risk_type_ind)$(risk_val_ind)")))
              print("ut_pctdif_1$(risk_type_ind)$(risk_val_ind)for Cobb-Douglas, mu variable")
              print("ut_pctdif_1$(risk_type_ind)$(risk_val_ind)")
          end
        end
     end
end 
