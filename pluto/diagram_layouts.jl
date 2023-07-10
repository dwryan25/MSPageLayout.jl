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

# ╔═╡ 36927b11-2363-4d84-89a3-77cb4a63939a
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.add("Luxor")
	using Luxor
	Pkg.add("Colors")
	using Colors
	Pkg.add("PlutoUI")
	using PlutoUI
	Pkg.add("HmtArchive")
	using HmtArchive.Analysis
	Pkg.add("CitableObject")
	using CitableObject
	Pkg.add("CitableText")
	using CitableText
	Pkg.add("CitablePhysicalText")
	using CitablePhysicalText

	Pkg.add(url = "https://github.com/dwryan25/MSPageLayout.jl")
	using MSPageLayout

	Pkg.update()

	Pkg.status()
end

# ╔═╡ 874b7016-1e70-11ee-06bd-6dffcdd850d4
md"""# Diagram page layout"""

# ╔═╡ 0e71905f-081e-4615-bee8-247ee9cbfa2e
md"""*Width of image (pixels)* $(@bind w confirm(Slider(200:50:800, show_value=true)))"""

# ╔═╡ dcce74ec-4d0c-4017-bcc5-58a6e07dbfe4
html"""
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
"""

# ╔═╡ 36973a8c-a31e-4d93-a61d-6906786ec079
md"> Framing the diagram"

# ╔═╡ 30f78169-805d-4c38-89c4-115ca7e4f3e7
padding = 5

# ╔═╡ 6302db98-daf9-480d-bdda-2e350245a1bc
wpad = w + 2 * padding

# ╔═╡ 65ace1d4-eb73-4924-875c-d24798f6b8cd
h = 1.5 * w

# ╔═╡ b405679c-ec6a-40e6-b8f5-44889233db9d
hpad = h + 2 * padding

# ╔═╡ 00decc28-24bb-4c79-b3a0-e0e6f26574b0
md"""> Zoning the page"""

# ╔═╡ df5ff74c-435c-43ad-9e70-d23418b28721
scholia_left = .7 * w

# ╔═╡ 7503e0c3-6031-4488-88cc-0c11217101de
#iliad_top = .2 * h

# ╔═╡ 015cd410-7dba-4ea1-a698-e467a400b4b2
#iliad_bottom = .8 * h

# ╔═╡ 9bada34b-0748-474d-9a97-4dff4736540f
md"> HMT data"

# ╔═╡ d167eb70-f471-444b-a1a7-abcb5dcc8471
data = hmt_cex()

# ╔═╡ 2f4a3f9b-cf9d-4097-ad5d-20c3865eb392
dse = hmt_dse(data)[1]

# ╔═╡ c249767b-d6f0-4a2a-9fa9-2f8a818baadb
mss = hmt_codices(data)

# ╔═╡ ff7fa129-f715-4fb6-9701-6e4ea442c8c6
va = mss[6]

# ╔═╡ a98de624-0c28-4fa1-811d-edf0b1b76150
menu = map(va.pages[25:end]) do pg
	 pg.urn => objectcomponent(pg.urn)
end

# ╔═╡ a0ba2659-0b7b-482b-90f6-7baa83455722
md"""*Select a page and click* `Submit` $(@bind pg confirm(Select(menu)))"""

# ╔═╡ 882de14a-a64b-4a73-9bee-366ff5442577
md"""#### Analyzing manuscript page $(objectcomponent(pg))"""

# ╔═╡ 063cafbb-5d63-4569-a45b-12e98a4b7649
# ╠═╡ show_logs = false
pgdata = pageData(pg)

# ╔═╡ 645ba380-a54f-4a79-ae0b-f24f59cc19b2
topoffset = pageoffset_top(pgdata) * hpad

# ╔═╡ 748768ed-4eed-4132-9973-f2a400862611
pg

# ╔═╡ 0f42eb04-fc71-4bf9-9390-4b9022b82a4b
md"> Data to diagram all *Iliad* lines"

# ╔═╡ acd34a2d-5af9-4a8e-a277-bb9b47d72631
iliadlines = filter(textsforsurface(pg, dse)) do txt
	startswith(workcomponent(txt), "tlg0012.tlg001")
end

# ╔═╡ 53def3ad-3d59-4004-9820-eca3ef3e9d52
iliadimages = map(iliadlines) do txt
	imagesfortext(txt, dse)[1]
end

# ╔═╡ e5d696f5-1237-4c9e-ba3c-b732114d917b
iliadrois = map(i -> MSPageLayout.imagefloats(i), iliadimages)

# ╔═╡ 8532acc6-67df-47c0-8184-899f4cebc4ed
iliadpadding = 0.15 * w

# ╔═╡ 31caf334-aede-4171-83b7-d26c93c131e1
@draw begin
	translate(-1 * w/2, -1 * h/2)

	
	sethue("gray30")
	line(O, Point(w,0))
	line(Point(w,0), Point(w, h))
	line(Point(w, h), Point(0,h))
	line(Point(0,h), O)
	strokepath()

	setdash("dot")
	sethue("olivedrab3")
	line(Point(scholia_left, 0), Point(scholia_left, h))
	strokepath()



	setdash("solid")
	sethue("snow3")
	for v in iliadrois
		itop = v[2] * hpad - topoffset
		line(Point(iliadpadding, itop), Point(scholia_left - iliadpadding, itop), :stroke)
	end
	#sethue("azure3")
	#line(Point(0, iliad_top), Point(scholia_left, iliad_top))
	#line(Point(0, iliad_bottom), Point(scholia_left, iliad_bottom))
	#strokepath()
	
end wpad hpad

# ╔═╡ Cell order:
# ╠═36927b11-2363-4d84-89a3-77cb4a63939a
# ╟─874b7016-1e70-11ee-06bd-6dffcdd850d4
# ╟─a0ba2659-0b7b-482b-90f6-7baa83455722
# ╟─882de14a-a64b-4a73-9bee-366ff5442577
# ╟─0e71905f-081e-4615-bee8-247ee9cbfa2e
# ╠═31caf334-aede-4171-83b7-d26c93c131e1
# ╠═063cafbb-5d63-4569-a45b-12e98a4b7649
# ╟─dcce74ec-4d0c-4017-bcc5-58a6e07dbfe4
# ╟─36973a8c-a31e-4d93-a61d-6906786ec079
# ╟─30f78169-805d-4c38-89c4-115ca7e4f3e7
# ╟─6302db98-daf9-480d-bdda-2e350245a1bc
# ╟─65ace1d4-eb73-4924-875c-d24798f6b8cd
# ╟─b405679c-ec6a-40e6-b8f5-44889233db9d
# ╟─00decc28-24bb-4c79-b3a0-e0e6f26574b0
# ╠═df5ff74c-435c-43ad-9e70-d23418b28721
# ╠═7503e0c3-6031-4488-88cc-0c11217101de
# ╠═015cd410-7dba-4ea1-a698-e467a400b4b2
# ╠═645ba380-a54f-4a79-ae0b-f24f59cc19b2
# ╟─9bada34b-0748-474d-9a97-4dff4736540f
# ╟─d167eb70-f471-444b-a1a7-abcb5dcc8471
# ╠═2f4a3f9b-cf9d-4097-ad5d-20c3865eb392
# ╟─c249767b-d6f0-4a2a-9fa9-2f8a818baadb
# ╠═ff7fa129-f715-4fb6-9701-6e4ea442c8c6
# ╠═a98de624-0c28-4fa1-811d-edf0b1b76150
# ╠═748768ed-4eed-4132-9973-f2a400862611
# ╟─0f42eb04-fc71-4bf9-9390-4b9022b82a4b
# ╟─acd34a2d-5af9-4a8e-a277-bb9b47d72631
# ╟─53def3ad-3d59-4004-9820-eca3ef3e9d52
# ╟─e5d696f5-1237-4c9e-ba3c-b732114d917b
# ╠═8532acc6-67df-47c0-8184-899f4cebc4ed
