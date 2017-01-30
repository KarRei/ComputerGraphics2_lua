module("vector", package.seeall)

function norm(vec)
local scaleFactor  = 1 / (math.sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z))
return {x = scaleFactor * vec.x, y = scaleFactor * vec.y, z = scaleFactor * vec.z}
end

function Uvector(dir, up)
  local beta = ((dir.x*up.x) + (dir.y*up.y) + (dir.z*up.z)) / ((dir.x*dir.x) + (dir.y*dir.y) + (dir.z*dir.z))--dot(dir, up)/dot(dir,dir);
  return {x = up.x - (beta*dir.x), y = up.y - (beta*dir.y), z = up.z - (beta*dir.z)}-- u - beta * dir
end

function cross(v, u)
return {x= (v.y*u.z)-(v.z*u.y), y= -((v.x*u.z)-(v.z*u.x)) , z=(v.x*u.y)-(v.y*u.x)}
end


