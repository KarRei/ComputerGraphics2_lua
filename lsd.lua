
module("lsd", package.seeall) -- use filename as module name;
                            --    see all other modules, e.g., io

require("point")
require("vector")

NONE=-1
CAMERA=0
SCENE=1
mode=NONE			 -- no mode initially

sf=string.format		 -- more syntactic sugar!

cameraT = {}
sceneT = {} -- contains all objects and their parameters (the value is a table again)
 
counterSphere = 0
counterFace = 0
counterBox = 0


-- character classes for regexps here:
--  http://www.easyuo.com/openeuo/wiki/index.php/Lua_Patterns_and_Captures_(Regular_Expressions)
function matchTriple(str)	-- match, split a string like "(-1.2,3,4.4)"
  str = string.gsub(str, "%s", "")
  local _, _, x, y, z = string.find(str, "%((-?%d+%.?%d*),(-?%d+%.?%d*),(-?%d+%.?%d*)%)")
  return x, y, z
end

function processSphere(params)
  sphere = {}

  sphere["type"] = "sphere"
  
  for pair in string.gmatch(params, "[^;]+") do
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)")
    if k == "ctr" then
      local a, b, c = matchTriple(v)
      sphere["ctr"] = point.new(a, b, c)
    elseif k == "rad" then
      sphere["rad"] = v
    elseif k == "name" then
      sphere["name"] = v
    elseif k == "col" then
      sphere["col"] = v
    end
  end

  -- Create auto-generated name
  if sphere["name"] == nil then 
    counterSphere = counterSphere+1
    sphere["name"] = ("sphere#" .. counterSphere)
    print("Auto-generated:" .. sphere["name"])
  end

  -- Create bounding box and calculate its normals
  sphere["norms"] = plane.BBVerts(sphere["ctr"], sphere["rad"])

  return sphere
end

function processBox(params)
  box = {}
  box["type"] = "box"

  for pair in string.gmatch(params, "[^;]+") do -- the contents between the ;'s
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)") --looking for = , k:lhs, v:rhs
    if k == "name" then
      box["name"] = v --add key name with value v to box-table
    elseif k == "blf" then
      local a, b, c = matchTriple(v) -- putting the value of blf to local variables a,b,c
      box["blf"] = point.new(a, b, c)
      -- print(sf("a=%f...c=%f\n", a, c))
    elseif k == "trb" then
      local d, e, f = matchTriple(v)
      box["trb"] = point.new(d,e,f)
    end
  end

  -- Create auto-generated name
  if box["name"] == nil then
    counterBox = counterBox+1 
    box["name"] = ("box#" .. counterBox)
    print("Auto-generated:" .. box["name"])
  end

  -- Create normals and add to box
  box["norms"] = plane.boxNormals(box["blf"], box["trb"])

  return box
end

function processFace(params)
  face = {}

  face["type"] = "face"

  for pair in string.gmatch(params, "[^;]+") do
    local k, v
    _, _, k, v = string.find(pair, "(%w+)%s*=%s*(.*)")
    -- print(sf("Putting (%s,%s) in face object", k, v))
    if k == "verts" then
      points = {}
      for x, y, z in string.gmatch(v, "%((-?%d+%.?%d*),(-?%d+%.?%d*),(-?%d+%.?%d*)%)") do --
        p = point.new(x,y,z)
        table.insert(points, p)
      end
      face["verts"] = points
    elseif k == "name" then
      face["name"] = v
    elseif k == "col" then
      face["col"] = v
    end
  end

  -- Create auto-generated name
  if face["name"] == nil then 
    counterFace = counterFace+1
    face["name"] = ("face#" .. counterFace)
    print("Auto-generated:" .. face["name"])
  end

  -- consruct normal
  verts = face["verts"]
  vec1 = point.vector(verts[1], verts[2])
  vec2 = point.vector(verts[3], verts[2])
  n = vector.cross(vec1, vec2)
  normal = vector.norm(n)
  face["norms"] = {normal}
  print("constructing face normal from first three vertices of " .. face["name"] .. " only...")
  return face
end

function processScene(objdecl) -- declaration of an object
  -- local exact = sf(">%s<", objdecl)
  -- print("Scene declaration:", exact)

  local type, params = string.match(objdecl, "^%s*(%w+)%s*:%s*(.*)")
  if type == "face" then
    local f = processFace(params)       -- create face object
    table.insert(sceneT, f)			--   put in table
  elseif type == "box" then
    local b = processBox(params)
    table.insert(sceneT, b) 
  elseif type == "sphere" then
    -- create sphere object
    local s = processSphere(params)
    table.insert(sceneT, s)
  else
    print(sf("Cannot handle objects of type %s; ignoring...", type))
  end
end

function processCamera(directive)
  -- local exact = sf(">%s<", directive)
  -- print("Camera directive:", exact)

--  for decl in string.split(directive, "%s*;%s*") do
  for decl in string.gmatch(directive, "[^;]+") do
    local k, v
    _, _, k, v = string.find(decl, "(%w+)%s*=%s*(.*)")
    if k == "loc" then
      local x, y, z = matchTriple(v)
      local p = point.new(x, y, z)
      cameraT[k] = p
    elseif k == "lookat" then
      local x, y, z = matchTriple(v)
      local p = point.new(x, y, z)
      cameraT[k] = p
    elseif k == "upis" then
      local x, y, z = matchTriple(v)
      local p = point.new(x, y, z)
      cameraT[k] = p
    elseif k == "dfrontplane" then
      cameraT[k]= v
    elseif k == "dbackplane" then
      cameraT[k]= v
    elseif k == "halfangle" then
      cameraT[k] = v
    elseif k == "rho" then
      cameraT[k] = v
    end
  end 
end

function calcCameraParams()
  -- Add frustum vertices (DUR) in cameraT
  verts = point.verticesDUR(cameraT["dfrontplane"], cameraT["dbackplane"], cameraT["halfangle"], cameraT["rho"])
  cameraT["verticesDUR"] = verts

  -- Add D, U and R (normalized) to cameraT
  d = point.vector(cameraT["loc"], cameraT["lookat"])
  D = vector.norm(d)
  u = vector.Uvector(D, cameraT["upis"])
  U = vector.norm(u)
  R = vector.cross(D, U)
  cameraT["D"] = D
  cameraT["U"] = U
  cameraT["R"] = R

  -- Add frustum vertices (XYZ) in cameraT
  vertsXYZ = point.DURtoXYZ(verts, cameraT["loc"], D, U, R)
  cameraT["verticesXYZ"] = vertsXYZ

  -- Add frustum normals to cameraT
  norms = {}

  -- FRONT
  pfront = verts["v_br"]
  vec1 = point.vector(pfront,verts["v_bl"])
  vec2 = point.vector(pfront,verts["v_tr"])
  front = vector.cross(vec1,vec2)
  frontNorm = vector.norm(front)
  norms["front"] = frontNorm

  -- BACK
  pback = verts["w_bl"]
  backVec1 = point.vector(pback, verts["w_br"])
  backVec2 = point.vector(pback, verts["w_tl"])
  back = vector.cross(backVec1, backVec2)
  backNorm = vector.norm(back)
  norms["back"] = backNorm

  -- TOP
  zero = {x = 0, y=0, z=0}
  vecTL = point.vector(zero, verts["v_tl"])
  vecTR = point.vector(zero, verts["v_tr"])
  top = vector.cross(vecTL, vecTR)
  topNorm = vector.norm(top)
  norms["top"] = topNorm

  -- BOTTOM
  vecBL = point.vector(zero, verts["v_bl"])
  vecBR = point.vector(zero, verts["v_br"])
  bottom = vector.cross(vecBR, vecBL)
  bottomNorm = vector.norm(bottom)
  norms["bottom"] = bottomNorm

  -- LEFT
  left = vector.cross(vecBL, vecTL)
  leftNorm = vector.norm(left)
  norms["left"] = leftNorm

  -- RIGHT
  right = vector.cross(vecTR, vecBR)
  rightNorm = vector.norm(right)
  norms["right"] = rightNorm

  cameraT["normals"] = norms
end

function read(scenedef)
 
  file = assert(io.open(scenedef, "r"))
  for line in file:lines() do
    line = string.gsub(line, "%s*#.*", "")  -- delete comments
    line = string.gsub(line, "^%s+", "")    -- leading space
    line = string.gsub(line, "%s*;%s*$", "")    -- trailing spaces, semi
    
    if mode==CAMERA then
      if string.find(line, "^aremac") then
        calcCameraParams()
        print "end of camera block"
	print "Camera frontplane specified by halfangle / ratio"
        mode=NONE
      else
      -- process line as camera part
      processCamera(line)
      end
    elseif mode==SCENE then
      if string.find(line, "^enecs") then
        print "end of scene block"
        mode=NONE
      else
      -- process line as scene part
        if line ~= "" then        -- not equal to the null line
          processScene(line)
        end
      end    
    elseif string.find(line, "^camera") then
      print "found camera block"
      mode=CAMERA 
    elseif string.find(line, "^scene") then
      print "found scene block"
      mode=SCENE 
    end
  end
end

-- end of functions



