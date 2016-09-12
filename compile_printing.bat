#!/bin/sh

#ball returns
openscad -o ball_return/ballreturn_inlet_2.stl -D part=0 ball_return/ball_return.scad &
openscad -o ball_return/ballreturn_inlet_3.stl -D part=2 ball_return/ball_return.scad &
openscad -o ball_return/ball_return_outlet.stl -D part=1 ball_return/ball_return.scad &

openscad -o screw_drop/bd_2_5.stl -D part=0 screw_drop/bowl_drop.scad &
openscad -o screw_drop/bd_3_5.stl -D part=1 screw_drop/bowl_drop.scad &
openscad -o screw_drop/bd_inlet_5.stl -D part=2 screw_drop/bowl_drop.scad &
openscad -o screw_drop/bd_outlet_3.stl -D part=3 screw_drop/bowl_drop.scad &
