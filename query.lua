
module("query" , package.seeall) -- use filename as module name;
                            --    see all other modules, e.g., io

require("lsd")

sf=string.format

function whatObjects() 
  print(#lsd.sceneT .. " known objects:")
  for k, v in pairs(lsd.sceneT) do
      print("Name: " .. v["name"] .. ";  type: " .. v["type"])
  end
end

function cameraParams() 
    print("Camera location: (" .. sf("%.3f", (lsd.cameraT["loc"]).x) .. "," 
                               .. sf("%.3f", (lsd.cameraT["loc"]).y) .. ","
                               .. sf("%.3f", (lsd.cameraT["loc"]).z) .. ")")
    print("Camera looking at: (" .. sf("%.3f", (lsd.cameraT["lookat"]).x) .. "," 
                                 .. sf("%.3f", (lsd.cameraT["lookat"]).y) .. ","
                                 .. sf("%.3f", (lsd.cameraT["lookat"]).z) .. ")")
    print("Camera up direction (approx.): (" .. sf("%.3f", (lsd.cameraT["upis"]).x) .. "," 
                                             .. sf("%.3f", (lsd.cameraT["upis"]).y) .. ","
                                             .. sf("%.3f", (lsd.cameraT["upis"]).z) .. ")")
    print("Camera dist to frontplane: " .. sf("%.3f", lsd.cameraT["dfrontplane"]))
    print("Camera dist to backplane: " .. sf("%.3f", lsd.cameraT["dbackplane"]))
    print("Camera frontplane halfangle: " .. sf("%.3f", lsd.cameraT["halfangle"]))
    print("                  ratio: " .. sf("%.3f", lsd.cameraT["rho"]))
end

function directions() 
  print("Directions: D=(" .. sf("%.3f", lsd.cameraT["D"].x) .. "," 
              .. sf("%.3f", lsd.cameraT["D"].y) .. "," 
              .. sf("%.3f", lsd.cameraT["D"].z) .. ")")
  print("            U=(" .. sf("%.3f", lsd.cameraT["U"].x) .. "," 
              .. sf("%.3f", lsd.cameraT["U"].y) .. "," 
              .. sf("%.3f", lsd.cameraT["U"].z) .. ")")
  print("            R=(" .. sf("%.3f", lsd.cameraT["R"].x) .. "," 
              .. sf("%.3f", lsd.cameraT["R"].y) .. "," 
              .. sf("%.3f", lsd.cameraT["R"].z) .. ")")
end

function frustum()-- write to the screen the view-space (D,U,R), coordinates of the 8 vertices
  vertices = lsd.cameraT["verticesDUR"]
  verts = lsd.cameraT["verticesXYZ"]
  print("In (d,u,r) co-ords v_bl= (" .. sf("%.3f", vertices["v_bl"].x) .. ","
                                     .. sf("%.3f", vertices["v_bl"].y) .. ","
                                     .. sf("%.3f",vertices["v_bl"].z) .. ")")
  print("                   v_tl= (" .. sf("%.3f", vertices["v_tl"].x) .. ","
                                     .. sf("%.3f", vertices["v_tl"].y) .. ","
                                     .. sf("%.3f",vertices["v_tl"].z) .. ")")
  print("                   v_br= (" .. sf("%.3f", vertices["v_br"].x) .. ","
                                     .. sf("%.3f", vertices["v_br"].y) .. ","
                                     .. sf("%.3f",vertices["v_br"].z) .. ")")
  print("                   v_tr= (" .. sf("%.3f", vertices["v_tr"].x) .. ","
                                     .. sf("%.3f", vertices["v_tr"].y) .. ","
                                     .. sf("%.3f",vertices["v_tr"].z) .. ")")
  print("                   w_bl= (" .. sf("%.3f", vertices["w_bl"].x) .. ","
                                     .. sf("%.3f", vertices["w_bl"].y) .. ","
                                     .. sf("%.3f",vertices["w_bl"].z) .. ")")
  print("                   w_tl= (" .. sf("%.3f", vertices["w_tl"].x) .. ","
                                     .. sf("%.3f", vertices["w_tl"].y) .. ","
                                     .. sf("%.3f",vertices["w_tl"].z) .. ")")
  print("                   w_br= (" .. sf("%.3f", vertices["w_br"].x) .. ","
                                     .. sf("%.3f", vertices["w_br"].y) .. ","
                                     .. sf("%.3f",vertices["w_br"].z) .. ")")
  print("                   w_tr= (" .. sf("%.3f", vertices["w_tr"].x) .. ","
                                     .. sf("%.3f", vertices["w_tr"].y) .. ","
                                     .. sf("%.3f",vertices["w_tr"].z) .. ")")

  print("In (x,y,z) co-ords v_bl= (" .. sf("%.3f", verts["v_bl"].x) .. ","
                                     .. sf("%.3f", verts["v_bl"].y) .. ","
                                     .. sf("%.3f",verts["v_bl"].z) .. ")")
  print("                   v_tl= (" .. sf("%.3f", verts["v_tl"].x) .. ","
                                     .. sf("%.3f", verts["v_tl"].y) .. ","
                                     .. sf("%.3f",verts["v_tl"].z) .. ")")
  print("                   v_br= (" .. sf("%.3f", verts["v_br"].x) .. ","
                                     .. sf("%.3f", verts["v_br"].y) .. ","
                                     .. sf("%.3f",verts["v_br"].z) .. ")")
  print("                   v_tr= (" .. sf("%.3f", verts["v_tr"].x) .. ","
                                     .. sf("%.3f", verts["v_tr"].y) .. ","
                                     .. sf("%.3f",verts["v_tr"].z) .. ")")
  print("                   w_bl= (" .. sf("%.3f", verts["w_bl"].x) .. ","
                                     .. sf("%.3f", verts["w_bl"].y) .. ","
                                     .. sf("%.3f",verts["w_bl"].z) .. ")")
  print("                   w_tl= (" .. sf("%.3f", verts["w_tl"].x) .. ","
                                     .. sf("%.3f", verts["w_tl"].y) .. ","
                                     .. sf("%.3f",verts["w_tl"].z) .. ")")
  print("                   w_br= (" .. sf("%.3f", verts["w_br"].x) .. ","
                                     .. sf("%.3f", verts["w_br"].y) .. ","
                                     .. sf("%.3f",verts["w_br"].z) .. ")")
  print("                   w_tr= (" .. sf("%.3f", verts["w_tr"].x) .. ","
                                     .. sf("%.3f", verts["w_tr"].y) .. ","
                                     .. sf("%.3f",verts["w_tr"].z) .. ")")

normals = lsd.cameraT["normals"]

pfront = vertices["v_br"]
front = normals["front"]
print("The frustum planes: front: n=(" .. sf("%.3f", front.x) .. ","
                                       .. sf("%.3f", front.y) .. ","
                                       .. sf("%.3f", front.z) .. "); p=("
                                       .. sf("%.3f", pfront.x) .. ","
                                       .. sf("%.3f", pfront.y) .. ","
                                       .. sf("%.3f", pfront.z) .. ")")
pback = vertices["w_bl"]
back = normals["back"]
print("                     back: n=(" .. sf("%.3f", back.x) .. ","
                                       .. sf("%.3f", back.y) .. ","
                                       .. sf("%.3f", back.z) .. "); p=("
                                       .. sf("%.3f", pback.x) .. ","
                                       .. sf("%.3f", pback.y) .. ","
                                       .. sf("%.3f", pback.z) .. ")")
zero = {x = 0, y=0, z=0}
top = normals["top"]
print("                      top: n=(" .. sf("%.3f", top.x) .. ","
                                       .. sf("%.3f", top.y) .. ","
                                       .. sf("%.3f", top.z) .. "); p=("
                                       .. sf("%.3f", zero.x) .. ","
                                       .. sf("%.3f", zero.y) .. ","
                                       .. sf("%.3f", zero.z) .. ")")

bottom = normals["bottom"]
print("                   bottom: n=(" .. sf("%.3f", bottom.x) .. ","
                                       .. sf("%.3f", bottom.y) .. ","
                                       .. sf("%.3f", bottom.z) .. "); p=("
                                       .. sf("%.3f", zero.x) .. ","
                                       .. sf("%.3f", zero.y) .. ","
                                       .. sf("%.3f", zero.z) .. ")")
left = normals["left"]
print("                     left: n=(" .. sf("%.3f", left.x) .. ","
                                       .. sf("%.3f", left.y) .. ","
                                       .. sf("%.3f", left.z) .. "); p=("
                                       .. sf("%.3f", zero.x) .. ","
                                       .. sf("%.3f", zero.y) .. ","
                                       .. sf("%.3f", zero.z) .. ")")
right = normals["right"]
print("                    right: n=(" .. sf("%.3f", right.x) .. ","
                                       .. sf("%.3f", right.y) .. ","
                                       .. sf("%.3f", right.z) .. "); p=("
                                       .. sf("%.3f", zero.x) .. ","
                                       .. sf("%.3f", zero.y) .. ","
                                       .. sf("%.3f", zero.z) .. ")")


end

function visible()
  -- loop through all objects
  for _,v in pairs(lsd.sceneT) do
    objN = v["norms"]
    outside = true
    -- loop trough the objects normals
    for _, n in pairs(objN) do
      -- loop through all frustum-normals
      for _, fn in pairs(lsd.cameraT["normals"]) do
        -- compare the object-normal against the frustum-normals
        check = plane.outsideCheck(fn, lsd.cameraT["halfangle"], n)
        if check == false then
          outside = false
        end
      end
    end
    if outside == true then
      print("Object " .. v["name"] .. " is outside ")
    end
  end
 
end

