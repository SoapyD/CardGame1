
local quads = {};


function Test_quad_method()
	Quad_Add()
end

function Quad_Add()

    id = table.getn(quads)+1
    quads[id] = "icon"
    id = table.getn(quads)+1
    quads[id] = "icon2"

    print("length" .. table.getn(quads))

end