# Numerical simulation of speckle patterns

The purpose of the provided simulations is to model the behaviour of a system for targeted generation of speckle patterns using a phase-only Spatial Light Modulator (SLM) and a positive lens. The goal is to predict the intensity structure which is rapidly changing in the image planes near the Fourier plane of the lens. The main goal was to analyze the effects of deviations of the optical setup on the structure of generated patterns using numerical simulations based on Fourier optics. 

<p float="center">
  <img src="./readme_images/focus.png" width="300" />
  <img src="./readme_images/focus_shift_grain_size.png" width="300" /> 
  <img src="./readme_images/refrence_speckles.png" width="300" />
</p>

# Primary simulation
The primary simulation models an idealized setup without deviations, assuming 0° inicident angles and no pixel crosstalk.   
  
<p float="center">
  <img src="./readme_images/setup1.png" width="700" />
</p>  

In __sim1_main.m__ script, the user is allowed to upload a phase mask and set the distance of the observed plane from the lens. The pattern is generated by __sim1_generate_speckles()__ function. Setup parameters can be eventually changed in the __sim1_generate_speckles()__ function. Pre-set parameters are reflecting the actual setup.

# Full simulation
Second simulation introduces a beam expander with a width-controlling aperture and includes deviations of the system:  
- nonzero incident angle on SLM,  
- shift of the beam center from the middle of SLM,  
- beam radius (size of aperture),  
- angle of incidence on the lens,  
- shift of the beam center on the surface of lens,  
- crosstalk effect between neighboring pixels,  
- nonzero incident angle on the camera.    
  
  <p float="center">
  <img src="./readme_images/setup2.png" width="700" />
</p>    

In __sim2_main.m__ script the following parameters are being set: slm_angle $\alpha$, slm_beam_center, aperture $A$, lens_angle $\beta$, lens_beam_center, crosstalk $\sigma$, cam_angle $\gamma$, cam_plane and phase_mask. The pattern is calculated by __sim2_generate_speckles()__ function which includes fixed setup parameters.
