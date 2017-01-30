module("plane", package.seeall)

require("point")
require("vector")

function outsideCheck(planeN, theta, objN)

  case2 = math.cos ( math.pi/2 + theta)
  dp= planeN.x*objN.x + planeN.y*objN.y + planeN.z*objN.z

  if dp<=case2 then
    return true
  elseif dp >= case2 then
    return false
  end
end

function boxNormals(blf, trb)
  
  verts = {}

  blf = { x= blf.x, y= blf.y, z= blf.z }
  verts["blf"] = blf
  verts["brf"] = { x= trb.x, y= blf.y, z= blf.z }
  verts["tlf"] = { x= blf.x, y= trb.y, z= blf.z }
  verts["trf"] = { x= trb.x, y= trb.y, z= blf.z }
  verts["trb"] = { x= trb.x, y= trb.y, z= trb.z }
  verts["tlb"] = { x= blf.x, y= trb.y, z= trb.z }
  verts["brb"] = { x= trb.x, y= blf.y, z= trb.z }
  verts["blb"] = { x= blf.x, y= blf.y, z= trb.z }

  norms = {}
  
  vecTop1 = point.vector(verts["trb"],verts["trf"])
  vecTop2 = point.vector(verts["tlf"],verts["trf"])
  norms["top"] = vector.norm(vector.cross(vecTop1, vecTop2))

  vecBottom1 = point.vector(verts["blf"],verts["brf"])
  vecBottom2 = point.vector(verts["brb"],verts["brf"])
  norms["bottom"] = vector.norm(vector.cross(vecBottom1, vecBottom2))

  vecLeft1 = point.vector(verts["tlf"],verts["blf"])
  vecLeft2 = point.vector(verts["blb"],verts["blf"])
  norms["left"] = vector.norm(vector.cross(vecLeft1, vecLeft2))

  vecRight1 = point.vector(verts["brb"],verts["brf"])
  vecRight2 = point.vector(verts["trf"],verts["brf"])
  norms["right"] = vector.norm(vector.cross(vecRight1, vecRight2))

  vecFront1 = point.vector(verts["tlf"],verts["trf"])
  vecFront2 = point.vector(verts["brf"],verts["trf"])
  norms["front"] = vector.norm(vector.cross(vecFront1, vecFront2))

  vecBack1 = point.vector(verts["blb"],verts["brb"])
  vecBack2 = point.vector(verts["trb"],verts["brb"])
  norms["back"] = vector.norm(vector.cross(vecBack1, vecBack2))

  return norms
end

function BBVerts(ctr, rad)

  blf = {x= ctr.x - rad,
         y= ctr.y - rad,
         z= ctr.z - rad}
  trb = {x= ctr.x + rad,
         y= ctr.y + rad,
         z= ctr.z + rad}

  return boxNormals(blf,trb)
end
