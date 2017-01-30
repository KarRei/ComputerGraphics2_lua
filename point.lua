module("point", package.seeall)

require("lsd")

function new(x, y, z)
  return { x=x, y=y, z=z } -- create and return table (struct / class)
end

function vector(p, q)  -- the vector from p to q
  return { x=q.x-p.x, y=q.y-p.y, z=q.z-p.z }
end

function verticesDUR(dfront, dfar, angle, ratio)
  rad = (math.pi/180) * angle
  un = math.tan(rad) * dfront
  rn = ratio * un
  uf = math.tan(rad) * dfar
  rf = ratio * uf
  verts = {}

  verts["v_bl"] = new(dfront, -un, -rn)
  verts["v_tl"] = new(dfront, un, -rn)
  verts["v_br"] = new(dfront, -un, rn)
  verts["v_tr"] = new(dfront, un, rn)

  verts["w_bl"] = new(dfar, -uf, -rf)
  verts["w_tl"] = new(dfar, uf, -rf)
  verts["w_br"] = new(dfar, -uf, rf)
  verts["w_tr"] = new(dfar, uf, rf)

  return verts
end

function DURtoXYZ(verts, loc, D, U, R)
  vertsXYZ = {}

 
  det = 1 / (D.x*((U.y*R.z)-(U.z*R.y))-D.y*((U.x*R.z)-(U.z*R.x))+D.z*((U.x*R.y)-(U.y*R.x)))
  -- Inverse matrix
  row1 = {x= ((U.y*R.z)-(U.z*R.y)), y=((D.z*R.y)-(D.y*R.z)), z=((D.y*U.z)-(D.z*U.y))}
  row2 = {x= ((U.z*R.x)-(U.x*R.z)), y=((D.x*R.z)-(D.z*R.x)), z=((D.z*U.x)-(D.x*U.z))}
  row3 = {x= ((U.x*R.y)-(U.y*R.x)), y=((D.y*R.x)-(D.x*R.y)), z=((D.x*U.y)-(D.y*U.x))}

  for k, p in pairs(verts) do
    -- Point * matrix
    pr = {x=det*(p.x*row1.x + p.y*row1.y + p.z*row1.z), 
          y=det*(p.x*row2.x + p.y*row2.y + p.z*row2.z), 
          z=det*(p.x*row3.x + p.y*row3.y + p.z*row3.z)}

    prt = {x= pr.x + loc.x, y= pr.y + loc.y, z= pr.z + loc.z}
    vertsXYZ[k] = prt
  end

 return vertsXYZ
  
end
