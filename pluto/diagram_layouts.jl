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

	Pkg.add(url = "https://github.com/dwryan25/MSPageLayout.jl")
	using MSPageLayout

	Pkg.status()
end

# ╔═╡ 874b7016-1e70-11ee-06bd-6dffcdd850d4
md"""# Diagram page layout"""

# ╔═╡ 0e71905f-081e-4615-bee8-247ee9cbfa2e
md"""*Width of image (pixels)* $(@bind w confirm(Slider(200:50:800, show_value=true)))"""

# ╔═╡ 4aee9aab-f67e-4e39-b63a-baa194a07b8c
md"> *Consider option of underlaying image of page*"

# ╔═╡ dcce74ec-4d0c-4017-bcc5-58a6e07dbfe4
html"""
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
"""

# ╔═╡ 157d6250-b314-49ca-b715-0a483e51028f
md">For the package"

# ╔═╡ 2a659eb6-31bf-4059-ab75-ed77f4fad251
"""Compute top `y` value relative to page box for all scholia on page.

"""
function iliad_y_tops(pgdata::PageData; digits = 3)
    offset = pageoffset_top(pgdata, digits = digits)
    raw = map(pr -> iliad_y_top(pr, digits = digits) - offset, pgdata.textpairs)
    map(f -> round(f, digits = digits), raw)
end

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

# ╔═╡ e6ab2259-8225-4e08-ab93-23acd326ad06
hpad * .6

# ╔═╡ 00decc28-24bb-4c79-b3a0-e0e6f26574b0
md"""> Zoning the page"""

# ╔═╡ df5ff74c-435c-43ad-9e70-d23418b28721
scholia_left = .7 * w

# ╔═╡ 7503e0c3-6031-4488-88cc-0c11217101de
iliad_top = .2 * h

# ╔═╡ 015cd410-7dba-4ea1-a698-e467a400b4b2
iliad_bottom = .8 * h

# ╔═╡ d35364fb-183b-49e2-821b-2f212eb4fd39
iliad_middle_x = .35 * w

# ╔═╡ 9bada34b-0748-474d-9a97-4dff4736540f
md"> HMT data"

# ╔═╡ d167eb70-f471-444b-a1a7-abcb5dcc8471
data = hmt_cex()

# ╔═╡ c249767b-d6f0-4a2a-9fa9-2f8a818baadb
mss = hmt_codices(data)

# ╔═╡ ff7fa129-f715-4fb6-9701-6e4ea442c8c6
va = mss[6]

# ╔═╡ a98de624-0c28-4fa1-811d-edf0b1b76150
menu = map(va.pages[25:end]) do pg
	 pg.urn => objectcomponent(pg.urn)
end

# ╔═╡ a0ba2659-0b7b-482b-90f6-7baa83455722
md"""*Select a page* $(@bind pg confirm(Select(menu)))"""

# ╔═╡ 748768ed-4eed-4132-9973-f2a400862611
pg

# ╔═╡ 769c3530-378e-4f2e-a604-197f912bc947
# ╠═╡ show_logs = false
pagedata = pageData(pg, data = data)

# ╔═╡ caf2bdaa-0371-409b-a4b8-5a582d135333
isnothing(pagedata) ? md"No data for page $(objectcomponent(pg)):" : md"""Total of **$(length(pagedata.textpairs)) scholia** indexed on page $(objectcomponent(pg)). """

# ╔═╡ 31caf334-aede-4171-83b7-d26c93c131e1
@draw begin
	translate(-1 * w/2, -1 * h/2)

	
	sethue("deepskyblue")
	for y in iliad_y_tops(pagedata) 
		circle(iliad_middle_x, hpad * y, 3,  :fill)
	end
	
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
	
	sethue("azure3")
	line(Point(0, iliad_top), Point(scholia_left, iliad_top))
	line(Point(0, iliad_bottom), Point(scholia_left, iliad_bottom))
	strokepath()

	
	
end wpad hpad

# ╔═╡ 2d42c926-3785-4c97-a90d-ba0b17afb1df
hpad .* iliad_y_tops(pagedata) 

# ╔═╡ 19687df5-14cf-4591-87d6-e5de35cf6ef9
iliad_y_tops(pagedata) 

# ╔═╡ 31d93312-ce71-4f06-9026-38214882e1fe
iliad_y_tops(pagedata)

# ╔═╡ fff3a0df-699f-4e5e-9185-c47ef3764b06


# ╔═╡ Cell order:
# ╠═36927b11-2363-4d84-89a3-77cb4a63939a
# ╟─874b7016-1e70-11ee-06bd-6dffcdd850d4
# ╟─a0ba2659-0b7b-482b-90f6-7baa83455722
# ╟─caf2bdaa-0371-409b-a4b8-5a582d135333
# ╟─0e71905f-081e-4615-bee8-247ee9cbfa2e
# ╟─4aee9aab-f67e-4e39-b63a-baa194a07b8c
# ╠═31caf334-aede-4171-83b7-d26c93c131e1
# ╠═2d42c926-3785-4c97-a90d-ba0b17afb1df
# ╠═19687df5-14cf-4591-87d6-e5de35cf6ef9
# ╠═e6ab2259-8225-4e08-ab93-23acd326ad06
# ╟─dcce74ec-4d0c-4017-bcc5-58a6e07dbfe4
# ╟─157d6250-b314-49ca-b715-0a483e51028f
# ╠═31d93312-ce71-4f06-9026-38214882e1fe
# ╟─2a659eb6-31bf-4059-ab75-ed77f4fad251
# ╟─36973a8c-a31e-4d93-a61d-6906786ec079
# ╟─30f78169-805d-4c38-89c4-115ca7e4f3e7
# ╟─6302db98-daf9-480d-bdda-2e350245a1bc
# ╟─65ace1d4-eb73-4924-875c-d24798f6b8cd
# ╟─b405679c-ec6a-40e6-b8f5-44889233db9d
# ╟─00decc28-24bb-4c79-b3a0-e0e6f26574b0
# ╠═df5ff74c-435c-43ad-9e70-d23418b28721
# ╠═7503e0c3-6031-4488-88cc-0c11217101de
# ╠═015cd410-7dba-4ea1-a698-e467a400b4b2
# ╠═d35364fb-183b-49e2-821b-2f212eb4fd39
# ╟─9bada34b-0748-474d-9a97-4dff4736540f
# ╟─d167eb70-f471-444b-a1a7-abcb5dcc8471
# ╟─c249767b-d6f0-4a2a-9fa9-2f8a818baadb
# ╠═ff7fa129-f715-4fb6-9701-6e4ea442c8c6
# ╠═a98de624-0c28-4fa1-811d-edf0b1b76150
# ╠═748768ed-4eed-4132-9973-f2a400862611
# ╟─769c3530-378e-4f2e-a604-197f912bc947
# ╠═fff3a0df-699f-4e5e-9185-c47ef3764b06
