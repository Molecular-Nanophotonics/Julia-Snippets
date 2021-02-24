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

# ╔═╡ fe10bbe4-74ee-11eb-1d57-17300207ec2f
begin
	using Plots
	using PlutoUI
	using TDMSReader
	using Images
end

# ╔═╡ 2b6d2cb6-75fb-11eb-1704-e11a4ce1731d
md"""
# TDMS files in Pluto
"""

# ╔═╡ 4015bb9a-75fb-11eb-13d5-21f69f87b0ac
md"""
## Show the properties
"""

# ╔═╡ 44eba7aa-750c-11eb-074f-675eaafefefa
md"""
## Functions
"""

# ╔═╡ 96df6b00-7507-11eb-13ee-99b917dcdc02
function analyzeTDMS(file)
    # Print properties and channels of TDMS file
    tdms_file = TDMSReader.readtdms(file)
    println("Properties (Root):")
    for (name, value) in tdms_file.props
        println("  ", "$name: $value")
    end
    for (group_name, group) in tdms_file.groups
        println("\"", group_name, "\"")
        println("Properties (\"", group_name, "\")")
        for (name, value) in group.props
            println("  ", "$prop_key: $prop")
        end
        for (channel_name, channel) in group.channels
            println("  ", channel_name)
        end
    end
end;

# ╔═╡ a6c1577c-7507-11eb-36b6-cd3ec71422f0
with_terminal() do
	analyzeTDMS("72/Data/Martin/TDMS_Tests/Set_001_video.tdms")
end

# ╔═╡ 9b11a3c8-7507-11eb-1713-cb80d501d2ec

function loadTDMS_Video(file)
    tdms_file = TDMSReader.readtdms(file)
    props = tdms_file.props
    p = Dict(
        "dimx" => parse(Int, props["dimx"]),
        "dimy" => parse(Int, props["dimy"]),
        "frames" => parse(Int, props["dimz"]),
        "binning" => parse(Int, props["binning"]),
        "exposure_time" => parse(Float64, props["exposure"]),
    )
    images = permutedims(reshape(tdms_file["Image"]["Image"].data, p["dimx"], p["dimy"], p["frames"]), [3, 2, 1])
    return images, p
end;

# ╔═╡ d977c482-7508-11eb-1b56-09d76eca5922
images, p = loadTDMS_Video("72/Data/Martin/TDMS_Tests/Set_001_video.tdms");

# ╔═╡ bdefe556-75b8-11eb-2732-57f38df946c7
@bind frame Clock(p["exposure_time"])

# ╔═╡ e177f9ba-7508-11eb-2b90-2d113ab66f12
let 
	data_index = mod1(frame, p["frames"])
	Gray.(Float64.(images[data_index,:,:]/maximum(images[data_index,:,:])))
end

# ╔═╡ 19b03fea-75b8-11eb-2f47-29154a4a5a52
size(images[1,:,:])

# ╔═╡ Cell order:
# ╟─2b6d2cb6-75fb-11eb-1704-e11a4ce1731d
# ╟─4015bb9a-75fb-11eb-13d5-21f69f87b0ac
# ╟─a6c1577c-7507-11eb-36b6-cd3ec71422f0
# ╟─d977c482-7508-11eb-1b56-09d76eca5922
# ╟─bdefe556-75b8-11eb-2732-57f38df946c7
# ╠═e177f9ba-7508-11eb-2b90-2d113ab66f12
# ╟─19b03fea-75b8-11eb-2f47-29154a4a5a52
# ╟─44eba7aa-750c-11eb-074f-675eaafefefa
# ╟─fe10bbe4-74ee-11eb-1d57-17300207ec2f
# ╟─96df6b00-7507-11eb-13ee-99b917dcdc02
# ╟─9b11a3c8-7507-11eb-1713-cb80d501d2ec
