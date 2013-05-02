# involute gear generator
# simon kirkby
# tigger@interthingy.com
# 20130503
# 
# ported to coffescad from 
# https://github.com/Spiritdude/OpenJSCAD.org/blob/master/examples/gear.jscad
# author: Joost Nieuwenhuijse
# license: MIT License

class Gear extends Part
  constructor:(options)->
    @defaults = {
                 numTeeth : 20,
                 circularPitch: 5,
                 pressureAngle: 20,
                 clearance: 0.2,
                 gearThickness: 5,
                 helixAngle:0,
                 herringbone:0
                 }
    options = @injectOptions(@defaults,options)
    super options
    # some variables
    @pitchRadius = @numTeeth * @circularPitch / (2 * Math.PI)
    @perTooth = 360/@numTeeth
    addendum = @circularPitch / Math.PI
    dedendum = addendum + @clearance
    # radiuses of the 4 circles:
    pitchRadius = @numTeeth * @circularPitch / (2 * Math.PI)
    baseRadius = @pitchRadius * Math.cos(Math.PI * @pressureAngle / 180)
    outerRadius = @pitchRadius + addendum
    rootRadius = @pitchRadius - dedendum
    maxtanlength = Math.sqrt(outerRadius*outerRadius - baseRadius*baseRadius)
      
    maxangle = maxtanlength / baseRadius
    tl_at_pitchcircle = Math.sqrt(pitchRadius*pitchRadius-baseRadius*baseRadius)
    angle_at_pitchcircle = tl_at_pitchcircle / baseRadius
    diffangle = angle_at_pitchcircle - Math.atan(angle_at_pitchcircle)
    angularToothWidthAtBase = Math.PI / @numTeeth + 2*diffangle
    # build a single tooth
    resolution = 5
    points = [[0,0]]
    
    for i in [0..resolution]
      angle = maxangle * i / resolution
      tanlength = angle * baseRadius
      radvector = Vector2D.fromAngle(angle)
      tanvector = radvector.normal()
      p = radvector.times(baseRadius).plus(tanvector.times(tanlength))
      points[i+1] = [p.x,p.y]
      radvector = Vector2D.fromAngle(angularToothWidthAtBase - angle)
      tanvector = radvector.normal().negated()
      p = radvector.times(baseRadius).plus(tanvector.times(tanlength))
      points[2 * resolution + 2 - i] = [p.x,p.y]
      
    toothpoly = new CAGBase.fromPoints(points)
    # add all the teeth together
    t_total = toothpoly.clone()
    for j in [0..@numTeeth]
      t = toothpoly.clone()
      t.rotate([0,0,(360/@numTeeth)*j])
      t_total.union(t)

    if (@herringbone and ( @helixAngle > 0))
      teeth_bot = t_total.extrude({offset:[0,0,@gearThickness/2],twist:@helixAngle})
      @union(teeth_bot)
      t_top = t_total.clone()
      teeth_top = t_top.extrude({offset:[0,0,@gearThickness/2],twist:-@helixAngle})
      teeth_top.rotate([0,0,@helixAngle])
      teeth_top.translate([0,0,@gearThickness/2])
      @union(teeth_top)
    else
      teeth_3d = t_total.extrude({offset:[0,0,@gearThickness],twist:@helixAngle})
      @union(teeth_3d)
    root_cylinder = new Cylinder({r:rootRadius,h:@gearThickness})
    @union(root_cylinder)

class Gear_wheel extends Part
  constructor:(options)->
    @defaults = {
                 rimThickness:4,
                 baseThickness:2
                 }
    options = @injectOptions(@defaults,options)
    super options
    @gear = new Gear(options)
    rim = new Cylinder({r:@gear.pitchRadius-@rimThickness,h:@gearThickness})
    rim.translate([0,0,@baseThickness])
    #@union(rim)
    console.log(rim)
    @gear.subtract(rim)
    
    @union(@gear)

