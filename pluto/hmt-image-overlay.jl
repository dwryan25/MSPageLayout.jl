### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ b8e7998b-7170-4f28-b2b7-e1392d20943e
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.add("HmtArchive")
	using HmtArchive.Analysis
	Pkg.add("PlutoUI")
	using PlutoUI
	Pkg.add("Downloads")
	using Downloads
	Pkg.add("FileIO")
	using FileIO
	Pkg.add("Images")
	using Images
	Pkg.add("Luxor")
	using Luxor


	Pkg.add("CitableBase")
	using CitableBase
	Pkg.add("CitableObject")
	using CitableObject
	Pkg.add("CitableText")
	using CitableText
	Pkg.add("CitableImage")
	using CitableImage
	Pkg.add("CitablePhysicalText")
	using CitablePhysicalText

	Pkg.status()
end


# ╔═╡ 6a150e50-1f6d-11ee-0f75-9506d1fd1b64
md"# Overlay HMT data on images"

# ╔═╡ 288f5cb6-11b7-43d0-80f0-1ca818a08e63
md""" *Overlay edited info*$(@bind with_overlay CheckBox(default=false))"""

# ╔═╡ c1aa6499-9b37-4426-adea-bc97aa21e888
md"""*Set width of image (pixels), and click* `Submit` $(@bind chosenht confirm(Slider(200:50:1000, show_value=true)))"""

# ╔═╡ df078657-96e0-4918-b2d9-cc725c7845ca
md"""*Set image transparency* $(@bind alpha Slider(0:0.1:1.0, show_value=true, default=0.5))"""

# ╔═╡ c53c0426-fb20-4298-bd30-9151802fd7c0
md"""*Padding* $(@bind pagepadding Slider(0:15, show_value=true))"""

# ╔═╡ dbe46c81-29f6-4511-a7c8-808f3cf2c60d


# ╔═╡ 8c25c52b-a892-4612-ac76-f2db398a8102
html"""
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>

<hr/>
"""

# ╔═╡ 8ccc4247-0cdd-47ca-8e8a-3a5d735ab3e3
md"> **UI**"

# ╔═╡ 54c8266f-5324-4be4-ac43-99ffd0743140
siglummenu = [
	"msA", "msAim", "msAint", "msAext", "msAil"
]

# ╔═╡ 55a71d9d-8190-49fd-8a47-4d7c6b5cf157
md"""*Scholia* $(@bind siglum Select(siglummenu))"""

# ╔═╡ ce1749d9-4f43-4232-b83e-9fb1b608a57f
md"> **HMT data**"

# ╔═╡ 37827a98-b238-4d7d-934c-4617f5d01a6f
data = hmt_cex()

# ╔═╡ 26593ca7-e3bf-4d1a-a121-7001ab017f5f
dse = hmt_dse(data)[1]

# ╔═╡ 98c4d279-1e19-461c-a34f-1c430fac53fa
# ╠═╡ show_logs = false
rois = hmt_pagerois(data).index

# ╔═╡ def3fff3-3b5c-478f-9f26-3466d95e4f8c
mss = hmt_codices(data)

# ╔═╡ 87a9f7d2-0c6d-4fff-8b2c-dbad2fcffd05
va = mss[6]

# ╔═╡ 1dfe1afe-5371-4e37-be9a-5cfcc8495b01
menu = map(va.pages) do pg
	 pg.urn => objectcomponent(pg.urn)
end

# ╔═╡ 5376fabb-a269-4f8e-94e0-ef51f4cd130b
md"""*Select a page and click* `Submit` $(@bind pg confirm(Select(menu)))"""

# ╔═╡ 1a94d396-9dd1-43e3-b369-f9efc29eb6b3
md"""### Manuscript page $(objectcomponent(pg))"""

# ╔═╡ 39f32acc-2eb1-4e28-8fc5-9f9f2d29803c
md"> **Iliad text**"

# ╔═╡ e28b9476-33be-4503-9f22-e66fe8b6e463
pagetexts = with_overlay ?  textsforsurface(pg, dse) : []

# ╔═╡ a6c7dfaa-0053-4b00-8bde-9d69c0e5e355
iliadlines = filter(pagetexts) do txt
	startswith(workcomponent(txt), "tlg0012.tlg001")
end

# ╔═╡ a9db86db-1512-4275-a522-3a4602cf12c8
iliadlines

# ╔═╡ c53ff7ed-f849-4f46-8bf6-b2f72b23dc9f
iliadimages = map(iliadlines) do txt
	imagesfortext(txt, dse)[1]
end

# ╔═╡ 6b410377-bb01-4b45-ae44-f453ac12e688
md"""> **Diagramming**"""

# ╔═╡ dfede8c9-88d9-49ab-9775-73940b897e90
pageroiurn = filter(pr -> pr[1] == pg, rois)[1][2]

# ╔═╡ 52d2e6d6-3093-4f3e-b475-664eaf321345
pageroiurn

# ╔═╡ 92bee788-0077-4964-b49a-5bf320ae0f3e
md"> **Image service**"

# ╔═╡ 1d67b8a2-4e15-4b1a-893d-c20e922e8e62
imgsvcurl = "http://www.homermultitext.org/iipsrv"

# ╔═╡ 1ec9b994-e5cd-4b86-b249-4b1389d5b191
imgsvcroot = "/project/homer/pyramidal/deepzoom"

# ╔═╡ 721e5ec1-8648-4844-846f-7dee53318ea8
imgservice = IIIFservice(imgsvcurl, imgsvcroot)

# ╔═╡ bb012734-9d1a-4521-94b9-3dcc1f5b2310
"""Retreive an image for a page identified by URN."""
function pageimage(pg, roituples; ht = 200)
	prs = filter(pr -> pr[1] == pg, roituples)
	if isempty(prs) 
		nothing 
	else
		imgu = prs[1][2]
		iifrequest = url(dropsubref(imgu), imgservice, ht = ht)
		f = Downloads.download(iifrequest)
		img = load(f)
		rm(f)
		img
	end
end

# ╔═╡ 7b7e59be-17d5-4694-9273-3cc4b9d510e9
img = begin
	pgimg = pageimage(pg, rois, ht = chosenht)
	isnothing(pgimg) ? nothing : RGBA.(pgimg, alpha)
end

# ╔═╡ d585578b-cea2-4319-a644-704a4fa4a274


# ╔═╡ b02b2c35-ea16-4604-8505-6d853b9564ec
(h,w) = isnothing(img) ? (nothing, nothing) : img |> size

# ╔═╡ e3b939a5-d829-4b87-8ec5-0ae631763fdc
isnothing(img) ? md"" : md"""Image height and width: **$(h)** x **$(w)**"""

# ╔═╡ e21a5c08-ff3b-4afc-9868-81c599ebd96e
hpad = isnothing(h) ? nothing : h + pagepadding

# ╔═╡ efcf699c-bb94-4659-a494-0abab0685360
wpad = isnothing(w) ? nothing : w + pagepadding

# ╔═╡ 10d5da87-81f7-4e0d-8ce3-b7aa505adc5c
md"> **Util that belongs in package**"

# ╔═╡ 9aebe925-cc2d-400e-896f-4670d02edfd4
function imagefloats(imgu::Cite2Urn; digits = 3)
    parts = split(subref(imgu),",")
    if length(parts) == 4
        floats = map(roi -> parse(Float64, roi), parts)
        map(num -> round(num, digits=digits), floats)
    else
        throw(ArgumentError("""Invalid region of interest in urn `$(imgu)`:  expression must have four comma-separated parts.""")) 
    end
end

# ╔═╡ cb84450f-72b8-4e7d-9903-8edbd8781fed
iliadrois = imagefloats.(iliadimages)

# ╔═╡ 8a3441a5-6907-4814-9143-c8c5bfadfc5f
if with_overlay
	if isempty(iliadrois)
		md"No *Iliad* lines on this page"
	else
		rng = string(passagecomponent(iliadlines[1]), "-", passagecomponent(iliadlines[end]))
		md"""#### *Iliad* $(rng)"""
	end
end

# ╔═╡ 9a150a1e-0d87-4c01-8111-88a4b4a53dd9
box1 = iliadrois[1]

# ╔═╡ 4c3fc3a6-9c7f-4c8c-9538-4060851cb825
iliadrois[1]

# ╔═╡ 402fc274-21c9-4b1c-afdd-d5dd89c6fe2a
	pagepcts = imagefloats(pageroiurn)

# ╔═╡ 60ef94df-fdc3-4cfa-8523-c8a0fb67aba9
pageroi = begin

	[pagepcts[1] * w, pagepcts[2] * h, pagepcts[3] * w, pagepcts[4] * h]
end

# ╔═╡ e9de2598-3d08-4105-ba1b-497d4420d575
(xoffset, yoffset) = (pageroi[1], pageroi[2])

# ╔═╡ 8ee088d5-b468-4c91-ac11-c4e1d8da15a4
srch = h + xoffset

# ╔═╡ 34a742d3-6c62-4622-9af9-e56979736796
srcw = w + yoffset

# ╔═╡ b2609b83-75a7-4cf6-8a8b-9615d6618d1d
if isnothing(img)
	nothing
else
@draw begin
	# Set coordinate system with origin at top left:
	translate(-1 * wpad/2, -1 * hpad/2)
	placeimage(img,O)


	sethue("green")
	for ir in iliadrois
		x =  ir[1] * srcw 
		y = ir[2] * srch 
		line(Point(x,y), Point(x + 200, y), :stroke)
	end
	
#	rect(iliadleft * srcw, iliadtop * srch, iliadw * srcw, iliadh * srch, :stroke)
	
	
end  wpad hpad
end

# ╔═╡ Cell order:
# ╟─b8e7998b-7170-4f28-b2b7-e1392d20943e
# ╟─6a150e50-1f6d-11ee-0f75-9506d1fd1b64
# ╟─5376fabb-a269-4f8e-94e0-ef51f4cd130b
# ╟─1a94d396-9dd1-43e3-b369-f9efc29eb6b3
# ╟─8a3441a5-6907-4814-9143-c8c5bfadfc5f
# ╟─55a71d9d-8190-49fd-8a47-4d7c6b5cf157
# ╟─288f5cb6-11b7-43d0-80f0-1ca818a08e63
# ╟─c1aa6499-9b37-4426-adea-bc97aa21e888
# ╟─e3b939a5-d829-4b87-8ec5-0ae631763fdc
# ╟─df078657-96e0-4918-b2d9-cc725c7845ca
# ╟─c53c0426-fb20-4298-bd30-9151802fd7c0
# ╠═52d2e6d6-3093-4f3e-b475-664eaf321345
# ╠═60ef94df-fdc3-4cfa-8523-c8a0fb67aba9
# ╠═dbe46c81-29f6-4511-a7c8-808f3cf2c60d
# ╠═e9de2598-3d08-4105-ba1b-497d4420d575
# ╠═b2609b83-75a7-4cf6-8a8b-9615d6618d1d
# ╠═9a150a1e-0d87-4c01-8111-88a4b4a53dd9
# ╠═4c3fc3a6-9c7f-4c8c-9538-4060851cb825
# ╠═8ee088d5-b468-4c91-ac11-c4e1d8da15a4
# ╠═34a742d3-6c62-4622-9af9-e56979736796
# ╟─8c25c52b-a892-4612-ac76-f2db398a8102
# ╟─8ccc4247-0cdd-47ca-8e8a-3a5d735ab3e3
# ╟─1dfe1afe-5371-4e37-be9a-5cfcc8495b01
# ╟─54c8266f-5324-4be4-ac43-99ffd0743140
# ╟─ce1749d9-4f43-4232-b83e-9fb1b608a57f
# ╟─37827a98-b238-4d7d-934c-4617f5d01a6f
# ╠═26593ca7-e3bf-4d1a-a121-7001ab017f5f
# ╠═98c4d279-1e19-461c-a34f-1c430fac53fa
# ╠═def3fff3-3b5c-478f-9f26-3466d95e4f8c
# ╠═87a9f7d2-0c6d-4fff-8b2c-dbad2fcffd05
# ╟─39f32acc-2eb1-4e28-8fc5-9f9f2d29803c
# ╠═e28b9476-33be-4503-9f22-e66fe8b6e463
# ╠═a6c7dfaa-0053-4b00-8bde-9d69c0e5e355
# ╠═a9db86db-1512-4275-a522-3a4602cf12c8
# ╟─c53ff7ed-f849-4f46-8bf6-b2f72b23dc9f
# ╠═cb84450f-72b8-4e7d-9903-8edbd8781fed
# ╟─6b410377-bb01-4b45-ae44-f453ac12e688
# ╠═e21a5c08-ff3b-4afc-9868-81c599ebd96e
# ╠═efcf699c-bb94-4659-a494-0abab0685360
# ╠═dfede8c9-88d9-49ab-9775-73940b897e90
# ╠═402fc274-21c9-4b1c-afdd-d5dd89c6fe2a
# ╟─92bee788-0077-4964-b49a-5bf320ae0f3e
# ╠═1d67b8a2-4e15-4b1a-893d-c20e922e8e62
# ╠═1ec9b994-e5cd-4b86-b249-4b1389d5b191
# ╠═721e5ec1-8648-4844-846f-7dee53318ea8
# ╠═bb012734-9d1a-4521-94b9-3dcc1f5b2310
# ╠═7b7e59be-17d5-4694-9273-3cc4b9d510e9
# ╠═d585578b-cea2-4319-a644-704a4fa4a274
# ╠═b02b2c35-ea16-4604-8505-6d853b9564ec
# ╟─10d5da87-81f7-4e0d-8ce3-b7aa505adc5c
# ╟─9aebe925-cc2d-400e-896f-4670d02edfd4
