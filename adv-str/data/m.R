library(tidyverse)
library(tikzDevice)

go <- function() source("m.R")
main <- function() {
  message("Analysis started:")
  df1 <- readBM("out1.csv")
  df2 <- readBM("out2.csv")

  df <- merge(df1,df2,all=TRUE)
  df <- df %>% as_tibble %>%
    select(-(B_Nmm2:M_Nmm)) %>% #Exclude these two cols
    rename(B_Nmm2 = B_pstv,
           M_Nmm = M_pstv,
           ka_mm_1 = kappa_mm_1
           )

  df_labs = tribble(
    ~hogging,~frp_mm,~lab,
    ## -------------------
    FALSE, 0.3, "s11",
    FALSE, 2, "s12",
    FALSE, 9, "s13",
    TRUE, 0 , "s2",
    TRUE, 0.3, "s31",
    TRUE, 2, "s32",
    TRUE, 9, "s33"
  )
  df <- left_join(df,df_labs, by = c("hogging", "frp_mm"))
  base <- ggplot(df, aes(x = M_Nmm, color = factor(pre_str_ratio,
                                                   levels=rev(unique(pre_str_ratio))
                                                   )
                         )
                 )+
    facet_grid(map_chr(hogging, ~if(.) "Hogging Section" else "Sagging Section") ~
                 str_c(frp_mm, " mm thick of FRP"))+
    scale_colour_brewer(palette="RdYlBu")

  p1 <- base +
    geom_point(aes(y = B_Nmm2))+
    labs(x = "$M$ (Nmm)",
         y = "$B$ (Nmm$^2$)",
         colour = "Pre-strain in terms of ratio of $f_y$")+
    geom_text(data = df_labs, aes(x = 1e8, y = 6e13, label = str_c("Section-", lab)), colour = "black")

  p2 <- base + geom_point(aes(y=ka_mm_1))+
    labs(y = "$\\kappa$ (mm$^{-1}$)",
         x = "$M$ (Nmm)",
         colour = "Pre-strain in terms of ratio of $f_y$")+
    geom_text(data = df_labs, aes(x = 1e8, y = 4e-5, label = str_c("Section-", lab)), colour = "black")
  list(df=df, plot=p1, df1=df1,df2=df2, plot2=p2)
}

readBM <- function(filename){
  read_csv(filename,
           ## locale = default_locale(),
           col_types=list(
             pre_str_ratio= col_double(),
             hogging = col_logical(),
             frp_mm = col_number(),
             ratio_str = col_number(),
             B_Nmm2 = col_number(),
             M_Nmm = col_number(),
             kappa_mm_1 = col_number(),
             B_pstv = col_number(),
             M_pstv = col_number()
           )
           )
}

exportPlot <- function(texName,p,w,h){
  tikz(texName,
       width = w,
       height = h
       )
  print(p)
  dev.off()
}
getDfOut <- function(df){
  df %>% filter(pre_str_ratio == 0) %>%
    select(B_Nmm2, M_Nmm, lab)
}


l <- main()
df_BM <- l$df
## p <- l$plot
## p2 <- l$plot2
## df_out <- getDfOut(df)
## ## write_csv(df_out,"DBData.csv")
## exportPlot("tex/BMPlot.tex",p,16,7);
## exportPlot("tex/BKappaPlot.tex",p2,16,7);

outputAnalysis <- function(){
  df <- read_csv("AnalysisOutput.csv", col_types = list(
                                         B = col_number(),
                                         B_exp = col_number(),
                                         M = col_number(),
                                         R = col_number(),
                                         nRun = col_integer(),
                                         udl = col_number(),
                                         cap_r = col_character(),
                                         nam = col_character(),
                                         nam_set = col_character(),
                                         hog = col_character(),
                                         sag = col_character()
                                       )
                 )
  get_node_id <- function(x,df, nSlicePerSide) rep(x,nrow(df)/nSlicePerSide)

  nSlicePerSide = 100;
  L = 8
  l = L / (nSlicePerSide * 2)
  nid = seq(from=1,to=nSlicePerSide)
  nid2 = seq(from=nSlicePerSide*2, to=nSlicePerSide+1)
  df2 <- df
  df2$nid = get_node_id(nid2,df2,nSlicePerSide)
  df$nid = get_node_id(nid,df,nSlicePerSide)
  df <- merge(df,df2,all=TRUE)
  ep_c = 0.0035 #epsilon_c for concrete
  df <- df %>% mutate(str_m = l * (nid-1),
                      end_m = l * nid)
  as_tibble(df)
}

## Group by lab (e.g. s11,s12,s13), get a spline model for m-k
df_kM <- df_BM %>% filter(pre_str_ratio == 0) %>% select(ka_mm_1, M_Nmm, lab)

mod_func <- function(df){
  loess(ka_mm_1~M_Nmm,data=df)
}

library(modelr)
df_kM_nested <- df_kM %>%
  group_by(lab) %>%
  nest()
## Fit a model for each table
df_kM_nested <- df_kM_nested %>% mutate(mod = map(data,mod_func),
                                        ka_pred = map2(data,mod, add_predictions)
                                        )
df_pred <- df_kM_nested %>% unnest(ka_pred) %>%
  select(pred, M_Nmm,lab) %>%
  rename(ka_pred = pred)

pk <- ggplot(df_kM, aes(x = M_Nmm, y = ka_mm_1))+
  facet_wrap(~lab)+
  geom_point()+
  geom_line(data=df_pred, aes(y = ka_pred, colour = "Regression Line"), size=1)+
  labs(x="Moment $M$ (Nmm)", y="$\\kappa$ (mm$^{-1}$)", colour=NULL)

predict_ka_for_this_M <- function(l,M){
  df_mod <-  df_kM_nested %>% filter(lab==l)
  stopifnot(nrow(df_mod) == 1)
  m <- df_mod$mod[[1]]
  predict(m,tibble(M_Nmm = M))
}

## Test
## x = predict_ka_for_this_M("s11", 1e8)

prettify_nam <- function(s){
  s <- str_replace(s,"_",",")
  s <- str_replace(s,"C","C_{")
  s <- str_c("Analysis Set: $",s,"}$")
  s
}

df <- outputAnalysis()
## df <- df %>%
##   filter(nRun > 8) #comment me

df <- mutate(df, nam_set = prettify_nam(nam_set))

base <- ggplot(df, aes(x=str_m))+
  facet_grid(nam_set ~ str_c("Iteration ",nRun))+
  scale_colour_distiller(palette="YlOrRd", direction=1)

pb <- base+
  geom_point(aes(y=B, colour=udl), alpha = .5,size=0.7)+
  labs(x = "Position along the span (m)",
       y = "Stiffness $B$ (Nmm$^2$)",
       colour = "UDL (N/m)"
       )

pm <- base+
  geom_point(aes(y=M, colour=udl), alpha= 0.5, size=0.7)+
  labs(x = "Position along the span (m)",
       y = "Moment $M$ (Nmm)",
       colour = "UDL (N/m)"
       )

shear_bond_analysis <- function(df){
  main <- function(){
    df_final <- get_final_df(df)
  }
  main()
}

## Get the df for shear-bond analysis
get_final_df <- function(df){
  ## Get the maximum udl runs in each nam_set
  df_final <- df %>%
    group_by(nam_set) %>%
    filter(udl == max(udl),
           nRun ==max(nRun)
           )

  ep_c = 0.0035
  d = 450 #mm
  E_frp = 160000 #Mpa
  b_frp = 200    #mm
  ## final df
  df_final <- df_final %>%
    mutate(lab = ifelse(M<0,hog,sag)) %>%
    ## drop s2, since it has no frp
    filter(lab != "s2") %>%
    mutate(
      ka = map2_dbl(lab,abs(M),predict_ka_for_this_M), #accept positive M
      d_c = ep_c / ka, #mm
      ep = ep_c * (d - d_c) / d_c,
      sig = E_frp * ep #the axial stress on frp platting
    )
  df_labs = tribble(
    ~frp_mm,~lab,
    ## -------------------
    0.3, "s11",
    2, "s12",
    9, "s13",
    0 , "s2",
    0.3, "s31",
    2, "s32",
    9, "s33"
  )

  df_final <- df_final %>%
    select(str_m,sig,nam_set,lab, M) %>%
    group_by(nam_set, lab) %>%
    fill(sig,.direction="updown") %>%
    left_join(df_labs, by="lab")
  df_final
}

df_final <- get_final_df(df)

## Assume allowed shear-bond strength = 1N/mm2 = MPa
calc_shear <- function(df){
  df <- df %>% arrange(str_m)
  nSlicePerSide = 100;
  L = 8000
  l = L / (nSlicePerSide * 2)
  df$shr = c(0,diff(df$sig)) * df$frp_mm / l
  df
}

## For each nam_set
df_shr <- df_final %>%
  ungroup(lab) %>%
  nest() %>%
  mutate(data = map(data,calc_shear)) %>%
  unnest(data)

## Plot for axial stress
ps <- ggplot(df_shr, aes(x=str_m,y= sig, colour=shr))+
  facet_wrap(.~nam_set)+
  labs(x="Position along the span (m)",
       colour="Bond shear stress for FRP plating $\\tau_l$ (MPa)",
       y="The axial stress for FRP plating $\\sigma_A$ (MPa)"
       )+
  geom_point()+
  geom_text(data = tribble(
              ~txt, ~nam_set,
              "In the sagging zone of $C_{1,2}$, section S2 is used which dossn't has FRP, so not shown here.", prettify_nam("C1_2"),
              "In the sagging zone of $C_{1,3}$, section S2 is used which dossn't has FRP, so not shown here.", prettify_nam("C1_3")
            ),
            aes(x = 4, y = 1200, label = str_wrap(txt,30)), colour = "black")+
  scale_colour_gradientn(colours = colorspace::sequential_hcl(7,palette="viridis"))

## exportPlot("tex/pm.tex", pm, 15,4)
## exportPlot("tex/pb.tex", pb, 15,4)
exportPlot("tex/ps.tex", ps, 12,5)
## exportPlot("tex/pk.tex", pk, 10,4)
