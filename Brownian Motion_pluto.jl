### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3cd4871c-752f-11eb-333f-1d2e3567ec55
begin 
	using Plots
	using PlutoUI
	using LinearAlgebra
	using DataFrames
	using Statistics
	using Images
end

# ╔═╡ df34410c-755a-11eb-39b3-67895a4e5251
md"""
# Photon Nudging of Active Particles
"""

# ╔═╡ 980f8ad2-7624-11eb-2018-1d7b09a81cb4
md"""
**Frank Cichos, Molecular Nanophotonics Group 2021**

This Notebook describes and plots some basic features of active particles and **photon nudging**. Photon nudging is a technique, which is using the information about the orientation of an active particle in space with respect to a target position to propel or not propel the particle. The particle is thus correlating its activity with its orientation in the lab frame. In its simplest form, the active motion is switched on and off in a binary way. This can be imagined to be a form of vision interaction, i.e. an animal that this only moving towards a target when seeing the target, while it stays passive or undecided about its direction of motion when it is not seeing the target.

$(load("./nudging.png"))

The work on photon nudging is described in detail in the following publications:

[1]	Qian, B., Montiel, D., Bregulla, A., Cichos, F. & Yang, H. Harnessing thermal fluctuations for purposeful activities: the manipulation of single micro-swimmers by adaptive photon nudging. **Chem Sci 4**, 1420–1429 (2013).

[2]	Bregulla, A. P., Yang, H. & Cichos, F. Stochastic Localization of Microswimmers by Photon Nudging. **ACS Nano 8**, 6542–6550 (2014).

[3]	Selmke, M., Khadka, U., Bregulla, A. P., Cichos, F. & Yang, H. Theory for controlling individual self-propelled micro-swimmers by photon nudging I: directed transport. **Physical Chemistry Chemical Physics 20**, 10502–10520 (2018).

[4]	Selmke, M., Khadka, U., Bregulla, A. P., Cichos, F. & Yang, H. Theory for controlling individual self-propelled micro-swimmers by photon nudging II: confinement. **Physical Chemistry Chemical Physics 20**, 10521–10532 (2018).

[5]	Khadka, U., Holubec, V., Yang, H. & Cichos, F. Active particles bound by information flows. **Nat Commun 9**, 3864 (2018).


"""

# ╔═╡ 7a3fa976-7602-11eb-37db-6fc90b1fc7f1
md"""
## 1. Active Particle Motion 


Active particles have in contrast to passive particle in a flow a velocity vector that is fixed in the particles reference frame. The velocity vector is therefore diffusing in its orientation with the particle orientation. Thus if measured in the lab reference frame the particle motion seems random at long time, however, in the particle frame the particle seems to follow a constant flow (see figure below). 

$(load("./trajanalysis.png"))
"""

# ╔═╡ 3b71f35e-7625-11eb-0764-0ba39e0a0af2
md"""
### 1.1 Creating Active Particle Synthetic Data

Below are two functions which are used to generate trajectories of active particles that are comtinuously propelled. The first function is used to rotatet a 2D vector in plane by an angle. The second function is the actual trajectory generation function is takes the following parameters and delivers
"""

# ╔═╡ d17882f0-75ad-11eb-022b-73883c9ed8f5
md"""
### 1.2 Active Particle Displacement Analysis in the Lab Frame
The diagrams below plot the trajectory of the active particle as well as the displacement statistics in the lab frame. 
The displacement statistics is obtained 

\begin{equation}
\Delta {\bf r}(\tau)={\bf r}(t+\tau) - {\bf r}(t)
\end{equation}


from the displacement vector between two snapshots of the particle seperated by the time $\tau$. 
In the case of a normal Brownian motion, the displacement statistics along the x and y-direction would be Gaussian and described by

\begin{equation}
p(\tau)=\frac{1}{\sqrt{2\pi D \tau}}\exp\left(-\frac{x^2}{4D\tau}\right)
\end{equation}

For the active particel in the lab frame, the displacment distributions **are not** anymore Gaussian shaped. In general, they show two distinct maxima. This is due to the fact that either the x or the y-component of the displacement result from $\Delta x=v\cos(\phi)\Delta t$ or $\Delta y=v\sin(\phi)\Delta t$. Thus if the variable $\phi$ is equally distributed, the probability is maximum where the sine or cosine function has zero slope. The peaks are broadened by the noise of the Brownian motion. 


"""

# ╔═╡ b9076018-755a-11eb-0d3f-3f3c6cabd7f6
md"""
number of steps: 	$(@bind N Slider(100:100000,show_value=true))

particle velocity: 	$(@bind vp Slider(0:0.1:20,show_value=true))

particle radius: $(@bind R Slider(0.2e-6:0.1e-7:2e-6,show_value=true))
"""

# ╔═╡ 1189ad6c-75ac-11eb-37d3-49a903789949
md"""
## Functions
"""

# ╔═╡ 05e08b16-75ac-11eb-29e5-b1844502859c
kBT=4.14195e-21;

# ╔═╡ 1d0deeac-7541-11eb-3f04-0fb5d288c952
function D_T(η,R)
    return(kBT/(6*π*η*R))
end	

# ╔═╡ 4b52b9f0-7541-11eb-1daa-77a540e5ee85
function rotate(xy, radians)
    x, y = xy
    c, s = cos(radians), sin(radians)
    j = [c s ; -s c]
    m = j * [x; y]

    return([float(m[1]), float(m[2])])
end

# ╔═╡ dad68120-7540-11eb-20ea-65d9358958ca

function D_R(η,R)
    return(kBT/(8*π*η*R^3))
end

# ╔═╡ a039ef0e-755c-11eb-2e3e-f3212bed6481
function msd(_df,_dt,_N=1000)
    msd=zeros(_N)
    time=collect(1:_N)*_dt
    for i in collect(1:_N)
        msd[i]=mean(diff(_df.x[1:i:_N]).^2 .+mean(diff(_df.y[1:i:_N]).^2))
	end
    return(time,msd)
end

# ╔═╡ ff02cdc2-7542-11eb-0e19-6d46a31c2399
function genData(N,_D,_Dr,_v,dt)
    v=[_v,0]
    sigma=sqrt(2*_D*dt)
    sigma_r=sqrt(2*_Dr*dt)

    phi=sigma_r.*cumsum(randn(N));
    vx,vy=[fill(v[1],N),fill(v[2],N)];
    vv=[rotate([vx[i],vy[i]],phi[i]) for i in range(1,length=length(phi))];
	vv=permutedims(reshape(hcat(vv...), (length(vv[1]), length(vv))));
    #do the random walk
    x,y=[cumsum(_D*randn(N)+vv[:,1]*dt),cumsum(_D*randn(N)+vv[:,2]*dt)]; 

    index=[i for i in range(1,stop=N)]

	df=DataFrame(:x=>x,:y=>y,:frame=>index,:angle=>phi)
end;

# ╔═╡ 56769e70-7544-11eb-39a6-b3c1415e5766
begin
	
dt=0.05  # 50 ms time resolution
#vp=1   # 10 µm/s velocity
D=D_T(1e-3,R)*1e12   # µm^2/s diffusion coefficient
Dr=D_R(1e-3,R)   #  rad^2/s rotational diffusion


# generate the trajectory and store it in a Pandas DataFrame
df=genData(N,D,Dr,vp,dt)

end

# ╔═╡ 7b48994c-7625-11eb-2340-311d8e6b825f
histogram2d(diff(df.x),diff(df.y),bins=50,color=:binary,frame=:box,size=(350,300),leg=false,lims=(-1.5,1.5))

# ╔═╡ b9465ab2-755c-11eb-37cc-f52bfecf74ff
tm,ms=msd(df,dt,N);

# ╔═╡ ebf223ea-7559-11eb-2ad3-4fdd3806b8f3
let 
a=plot(df.x,df.y,size=(300,300),lims=(-1000,1000),frame=:box,leg=false,xaxis="x",yaxis="y");
b=plot(tm,ms,xlim=(dt,600),ylim=(1,200000),frame=:box,size=(300,300),xaxis=("time",:log),yaxis=("msd",:log),leg=false);
	plot(a,b,size=(700,300))
end

# ╔═╡ 180d42d2-7626-11eb-31d8-ab22565c435e
md"**Default Plot Setup**"

# ╔═╡ 166e3044-7626-11eb-3034-17dc22943a9c
default(size=(400,400),
    leg=false,
    fmt=:png,
    framestyle=:box,
    msw=0,
    tickfont = font(12, "DejaVu Sans"),
    guidefontsize=14)

# ╔═╡ Cell order:
# ╟─df34410c-755a-11eb-39b3-67895a4e5251
# ╟─3cd4871c-752f-11eb-333f-1d2e3567ec55
# ╟─980f8ad2-7624-11eb-2018-1d7b09a81cb4
# ╟─7a3fa976-7602-11eb-37db-6fc90b1fc7f1
# ╟─3b71f35e-7625-11eb-0764-0ba39e0a0af2
# ╟─d17882f0-75ad-11eb-022b-73883c9ed8f5
# ╟─b9076018-755a-11eb-0d3f-3f3c6cabd7f6
# ╟─ebf223ea-7559-11eb-2ad3-4fdd3806b8f3
# ╟─7b48994c-7625-11eb-2340-311d8e6b825f
# ╟─1189ad6c-75ac-11eb-37d3-49a903789949
# ╟─b9465ab2-755c-11eb-37cc-f52bfecf74ff
# ╟─05e08b16-75ac-11eb-29e5-b1844502859c
# ╠═56769e70-7544-11eb-39a6-b3c1415e5766
# ╟─1d0deeac-7541-11eb-3f04-0fb5d288c952
# ╟─4b52b9f0-7541-11eb-1daa-77a540e5ee85
# ╟─dad68120-7540-11eb-20ea-65d9358958ca
# ╟─a039ef0e-755c-11eb-2e3e-f3212bed6481
# ╟─ff02cdc2-7542-11eb-0e19-6d46a31c2399
# ╟─180d42d2-7626-11eb-31d8-ab22565c435e
# ╟─166e3044-7626-11eb-3034-17dc22943a9c
