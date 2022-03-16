# Introduction ------------------------------------------------------------
# This code describes the individual PCB air-water flux calculation for one only
# deployment time.

# Read Pangaea datasets ---------------------------------------------------

# https://cran.microsoft.com/snapshot/2022-01-01/web/packages/pangaear/pangaear.pdf
# Install packages
install.packages('pangaear')

# Libraries
library(pangaear)

# set a different cache path from the default
pg_cache$cache_path_set(full_path = "/Users/andres/OneDrive - University of Iowa/work/ISRP/Project4/Old/Codes/PCBFluxesLM")

# Download the datasets from Pangaea
data.water <- pg_data(doi = '10.1594/PANGAEA.897527')
data.air <- pg_data(doi = '10.1594/PANGAEA.897526')
data.meteo <- pg_data(doi = '10.1594/PANGAEA.897532')

# Obtain just concentrations from Pangaea dataset
pars.water <- data.water[[1]]$data # pg/L
pars.air <- data.air[[1]]$data # ng/m3

# Extract first deployment time data, i.e., 1 to 6
# i.e., 2010-09-20T20:00 to 2010-09-21T09:00
pars.water.2 <- pars.water[1,] # pg/L
pars.air.2 <- pars.air[1,] # ng/m3

# Remove metadata
pars.water.3 <- subset(pars.water.2,
                       select = -c(`Sample label`:`Date/Time (end)`))
pars.air.3 <- subset(pars.air.2,
                     select = -c(`Sample label`:`Date/Time (end)`))

# Obtain meteorological parameters from Pangaea dataset
pars.meteo <- data.meteo[[1]]$data

# Extract data per sampling period
# from first deployment time data, i.e., 1 to 6
pars.meteo.s1 <- pars.meteo[1:13,]
pars.meteo.s2 <- pars.meteo[14:25,]
pars.meteo.s3 <- pars.meteo[26:37,]
pars.meteo.s4 <- pars.meteo[38:49,]
pars.meteo.s5 <- pars.meteo[50:62,]
pars.meteo.s6 <- pars.meteo[63:74,]

# Two parameter Weibull distribution
# See SM from paper for details
# Include e and n (mean for each sampling period, i.e., 1 to 6)
e.m <- c(4.2005484, 8.9379, 4.2125, 4.0528, 3.308,
         5.0345)
e.er <- c(0.8689, 2.1091, 0.82558, 0.895, 0.7223,
          0.949)
n.m <- c(4.7219, 8.8317, 6.8094, 5.6151, 5.3564,
         10.3135)
n.er <- c(0.331176, 0.3, 0.4767, 0.4244, 0.4955,
          0.5816843)

# Create P-C properties matrix --------------------------------------------

# Create matrix to storage P-C data
pc <- data.frame(matrix(NA, nrow = 160, ncol = 7))

# Add column names
colnames(pc) <- c('Congener', 'MW.PCB', 'nOrtho.Cl', 'H0.mean', 'H0.error',
                  'Kow.mean', 'Kow.error')

# Add PCB names
pc[,1] <- as.factor(c('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11',
                      '12+13', '15', '16', '17', '18+30', '19', '20+28', '21+33',
                      '22', '23', '24', '25', '26+29', '27', '31', '32', '34',
                      '35', '36', '37', '38', '39', '40+41+71', '42', '43+73',
                      '44+47+65', '45+51', '46', '48', '49+69', '50+53', '52',
                      '54', '55', '56', '57', '58', '59+62+75', '60', '61+70+74+76',
                      '63', '64', '66', '67', '68', '72', '77', '78', '79', '80',
                      '81', '82', '83+99', '84', '85+116+117', '86+87+97+109+119+125',
                      '88+91', '89', '90+101+113', '92', '93+100', '94', '95',
                      '96', '98+102', '103', '104', '105', '106', '108', '107+124',
                      '110+115', '111', '112', '114', '118', '120', '121', '122',
                      '123', '126', '127', '129+138+163', '130', '131', '132',
                      '133', '134+143', '135+151', '136', '137+164', '139+140',
                      '141', '142', '144', '145', '146', '147+149', '148',
                      '150', '152', '153+168', '154', '155', '156+157', '158',
                      '159', '160', '161', '162', '165', '167', '169', '170',
                      '171+173', '172', '174', '175', '176', '177', '178',
                      '179', '180+193', '181', '182', '183', '184', '185',
                      '186', '187', '188', '189', '190', '191', '192', '194', '195',
                      '196', '197', '198+199', '200', '201', '202', '203', '205',
                      '206', '207', '208', '209'))

# Add MW of individual PCB congeners
pc[1:3,2] <- c(188.644)
pc[4:13,2] <- c(223.088)
pc[14:33,2] <- c(257.532)
pc[34:62,2] <- c(291.976)
pc[63:93,2] <- c(326.42)
pc[94:124,2] <- c(360.864)
pc[125:146,2] <- c(395.308)
pc[147:156,2] <- c(429.752)
pc[157:159,2] <- c(465.740544)
pc[160,2] <- c(498.64)

# Add ortho Cl of individual PCB congeners
pc[,3] <- c(1, 0, 0, 2, 1, 1, 1, 1, 1, 2, 0, 0, 0, 2,
            2, 2, 3, 1, 1, 1, 1, 2, 1, 1, 2, 1, 2, 1,
            0, 0, 0, 0, 0, 2, 2, 2, 2, 3, 3, 2, 2, 3,
            2, 4, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1,
            1, 0, 0, 0, 0, 0, 2, 2, 3, 2, 2, 3, 3, 2,
            2, 3, 3, 3, 4, 3, 3, 4, 1, 2, 1, 1, 2, 1,
            2, 1, 1, 1, 2, 1, 1, 0, 0, 2, 2, 3, 3, 2,
            3, 3, 4, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 4,
            2, 3, 4, 1, 2, 1, 2, 2, 1, 2, 1, 0, 2, 3,
            2, 3, 3, 4, 3, 3, 4, 2, 3, 3, 3, 4, 3, 4,
            3, 4, 1, 2, 2, 2, 1, 3, 3, 4, 3, 4, 4, 4,
            3, 2, 3, 4, 4, 4)

# Add log10 Ho of individual PCB congeners
pc[,4] <- c(-3.526,	-3.544,	-3.562,	-3.483,	-3.622,	-3.486,	-3.424,
            -3.518,	-3.49,	-3.373,	-3.537,	-3.595,	-3.649,	-3.600,
            -3.428,	-3.495,	-3.355,	-3.544,	-3.62,	-3.719,	-3.497,
            -3.500,	-3.500,	-3.526,	-3.393,	-3.562,	-3.407,	-3.375,
            -3.3745,	-3.473,	-3.818,	-3.634,	-3.524,	-3.503,	-3.592,
            -3.475,	-3.638,	-3.450,	-3.470,	-3.519,	-3.452,	-3.366,
            -3.496,	-3.242,	-3.739,	-3.82,	-3.568,	-3.602,	-3.517,
            -3.816,	-3.694,	-3.615,	-3.565,	-3.693,	-3.631,	-3.424,
            -3.441,	-3.989,	-3.787,	-3.705,	-3.426,	-3.844,	-3.835,
            -3.603,	-3.600,	-3.716,	-3.745,	-3.461,	-3.526,	-3.610,
            -3.585,	-3.468,	-3.407,	-3.523,	-3.387,	-3.431,	-3.298,
            -3.13,	-4.003,	-3.783,	-3.755,	-3.768,	-3.707,	-3.574,
            -3.574,	-3.845,	-3.901,	-3.61,	-3.253,	-3.901,	-3.759,
            -4.087,	-3.807,	-3.886,	-3.817,	-3.616,	-3.693,	-3.691,
            -3.639,	-3.548,	-3.492,	-3.754,	-3.483,	-3.76,	-3.502,
            -3.529,	-3.328,	-3.727,	-3.625,	-3.367,	-3.296,	-3.369,
            -3.783,	-3.418,	-3.075,	-4.053,	-3.782,	-3.808,	-3.670,
            -3.545,	-3.881,	-3.56,	-3.959,	-4.186,	-4.059,	-3.763,
            -3.924,	-3.772,	-3.651,	-3.527,	-3.787,	-3.671,	-3.560,
            -3.969,	-3.638,	-3.59,	-3.696,	-3.339,	-3.669,	-3.434,
            -3.693,	-3.353,	-3.177,	-3.95,	-3.876,	-3.718,	-4.174,
            -3.926,	-3.884,	-3.596,	-3.644,	-3.619,	-3.884,	-3.651,
            -3.853,	-4.059,	-4.059,	-3.772,	-3.777,	-3.948)

# Add Ho error
pc[,5] <- c(0.662)

# Add log10 Kow of individual PCB congeners
pc[,6] <- c(4.46,	4.69,	4.69,	4.65,	4.97,	5.06,	5.07,	5.07,	5.06,	4.84,
            5.28,	5.29,	5.3,	5.16,	5.25,	5.24,	5.02,	5.67,	5.60,	5.58,
            5.57,	5.35,	5.67,	5.66,	5.44,	5.67,	5.44,	5.66,	5.82,	5.88,
            5.83,	5.76,	5.89,	5.98,	5.76,	5.75,	5.75,	5.53,	5.53,	5.78,
            5.85,	5.62,	5.84,	5.21,	6.11,	6.11,	6.17,	6.17,	5.95,	6.11,
            6.20,	6.17,	5.95,	6.20,	6.20,	6.26,	6.26,	6.36,	6.35,	6.42,
            6.48,	6.36,	6.2,	6.39,	6.04,	6.3,	6.29,	6.13,	6.07,	6.38,
            6.35,	6.04,	6.13,	6.13,	5.71,	6.16,	6.22,	5.81,	6.65,	6.64,
            6.71,	6.73,	6.48,	6.76,	6.45,	6.65,	6.74,	6.79,	6.64,	6.64,
            6.74,	6.89,	6.95,	6.83,	6.8,	6.58,	6.58,	6.86,	6.55,	6.64,
            6.22,	7.02,	6.67,	6.82,	6.51,	6.67,	6.25,	6.89,	6.67,	6.73,
            6.32,	6.22,	6.92,	6.76,	6.41,	7.18,	7.02,	7.24,	6.93,	7.08,
            7.24,	7.05,	7.27,	7.42,	7.27,	7.11,	7.33,	7.11,	7.17,	6.76,
            7.08,	7.14,	6.73,	7.36,	7.11,	7.20,	7.20,	6.85,	7.11,	6.69,
            7.17,	6.82,	7.71,	7.46,	7.55,	7.52,	7.80,	7.56,	7.65,	7.30,
            7.20,	7.27,	7.62,	7.24,	7.65,	8.00,	8.09,	7.74,	7.71,	8.18)

# Add Kow error
pc[,7] <- c(0.32)

# Flux calculations -------------------------------------------------------

final.result = function(MW.PCB, H0.mean, H0.error, 
                        C.PCB.water.mean, C.PCB.water.error,
                        C.PCB.air.mean, C.PCB.air.error, nOrtho.Cl,
                        Kow.mean, Kow.error)
{
  # fixed parameters
  
  R = 8.3144
  T = 298.15 # K
  
  F.PCB.aw <- NULL
  for (replication in 1:100) # change replication
  { 
    
    # random parameters
    
    a <- rnorm(1, 0.085, 0.007)
    b <- rnorm(1, 1, 0.5)
    c <- rnorm(1, 32.7, 1.6)
    a2 <- rnorm(1, 0.13, 0.02)
    b2 <- rnorm(1, 2.9, 1.2)
    c2 <- rnorm(1, 47.8, 4.3)
    H0 <- rnorm(1, H0.mean, H0.error)
    Kow <- rnorm(1, Kow.mean, Kow.error)
    P <- rnorm(1, P.mean, P.error)
    T.water <- rnorm(1, T.water.mean, T.water.error) # C 
    T.air <- rnorm(1, T.air.mean, T.air.error) # C
    e <- abs(rnorm(1, e.mean, e.error))
    n <- abs(rnorm(1, n.mean, n.error))
    u <- rweibull(1, shape = e, scale = n) # m/s
    C.PCB.water <- abs(rnorm(1, C.PCB.water.mean, C.PCB.water.error)) # ng/m3
    C.PCB.air <- abs(rnorm(1, C.PCB.air.mean, C.PCB.air.error)) # pg/m3
    DOC <- abs(rnorm(1, 1.5, 0.375)) # mg/L error = 25%
    
    # computed values
    
    DeltaUaw <- (a*MW.PCB-b*nOrtho.Cl+c)*1000
    K <- 10^(H0)*101325/(R*T)
    K.air.water <- K*exp(-(DeltaUaw/R)*(1/(T.water+273.15)-1/T))
    K.final <- K.air.water*(T.water+273.15)/(T.air+273.15) # no units
    
    DeltaUoa <- (-a2*MW.PCB+b2*nOrtho.Cl-c2)*1000
    DeltaUow <- DeltaUoa + DeltaUaw
    
    Kow.water.t <- 10^(Kow)*exp(-(DeltaUow/R)*(1/(T.water+273.15)-1/T))
    Kdoc.t <- 0.06*Kow.water.t
    
    C.PCB.water.f <- C.PCB.water/(1+Kdoc.t*DOC/1000^2) # ng/m3
    
    D.water.air <- 10^(-3)*1013.25*((273.15+T.air)^1.75*((1/28.97)+(1/18.0152))^(0.5))/P/(20.1^(1/3)+9.5^(1/3))^2
    D.PCB.air <- D.water.air*(MW.PCB/18.0152)^(-0.5)
    V.water.air <- 0.2*u +0.3 # cm/s
    V.PCB.air <- V.water.air*(D.PCB.air/D.water.air)^(2/3) # cm/s
    
    visc.water <- 10^(-4.5318-220.57/(149.39-(273.15+T.water)))
    dens.water <- (999.83952+16.945176*T.water-7.9870401*10^-3*T.water^2-46.170461*10^-6*3+105.56302*10^-9*T.water^4-280.54253*10^-12*T.water^5)/(1+16.87985*10^-3*T.water)
    v.water <- visc.water/dens.water*10000
    diff.co2 <- 0.05019*exp(-19.51*1000/(273.15+T.water)/R)
    D.PCB.water <- diff.co2*(MW.PCB/44.0094)^(-0.5)
    Sc.PCB.water <- v.water/D.PCB.water
    Sc.co2.water <- v.water/diff.co2
    
    integrand <-function(u) {
      ((e/u)*(u/n)^e)*exp(-(u/n)^e)*(0.000125*u^1.64) # cm/s
    }
    k600 <- integrate(integrand, lower = 0, upper = Inf) # cm/s
    
    if(u > 5){
      V.PCB.water <- k600$value*(Sc.PCB.water/Sc.co2.water)^(-0.5)  
    } else {
      V.PCB.water <- k600$value*(Sc.PCB.water/Sc.co2.water)^(-2/3)
    }
    
    mtc.PCB <- ((1/V.PCB.water+1/(V.PCB.air*K.final)))^(-1) # cm/s
    
    F.PCB.aw <- c(F.PCB.aw, mtc.PCB*(C.PCB.water.f - C.PCB.air/K.final/1000)*86400/100) #ng/m2/d
    
  }
  
  mmm <-mean(F.PCB.aw) #ng/m2/day
  sss <- sd(F.PCB.aw) #ng/m2/day
  q2.5 <- quantile(F.PCB.aw, 0.025, na.rm = TRUE)
  q97.5 <- quantile(F.PCB.aw, 0.975, na.rm = TRUE)
  
  c(mmm, sss, q2.5, q97.5)
  
}

# Rename parameters -----------------------------------------------------------

Congener <- pc$Congener
MW.PCB <- pc$MW.PCB
H0.mean <- pc$H0.mean
H0.error <- pc$H0.error
nOrtho.Cl <- pc$nOrtho.Cl
Kow.mean <- pc$Kow.mean
Kow.error <- pc$Kow.error
C.PCB.water.mean <- as.numeric(pars.water.3) # pg/L
C.PCB.water.error <- as.numeric(pars.water.3*0.2) # 20% error
C.PCB.air.mean <- as.numeric(pars.air.3) # pg/m3
C.PCB.air.error <- as.numeric(pars.air.3*0.2) # 20% error

# Select sampling period, i.e., s1 to s6
T.air.mean <- mean(pars.meteo.s1$`TTT [°C]`)
T.air.error <- sd(pars.meteo.s1$`TTT [°C]`)
T.water.mean <- mean(pars.meteo.s1$`Temp [°C]`)
T.water.error <- sd(pars.meteo.s1$`Temp [°C]`)
P.mean <- mean(pars.meteo.s1$`PPPP [hPa]`)
P.error <- sd(pars.meteo.s1$`PPPP [hPa]`)
# Select sampling period, i.e., 1 to 6
e.mean <- e.m[1]
e.error <- e.er[1]
n.mean <- n.m[1]
n.error <- n.er[1]

# Final calculations ------------------------------------------------------
# Per individual congeners

Num.Congener <- length(Congener)

result <- NULL
for (i in 1:Num.Congener) {
  result <- rbind(result,
                  final.result(MW.PCB[i], H0.mean[i], H0.error[i],
                               C.PCB.water.mean[i], C.PCB.water.error[i],
                               C.PCB.air.mean[i], C.PCB.air.error[i],
                               nOrtho.Cl[i], Kow.mean[i], Kow.error[i]))
}

# Compiling results
final.result = data.frame(Congener, result)
names(final.result) = c("Congener", "Mean (pg/m2/d)",
                        "Std (pg/m2/d)", "2.5%CL (pg/m2/d)",
                        "97.5%CL (pg/m2/d)")

