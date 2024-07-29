# Control-Relevant-Input-Signal-Design
Integrating (or slow first-order) systems with much faster closed-loop speeds  relative to open-loop speeds possess control-relevant modeling requirements not addressed  in the traditional literature.

Time constant guidelines (McFarlane and Rivera, 1992) :
* Place equal emphasis on all frequencies.
* Yield potentially long test signals. 

### We present guidelines that:

* Incorporate closed-loop requirements for integrating systems.

* Can be realized in the time domain with “plant-friendly” multisine input signals.

* Have been validated experimentally using a semi-industrial-scale photobioreactor facility.

### Addressed in three steps:
* Control-Relevant Parameter Estimation Problem – Relating closed-loop control error ec = (r - y)  to open-loop modeling error e_a = (𝒑 - 𝒑 ̃).
* Prediction Error Minimization – Relating open-loop modeling error to  design variables in the identification problem (e.g., input signal power, prefiltering).
* Time-domain realization of the control-relevant input power spectrum into a “plant-friendly” multisine signal.

Of these three stages I demonstrate here just the control-relevant weight (step 2) which is the key to this problem.

### Control Relevant Parameter Estimation Problem (CRPEP; Rivera and Gaikwad, 1995)

![image](https://github.com/user-attachments/assets/d052a37d-a37a-4100-9944-552886a30ec4) 

* The weight function W = |𝝐 ̃𝜼 ̃(𝒓−ⅆ ) 𝒑 ̃-1 | incorporates explicitly the desired closed-loop response and the setpoint/disturbance description of the problem.

* IMC design is used to specify 𝜼 ̃ and 𝝐 ̃.

The influence of Open-loop modeling error over closed-loop performance can be interpreted via a linear fractional transformation. Based on the nominal performance specifications as per IMC tuning, the LFT allows us to narrow down the regions of time and frequency over which a good model fit is necessary for the desired closed-loop control. The challenge then is to find a way to properly emphasize this region in a systematic manner. This motivates the formulation of a CRPEP problem. 

CRPEP is effectively a frequency-weighted optimization problem that reduces the closed-loop error by minimizing the contribution arising from open loop estimation. The exact equation is shown here and the derivation is noted in the paper. The weight can be designed to satisfy the closed-loop requirements, provided the information regarding the nominal performances, and the type of the control problem (setpoint tracking/disturbance rejection) are available. 

The CRPEP problem for the integrating or slow first order system involves the design of a control relevant weight that de-emphasizes the low-frequency steady-state fit of the model and focuses on the control-relevant dynamics through a notch emphasis. As the desired speed of response increases, this region of interest shifts towards the right of the open-loop bandwidth, more and more to the high frequency region, and as a result the control-relevant weight also shifts its notch emphasis to reduce the corresponding control-relevant modeling error. And this addresses the challenge of systematic emphasis.

![control_relevant_weight](https://github.com/user-attachments/assets/6d180596-e802-4d38-8d8e-46e79eb8229f) 

### The control-relevant weight can be realized in time domain using power spectrum of multisine input signals

![image](https://github.com/user-attachments/assets/acb80709-f4cc-4f92-a9ce-9cd19d2360d4)

![image](https://github.com/user-attachments/assets/1bcfb8e1-2644-4313-929a-c64d95f92728)

