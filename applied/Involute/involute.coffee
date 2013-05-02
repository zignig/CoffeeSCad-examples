include("gear.coffee")
    
g = new Gear_wheel({
                    numTeeth:15,
                    gearThickness:10,
                    rimThickness:5,
                    herringbone:1,
                    helixAngle:20
                    })
assembly.add(g)

g2 = new Gear_wheel({numTeeth:20,gearThickness:10})
g2.translate([40,0,0])
g2.color([1,0.5,0.5])
assembly.add(g2)

g3 = new Gear_wheel({
                     numTeeth:23,
                     helixAngle:10,
                     gearThickness:10,
                     pressureAngle:30})
g3.translate([-40,0,0])
g3.color([0.4,1,0.4])
assembly.add(g3)
