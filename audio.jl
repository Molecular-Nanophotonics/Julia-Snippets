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

# ╔═╡ 00f5deba-794b-11eb-3248-ffd7a108d6b3
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		"Plots",			
		"SampledSignals",
		"FFTW",
	])
	using Plots
	using SampledSignals
	using FFTW
end

# ╔═╡ 962f75b4-794a-11eb-0fb2-df5dbac1123e
md"""
# Live Audio Sampling and Spectral Anylsis
"""

# ╔═╡ 57b70420-e514-11ea-1a37-11efa5f2726c
@bind audio HTML("""
<audio id="player"></audio>
<button class="button" id="stopButton">Stop</button>
<script>
  const player = document.getElementById('player');
  const stop = document.getElementById('stopButton');

  const handleSuccess = function(stream) {
    //const context = new AudioContext({ sampleRate: 44100 });
	const context = new (window.AudioContext || window.webkitAudioContext)();

    const analyser = context.createAnalyser();
    const source = context.createMediaStreamSource(stream);

    source.connect(analyser);
    
    const bufferLength = analyser.frequencyBinCount;
    
    let dataArray = new Float32Array(bufferLength);
    let animFrame;
    
    const streamAudio = () => {
      animFrame = requestAnimationFrame(streamAudio);
      analyser.getFloatTimeDomainData(dataArray);
      player.value = dataArray;
      player.dispatchEvent(new CustomEvent("input"));
    }

    streamAudio();

    stop.onclick = e => {
      source.disconnect(analyser);
      cancelAnimationFrame(animFrame);
    }
  }

  navigator.mediaDevices.getUserMedia({ audio: true, video: false })
    .then(handleSuccess)
</script>

""")

# ╔═╡ dca970a2-e514-11ea-2975-0be3321223c8
plot(domain(SampleBuf(Array(audio), 44100/8)), SampleBuf(Array(audio), 44100/8), legend=false, ylims=(-1,1),size=(600,300))

# ╔═╡ dffb951c-794b-11eb-3467-7355a37c955e
begin 
t=domain(SampleBuf(Array(audio), 44100/8))
freqs = fftfreq(length(t), 1/0.00018140589569160998)
spec = fft(audio)
end;

# ╔═╡ 2151b316-7949-11eb-2aff-850ef98c6fca

plot(freqs,abs.(spec),ylim=(0,100),xlim=(0,1000),xaxis=("frequency [Hz]"))

# ╔═╡ a3e191a0-794b-11eb-32a7-d5a60a4ff783
default(size=(400,400),
    leg=false,
    fmt=:svg,
    framestyle=:box,
    msw=0,
    tickfont = font(12, "DejaVu Sans"),
    guidefontsize=14)

# ╔═╡ Cell order:
# ╟─962f75b4-794a-11eb-0fb2-df5dbac1123e
# ╟─00f5deba-794b-11eb-3248-ffd7a108d6b3
# ╟─57b70420-e514-11ea-1a37-11efa5f2726c
# ╠═dca970a2-e514-11ea-2975-0be3321223c8
# ╟─dffb951c-794b-11eb-3467-7355a37c955e
# ╟─2151b316-7949-11eb-2aff-850ef98c6fca
# ╟─a3e191a0-794b-11eb-32a7-d5a60a4ff783
