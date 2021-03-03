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

# ╔═╡ d8e25d5e-7044-11eb-184d-a9de63d17799
begin
	using Plots
	using PlutoUI
	pyplot()
end

# ╔═╡ 92b265f8-7063-11eb-157c-8d7284cfe2b0
html"<button onclick='present()'>present</button>"

# ╔═╡ 15532314-7044-11eb-2e19-739874a39522
md"""
# Demo Notebook for Pluto
"""

# ╔═╡ dba0016c-7059-11eb-205a-57f6af5d8eb8
md"""
## What is Pluto?

Pluto is a reactive notebook environment. It is based on the programming language Julia, which is still pretty new. Julia provides Just-In-Time compilation of the code and therefore executes code much faster than Python for example. It thereby reaches the speed of C++, but you don't have to take care of the compilation procedure. 

Pluto runs in your browser and also on our Jupyter Server. To start that for your account

1) Login to your Jupy Account
2) Start a Terminal 
3) If Pluto is not installed, type "julia" and then *import Pkg*, *Pkg.add("Pluto")* and *exit()* 
4) Then type *julia -e "import Pluto; Pluto.run(host=\\"127.0.0.1\\",launch\_browser=false,require\_secret\_for\_access=false)"*
5) Once Pluto is started you can access it in your Browser with *http://139.18.53.128:8000/user/USERNAME/proxy/123X/*, just replace USERNAME and look for the port X to put it in the address

Once you can access the Pluto server you may want to take your time to go through the rather simple interface and notice two main features

- nice separation of code and output, which makes your notebook readable
- reactivity that comes with your code, but needs some change in how to tackle problems
"""

# ╔═╡ c38950ea-71bc-11eb-0450-3bc76ac11a92
md"""
## Installing Julia Notebook

If the button for the Julia Notebook version is not installed on your acount, you can also add this. This is, however, not required for running Pluto.

1. Open the terminal on your account
2. start Julia by typing *julia*
3. type *import Pkg; Pkg.add("IJulia")
4. Login and logout of Jupyter if the button is not available

"""

# ╔═╡ 7daed70a-7044-11eb-1bea-a1358449e568
md"""
## So what is reactivity?

Reactivity refers to the fact that your whole notebook responds to changes you make locally. Imagine we define a variable **ende** below
"""

# ╔═╡ 39ae4f6c-705e-11eb-101e-57a4fce05c11
md""" 
and we then do a calculation in a different cell with this variable
"""

# ╔═╡ 785877ac-7044-11eb-315d-95888af2e23a
ende=π*2

# ╔═╡ 782da338-7044-11eb-38cd-89b900ded996
sin(ende)

# ╔═╡ 4ecd4d80-705e-11eb-272e-93482e0b8328
md"""
Reactivity now means, that whenever you change the variable **ende**, your notebook updates all other function that use this variable. This brings in some issue you have to keep in mind, which is the fact that you cannot have the same variable defined again in any other cell. So another cell with 

`ende=12`

would break the notebook and create an error. 
"""

# ╔═╡ 342889e4-7064-11eb-3e02-0f583c20a9b5
md"""This kind of reactivity has some important consequence on the structure of your notebook. Due to this connection between the cells, it is unimportant where your put the cells. You can put function and also variable definitions at the end of your notebook and Pluto will still handle everything correctly.

Thus all the cludder that is typically somewhere in your notebook can be hidden at the end, which will, together with the ability to hide code cells, make your notebook much more readable.
"""

# ╔═╡ 46cfec62-7065-11eb-28d8-e3354a55b0e6
md"""
## Interactivity

The speed of Julia and the reactivity allows your now to create also very interactive notbooks, which turn out to be extremely useful also in the field of data analysis, but also for teaching.
"""

# ╔═╡ 81890792-7065-11eb-1430-879819638c77
md"""
A tiny module *PlutoUI* provides some basic widgets for an interaction with your notbook. Yu will gain access to sliders, checkboxes, dropdown menus but also clocks.
Let's have a look at a simple example.
"""

# ╔═╡ bf1735ae-7065-11eb-1df3-b18d0f9f2800
md"""
We would like to plot some data within a certain range from ($x\_{min}$ ,$x\_{max}$)
We can easily define a slider for both values and connect a variable to them. This is done with the 

`@bind`

macro.
"""

# ╔═╡ 015aa78e-7066-11eb-237b-3fbb22bc79b4
@bind var Slider(0:0.1:π,show_value=true)


# ╔═╡ 3091601a-7066-11eb-1c14-03fd4aed297d
md"""
To make it a bit nice, we can add some text to the slider 
"""

# ╔═╡ 4580feb0-7066-11eb-2236-4f6768a41125
md"""
x\_min: $(@bind xmin Slider(0:0.01:5*π,default=0,show_value=true)) 

x\_max: $(@bind xmax Slider(0:0.01:5*π,default=π,show_value=true)) 
"""

# ╔═╡ a012fd58-7044-11eb-028f-15ecea4fa524
x=collect(xmin:(xmax-xmin+1)/1000:xmax)

# ╔═╡ c08dcb08-7044-11eb-32ea-27b9e80c61cf
y=sin.(x)

# ╔═╡ 3d133936-7045-11eb-3824-012d5be12d51
md"show the plot: $(@bind do_plot CheckBox(0))"

# ╔═╡ cddff81c-7044-11eb-3f8a-5939b189c7d9
if do_plot
	plot(x,y)
end

# ╔═╡ 8972f504-748a-11eb-1b7c-c5522c44ba62
import Pkg; Pkg.update("Pluto")

# ╔═╡ 8930cf2a-767f-11eb-33b4-299baa74df5d
@bind dims html"""
<canvas width="200" height="200" style="position: relative"></canvas>

<script>
// 🐸 `currentScript` is the current script tag - we use it to select elements 🐸 //
const canvas = currentScript.closest('pluto-output').querySelector("canvas")
const ctx = canvas.getContext("2d")

var startX = 80
var startY = 40

function onmove(e){
	// 🐸 We send the value back to Julia 🐸 //
	canvas.value = [e.layerX - startX, e.layerY - startY]
	canvas.dispatchEvent(new CustomEvent("input"))

	ctx.fillStyle = '#ffecec'
	ctx.fillRect(0, 0, 200, 200)
	ctx.fillStyle = '#3f3d6d'
	ctx.fillRect(startX, startY, ...canvas.value)
}

canvas.onmousedown = e => {
	startX = e.layerX
	startY = e.layerY
	canvas.onmousemove = onmove
}

canvas.onmouseup = e => {
	canvas.onmousemove = null
}

// Fire a fake mousemoveevent to show something
onmove({layerX: 130, layerY: 160})

</script>
"""

# ╔═╡ 35ab60a8-7a0e-11eb-1445-51409aa29336
struct Foldable{C}
    title::String
    content::C
end


# ╔═╡ 3eb137f4-7a0e-11eb-2b5c-3947144d3cf2

function Base.show(io, mime::MIME"text/html", fld::Foldable)
    write(io,"<details><summary>$(fld.title)</summary><p>")
    show(io, mime, fld.content)
    write(io,"</p></details>")
end

# ╔═╡ 5a3a0e7e-7a0e-11eb-1325-25b8ace1f1d7
Foldable("What is the gravitational acceleration?", md"Correct, it's ``\pi^2``.")

# ╔═╡ 5af94ad2-7a0e-11eb-30dc-e32516f7f954
Foldable("Some cool plot:", plot(0:0.1:10, x -> x^2,size=(400,300)))

# ╔═╡ 9d29fc58-7a0e-11eb-333c-29ad638a6ad2
html"""<details>
    <summary> A secret </summary>
    <p> Pluto is fun </p>
</details>"""

# ╔═╡ e23caf3e-7a0e-11eb-0508-df8e42361dd6
struct TwoColumn{L, R}
    left::L
    right::R
end

# ╔═╡ fcce48b2-7a0e-11eb-3a6b-9fdf35997161
function Base.show(io, mime::MIME"text/html", tc::TwoColumn)
    write(io, """<div style="display: flex;"><div style="flex: 50%;">""")
    show(io, mime, tc.left)
    write(io, """</div><div style="flex: 50%;">""")
    show(io, mime, tc.right)
    write(io, """</div></div>""")
end

# ╔═╡ 08433b44-7a0f-11eb-3a6b-f9f15f9a9041
TwoColumn(md"""
	**Figure 1:**
	Note the kink at ``x=0``! This is an abs() function taking the absolute value of a value. 
	
	Slider $(@bind scale Slider(0:0.01:1))
	""", plot(-5:5, abs, xaxis=("x-axis"),yaxis=("y-axis")))

# ╔═╡ 574692c0-7a11-11eb-3952-d360e6b3e927
md"""# Plot Defaults"""

# ╔═╡ f1838606-7a0f-11eb-333a-ab543ba49e14
default(size=(400,400),
    leg=false,
    fmt=:svg,
    framestyle=:box,
    msw=0,
    tickfont = font(12, "DejaVu Sans"),
    guidefontsize=14)

# ╔═╡ 85cf52cc-7aab-11eb-0868-595b3dc61f6d


# ╔═╡ Cell order:
# ╟─92b265f8-7063-11eb-157c-8d7284cfe2b0
# ╟─15532314-7044-11eb-2e19-739874a39522
# ╟─dba0016c-7059-11eb-205a-57f6af5d8eb8
# ╟─c38950ea-71bc-11eb-0450-3bc76ac11a92
# ╟─7daed70a-7044-11eb-1bea-a1358449e568
# ╟─39ae4f6c-705e-11eb-101e-57a4fce05c11
# ╠═785877ac-7044-11eb-315d-95888af2e23a
# ╠═782da338-7044-11eb-38cd-89b900ded996
# ╟─4ecd4d80-705e-11eb-272e-93482e0b8328
# ╟─342889e4-7064-11eb-3e02-0f583c20a9b5
# ╟─46cfec62-7065-11eb-28d8-e3354a55b0e6
# ╟─81890792-7065-11eb-1430-879819638c77
# ╟─bf1735ae-7065-11eb-1df3-b18d0f9f2800
# ╟─015aa78e-7066-11eb-237b-3fbb22bc79b4
# ╟─3091601a-7066-11eb-1c14-03fd4aed297d
# ╟─4580feb0-7066-11eb-2236-4f6768a41125
# ╟─a012fd58-7044-11eb-028f-15ecea4fa524
# ╟─c08dcb08-7044-11eb-32ea-27b9e80c61cf
# ╟─3d133936-7045-11eb-3824-012d5be12d51
# ╟─cddff81c-7044-11eb-3f8a-5939b189c7d9
# ╟─d8e25d5e-7044-11eb-184d-a9de63d17799
# ╠═8972f504-748a-11eb-1b7c-c5522c44ba62
# ╟─8930cf2a-767f-11eb-33b4-299baa74df5d
# ╟─35ab60a8-7a0e-11eb-1445-51409aa29336
# ╟─3eb137f4-7a0e-11eb-2b5c-3947144d3cf2
# ╟─5a3a0e7e-7a0e-11eb-1325-25b8ace1f1d7
# ╠═5af94ad2-7a0e-11eb-30dc-e32516f7f954
# ╟─9d29fc58-7a0e-11eb-333c-29ad638a6ad2
# ╠═e23caf3e-7a0e-11eb-0508-df8e42361dd6
# ╠═fcce48b2-7a0e-11eb-3a6b-9fdf35997161
# ╟─08433b44-7a0f-11eb-3a6b-f9f15f9a9041
# ╟─574692c0-7a11-11eb-3952-d360e6b3e927
# ╠═f1838606-7a0f-11eb-333a-ab543ba49e14
# ╠═85cf52cc-7aab-11eb-0868-595b3dc61f6d
